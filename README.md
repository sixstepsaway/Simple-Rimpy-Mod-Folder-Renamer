![GitHub release (latest by date)](https://img.shields.io/github/v/release/sixstepsaway/Simple-Rimpy-Mod-Folder-Renamer?style=flat-square) ![GitHub](https://img.shields.io/github/license/sixstepsaway/Simple-Rimpy-Mod-Folder-Renamer?style=flat-square) ![GitHub all releases](https://img.shields.io/github/downloads/sixstepsaway/Simple-Rimpy-Mod-Folder-Renamer/total) ![built in powershell](https://img.shields.io/badge/built%20in-powershell-informational)

# Simple-Rimpy-Mod-Folder-Renamer

### Contents: 

- [How to Use](#how-to-use)
- [Questions/FAQ](#questions-i-can-imagine-being-asked)
- [License](#license)

(the info below was originally posted to r/Rimworld.)

I'm really organized. I'm, like, annoyingly organized and have, in the past, been asked why modding is so fun for me and honestly the organization is probably why. I'm also used to modding things like Minecraft (ah, the delight of being able to have 10k separate modpacks) or the Sims (sub-folders. SUB-FOLDERS), so although Rimpy is great, it isn't as organized as I'd like.

I've downloaded over 1000 mods from the workshop this week. We won't get into the ✨ that ✨ of it all right now, but as you can imagine the game had bugs crawling out if it's butthole faster than my pawns being warcrimed, and I've spent a lot of this week moving things around and trying to figure out what's breaking it. The main snag for me has been that when I open my Rimpy mods folder it's all just numbers and so I can't sift through and figure out what I'm looking at or for.

I'm probably going to have to do some XML tweaks/modding soon and how am I meant to do that if finding what folder is what is so gods damn difficult?

Which is why I whipped this powershell script up. Tadah!

This script renames all those annoying steam workshop folders from something like "00398083048348" to "Sixstepsaway's Totally Real Mod" using the About.xml it comes with.

Changing the name of the folder doesn't affect RimPy picking it up in the slightest. It might affect RimPy being able to redownload things via right-click but I'm pretty sure it uses the info in the XML for that too, so it shouldn't.

### More technical info for those who are nervous:

Here's the rundown:

The first function in the script is "Out-Script", this is a simple function I add to all of my Powershell scripts which makes a note of all the variables and deletes any that have changed since the script was first run. It also posts a message that says, "Finishing up," at the end of running the entire script.

The second function is "Start-RenameFoldersFromXML". This takes the folder location, dips inside, gets the About/About.xml, finds <name> inside of that, and saves that to a variable. The variable is then renamed according to the $matchlist to remove any illegal folder characters (so far: ":", "*", "|" "?", "!" and "/" have all snuck in). It doesn't change the About.xml or anything inside the folder, just this variable.

It then runs Rename-Item and changes the folder from the workshop numbers to the name of the mod in question, before moving on to the next folder.

The part that runs the script includes "$startingVars = Get-Variable", which is how the Out-Script works to remove new variables (by making a note of what the script starts with). There might be a better way of doing this, but idk what that is yet and I'm sick of having my variables stick between sessions of debugging. It also includes "PSStyle.Progress.View = 'Minimal'" which is how the progress bar works.

Then the script asks if you already have subfolders like I did, checks what your answer is (yes or no) and then asks a second question according to that answer. You put the location of your folders into the box in response to that question, and then it runs a foreach loop and goes through each folder and sends the subfolders (the mods) over to the original function to rename the folders.

Finally, it runs my Out-Script.

If it can't rename a folder for whatever reason, it'll throw an error. If it says the folder can't be accessed, you'll have to rename it manually (but, really, one or two instead of hundreds is much better). If it says it can't rename it because the parameter is wrong, it's likely a symbol problem. At that point, you can run the script again and say yes when asked about debug mode. This will make the script not rename anything (you can also run this first to check how things will go, if you so wish) but show you what it would rename and where the issues lie. It'll show any special characters and you can discern from there what to add to the $matchlist. You can open the .ps1 file in Notepad and add to the $matchlist anything that passed me by when I was scripting this.


### Technical babble ends

I've run it over my own mod list once already and it works great. I also ran it over a randomly picked large collection I downloaded to have new numbered folders to test it on when I decided to share it with you lot and it works great there too. It took about two seconds, as well, which is a marked improvement over how god forsakenly long it takes to rename my Sims 4 CC a similar way.

Obviously this isn't something that'll be useful for everyone, idk if it'll be useful for anyone except me actually, but I figured if it was something I'd use, it's something someone else might, so I decided to share it.

If you have any questions, concerns or suggestions, feel free to reply here or on the Github's issue tracker. Hope this helps someone!
  
# How to Use
You can either download the .ps1 file from above or the .zip from releases. If you get the zip, simply unzip it somewhere on your PC and run the .ps1 file. Windows should automatically have Powershell installed, but if not you can get it from [the Microsoft Store](https://apps.microsoft.com/store/detail/powershell/9MZ1SNWT0N5D?hl=en-us&gl=us) or from [their Github](https://github.com/PowerShell/PowerShell). Powershell is the natural successor to the command prompt on Windows and is a very valuable tool to have installed anyway. 

Run RimpyModFolderRenamer.ps1 with Powershell and answer the prompts. You won't want Debug Mode unless something doesn't work as intended (folders left un-renamed). 

If folders _are_ left un-renamed, optionally scoot out the folders that were already renamed (you don't have to, but it'll generate a lot of "path and destination can't have the same name" errors) and then run the script again but this time in Debug Mode. It'll tell you which ones didn't rename and will give you the name it was going to rename the folders into. You'll notice that the folders in question will have a name like "Burger w/ fries" or "MyMod21 | Patch". It'll probably be an illegal character causing the rename not to go through, at which point you just want to add the character to the replace list. 

To add a character to the replace list, right click RimpyModFolderRenamer.ps1 and open it in Notepad (or Notepad++, preferably, or Powershell's IDE, or Visual Studio Code, whatever you have installed). Scroll down until you find "$matchlist =" (which is on line 13, for those using Notepad++ or similar) and then scroll to the bottom of the list (the items enclosed in brackets) and add your own symbol to the list.

There is a commented area that explains there. Place your new item above it. 

So, for example: 

```$matchlist = @("."
    ":"
    "*"
    "|"
    "?"
    "!"
    "/"
    <#to add another match to this list, simply hit enter after the last match (for example: "/") and add your own in double quotes (for example: "^"). This character will be removed from any file names.#>)
```

will become

```$matchlist = @("."
    ":"
    "*"
    "|"
    "?"
    "!"
    "/"
    "your new replaced item here"
    <#to add another match to this list, simply hit enter after the last match (for example: "/") and add your own in double quotes (for example: "^"). This character will be removed from any file names.#>)
```

You can add as many symbols or words as required to this list and they will be removed during rename.

If you have any problems, please [let me know](https://github.com/sixstepsaway/Simple-Rimpy-Mod-Folder-Renamer/issues). 
  
# Questions I Can Imagine Being Asked 

#### Will this explode or damage my PC?
No. You're not messing with the actual code (unless you decide to) so you won't do any damage.

#### Will this ruin my RimPy setup? 
No, but if you're nervous you can make backups. 

#### Is this okay?
Why would it not be?
  
# License

MIT, do with this whatever you like, just please don't redistribute it and say you did it yourself, that's not cool. Feel free to take my code apart, figure out how I did what I did, refactor it, fork it into other things or outwards in other ways, whatever. 
