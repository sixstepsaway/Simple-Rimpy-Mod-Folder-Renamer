Function Out-Script {
    Write-Host "Finishing up."
    $endingVars = Get-Variable
    Remove-Variable $endingVars -Exclude $startingVars
    Exit
}

Function Start-RenameFoldersFromXML {
    param (
        [string]$location
    )
    $folderList = Get-ChildItem $location -Directory
    $matchlist = @(":"
    "*"
    "|"
    "?"
    "!"
    "/"
    <#to add another match to this list, simply hit enter after the last match (for example: "/") and add your own in double quotes (for example: "^"). This character will be removed from any file names.#>)
    $replacelist = ""

    foreach ($subfolder in $folderList) {
        Write-Verbose "Parsing $($subfolder.BaseName)."
        [xml]$xml = Get-Content "$subfolder\About\About.xml"
        Write-Verbose "Parsing XML at $subfolder\About\About.xml."
        $newName = $xml.ModMetaData.name
        for ($i=0; $matchlist.Count -gt $i; $i++) {
            $newName = $newName -replace [regex]::Escape($matchlist[$i]),$replacelist
        }
        $newname = "$newName`_$($subfolder.BaseName)"
        Write-Verbose "New name will be $newName."
        if ($debugMode -eq 0) {
            Rename-Item $subfolder -NewName $newName -WhatIf
            Write-Verbose "File has not been renamed as script is running in debug mode."
        } else {
            Rename-Item $subfolder -NewName $newName
        }
        Continue
    }
}

Function Start-UndoRename {
    param (
        [string]$location
    )

    $folderList = Get-ChildItem $location -Directory

    foreach ($item in $folderList) {
        Write-Verbose "Parsing $($item.BaseName)." 
        $item.BaseName -match "(\d\d\d\d\d+)" | Out-Null
        $newname = $($matches[0])
        Write-Verbose "New name will be $newName."
        if ($debugMode -eq 0) {
            Rename-Item $item -NewName $newName -WhatIf
            Write-Verbose "File has not been renamed as script is running in debug mode."
        } else {
            Rename-Item $item -NewName $newName
        }
        Continue
    }
}

Function Start-RedownloadRimworldMods {
    # use steamcmd directly with the script below
}

Function Start-GetSteamIDs {
    param(
        [string]$folders
    )
    $script:steamIDs = @()
    $foldersfull = Get-ChildItem $folders
    foreach ($folder in $foldersfull) {
        if ($folder.BaseName -ne "04a_Options - NSFW" -and $folder.BaseName -ne "00_Outside Mods") {
            $subfolders = Get-ChildItem $folder
            foreach ($subfolder in $subfolders) {
                $script:steamIDs += $subfolder.BaseName
            }
        }
    }
}

Function Start-MakeSteamScript { 
    param(
        [string]$steamscriptfolder
    )
    $steamscript = "$steamscriptfolder\steamscript.txt"
    "@ShutdownOnFailedCommand 0 // stops it from exiting if an error happens" | Out-File $steamscript
    "@NoPromptForPassword 1 // won't ask you for the password" | Out-File $steamscript -Append 
    "login anonymous" | Out-File $steamscript -Append 
    foreach ($id in $script:steamIDs) {
        if ($id -inotmatch "[a-z]") {
            "workshop_download_item 294100 $id" | Out-File $steamscript -Append
        }
    }
    "quit" | Out-File $steamscript -Append
}

$startingVars = Get-Variable
$PSStyle.Progress.View = 'Minimal'

$yesNoQuestion = "&Yes", "&No"

$redownload = $Host.UI.PromptForChoice("Redownload", "Are you getting the IDs for a redownload?", $yesNoQuestion, 1)

if ($redownload -eq 0) { 
    $originalfolders = Read-Host "Where is the folder full of folders? (For example: C:\Games\Rimworld\Mods)"
    $steamscriptfolder = Read-Host "Save script where? (folder only, script will be named steamscript.txt)"
    Start-GetSteamIDs -folders $originalfolders
    Start-MakeSteamScript -steamscriptfolder $steamscriptfolder
} elseif ($redownload -eq 1) {
    $undo = $Host.UI.PromptForChoice("Undo", "Is this an undo run?", $yesNoQuestion, 1)

    $debugMode = $Host.UI.PromptForChoice("Debug", "Run in debug mode?", $yesNoQuestion, 1)

    if ($debugMode -eq 0) {
        $VerbosePreference = "Continue"
        Write-Verbose "This script is running in debug mode. No real changes will be made to your folders."
    } else {
        $VerbosePreference = "SilentlyContinue"
    }

    $alreadySubfolders = $Host.UI.PromptForChoice("Subfolders", "Are your files already in subfolders? (For example you're linking to a folder containing folders such as `"Factions`" and `"Scenarios`" and within those folders live the numbered workshop folders.)", $yesNoQuestion, 1)

    if ($undo -eq 1) {
        if ($alreadySubfolders -eq 1) {
            $inputfolder = Read-Host "Where is the folder full of folders? (For example: C:\Games\Rimworld\Mods)"
            Start-RenameFoldersFromXML -location $inputfolder
        } elseif ($alreadySubfolders -eq 0) {
            $inputfolder = Read-Host "Where is the folder full of semi-organized folders? (For example: C:\Games\Rimworld\Mods which contains folders like `"Factions`" and `"Animals`")"
            $foldertoparse = Get-ChildItem $inputfolder
            $NumberOfFolders = $foldertoparse.Count
            foreach ($folder in $foldertoparse) {    
                $Completed = ($i/$NumberOfFolders) * 100
                Write-Progress -Id 0 -Activity "Parsing Containing Folders" -Status "Progress: " -PercentComplete $Completed
                Write-Host "Sending $($folder.BaseName) to function."
                Start-RenameFoldersFromXML -location $folder
            }
        }
    }

    if ($undo -eq 0) {
        if ($alreadySubfolders -eq 1) {
                $foldertoparse = Read-Host "Where is the folder full of folders? (For example: C:\Games\Rimworld\Mods)"
                Start-UndoRename -location $foldertoparse
        } elseif ($alreadySubfolders -eq 0) {
            $foldertoparse = Read-Host "Where is the folder full of semi-organized folders? (For example: C:\Games\Rimworld\Mods which contains folders like `"Factions`" and `"Animals`")"
            $NumberOfFolders = $folderthatcontainsfolders.Count
            foreach ($folder in $foldertoparse) {    
                $Completed = ($i/$NumberOfFolders) * 100
                Write-Progress -Id 0 -Activity "Parsing Containing Folders" -Status "Progress: " -PercentComplete $Completed
                Write-Host "Sending $($folder.BaseName) to function."
                Start-UndoRename -location $folder
            }
        }
    }

    if ($debugMode -eq 0) {
        Write-Verbose "Console paused so you can check for errors."
        Pause
    }
}



Out-Script
