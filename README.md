# A Snowball's Chance
An original RPG Maker XP game abut hiking, cooking, friendship, mental illness, hypothermia, and psychic powers or something.
One of those earthbound-inspired games about depression probably?

# How To Work On The Project

## Installing Stuff
1. Install git. Windows version located at https://git-scm.com/download/win
2. Install Ruby. Windows installer located at https://rubyinstaller.org/downloads/

## Working With Git
1. Do this tutorial: https://try.github.io
2. Any questions? PM Blaze and she'll try to help you.

## How to do this shit in a more user-friendly manner -- -
1.  download a fucking visual client, it will save your fucking life. I'm pretty sure github has its own program for this shit. I use that one.
2.  clone the repository, grabbing the link and feeding it to the client somehow
3.  let it do the work to give you a local up to date copy
4.  announce that you're going to edit the files!!! Especially if you're not the only one working on them!!!
5.  find the game.bat. do yourself a favor and make a shortcut to it on your desktop. you'll thank me later.
6.  hit the bat to begin editing the game! it should open the editor after messing with the files for a while. __Make sure the bat is open at all times when you're editing.__
7.  Save your progress and close the editor, let the bat collect the files afterwards
8.  write up your "commit", which will explain what in the fuck you actually did to the files. It will register as a bunch of YAML files, because somehow those are more readable than RMXP's serialized files.
9.  Don't forget to write up a to-do list for next time, so you can have tasks set up for you to tackle next time.
10.  push the commit and you're good to go!

v (the following down there is the old method) v

## Cloning The Repository
1. Open Git Bash
2. type `git clone https://github.com/FallingStar-Games/snowballschance.git` and hit enter.
3. Press Win+R
4. type `%USERPROFILE%\snowballschance` and hit enter
5. You should now have an explorer window open in the RPG Maker project directory
6. Click on `Import.bat` and hit enter. This will build the game's files.
7. Open the project in RPG Maker XP, make any changes you want, and then save the project. Remember to close RPG Maker XP.
8. Run `Export.bat` again to prepare your changes to be committed.
9. go back to Git Bash, type `cd snowballschance` and hit enter.
10. Still in Git Bash, run the command `git commit -A` and then run `git commit -m "[MESSAGE]"` NOTE: remember to replace `[MESSAGE]` with a description of what changes you've made. For example, if you changed MAP001, you would run the command `git commit -m "changed MAP001"`
11. Then, simply run `git push origin master` and you're done!

