# Simple-Rimpy-Mod-Folder-Renamer

(this info was originally posted to r/Rimworld.)

I'm really organized. I'm, like, annoyingly organized and have, in the past, been asked why modding is so fun for me and honestly the organization is probably why. I'm also used to modding things like Minecraft (ah, the delight of being able to have 10k separate modpacks) or the Sims (sub-folders. SUB-FOLDERS), so although Rimpy is great, it isn't as organized as I'd like.

I've downloaded over 1000 mods from the workshop this week. We won't get into the ✨ that ✨ of it all right now, but as you can imagine the game had bugs crawling out if it's butthole faster than my pawns being warcrimed, and I've spent a lot of this week moving things around and trying to figure out what's breaking it. The main snag for me has been that when I open my Rimpy mods folder it's all just numbers and so I can't sift through and figure out what I'm looking at or for.

I'm probably going to have to do some XML tweaks/modding soon and how am I meant to do that if finding what folder is what is so gods damn difficult?

Which is why I whipped this powershell script up. Tadah!

This script renames all those annoying steam workshop folders from something like "00398083048348" to "Sixstepsaway's Totally Real Mod" using the About.xml it comes with.

Changing the name of the folder doesn't affect RimPy picking it up in the slightest. It might affect RimPy being able to redownload things via right-click but I'm pretty sure it uses the info in the XML for that too, so it shouldn't.

##More technical info for those who are nervous:

Here's the rundown:

The first function in the script is "Out-Script", this is a simple function I add to all of my Powershell scripts which makes a note of all the variables and deletes any that have changed since the script was first run. It also posts a message that says, "Finishing up," at the end of running the entire script.

The second function is "Start-RenameFoldersFromXML". This takes the folder location, dips inside, gets the About/About.xml, finds <name> inside of that, and saves that to a variable. The variable is then renamed according to the $matchlist to remove any illegal folder characters (so far: ":", "*", "|" "?", "!" and "/" have all snuck in). It doesn't change the About.xml or anything inside the folder, just this variable.

It then runs Rename-Item and changes the folder from the workshop numbers to the name of the mod in question, before moving on to the next folder.

The part that runs the script includes "$startingVars = Get-Variable", which is how the Out-Script works to remove new variables (by making a note of what the script starts with). There might be a better way of doing this, but idk what that is yet and I'm sick of having my variables stick between sessions of debugging. It also includes "PSStyle.Progress.View = 'Minimal'" which is how the progress bar works.

Then the script asks if you already have subfolders like I did, checks what your answer is (yes or no) and then asks a second question according to that answer. You put the location of your folders into the box in response to that question, and then it runs a foreach loop and goes through each folder and sends the subfolders (the mods) over to the original function to rename the folders.

Finally, it runs my Out-Script.

If it can't rename a folder for whatever reason, it'll throw an error. If it says the folder can't be accessed, you'll have to rename it manually (but, really, one or two instead of hundreds is much better). If it says it can't rename it because the parameter is wrong, it's likely a symbol problem. At that point, you can run the script again and say yes when asked about debug mode. This will make the script not rename anything (you can also run this first to check how things will go, if you so wish) but show you what it would rename and where the issues lie. It'll show any special characters and you can discern from there what to add to the $matchlist. You can open the .ps1 file in Notepad and add to the $matchlist anything that passed me by when I was scripting this.

##End technical babble.

I've run it over my own mod list once already and it works great. I also ran it over a randomly picked large collection I downloaded to have new numbered folders to test it on when I decided to share it with you lot and it works great there too. It took about two seconds, as well, which is a marked improvement over how god forsakenly long it takes to rename my Sims 4 CC a similar way.

Obviously this isn't something that'll be useful for everyone, idk if it'll be useful for anyone except me actually, but I figured if it was something I'd use, it's something someone else might, so I decided to share it.

If you have any questions, concerns or suggestions, feel free to reply here or on the Github's issue tracker. Hope this helps someone!
