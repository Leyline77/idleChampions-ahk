# Standard Readme
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

# idleChampions-ahk
Idle Champions of the Forgotten Realms AHK Macro Scripts

 The purpose of this macro script is to automate levelups on Idle Champions of the forgotton Realms
 
 This script requires AutohotKey (AHK) to run.
 
 It was developed and tested on Version 1.1.33.10 https://www.autohotkey.com


# Contributors
- Original Author: Abydos, Fritz
- orig filename: idlechamp-v1.4.ahk
- from striderx2048 210614
- edited retaki
- edited Leyline (discord: Swamp Fox II) 2021-09-23
   - fix auto progress - was only pressing G this would turn it off for 30 mins, turn it on for 30 mins.  now it will break progress with {left} and then g to continue
   - Clarified some GUI options, such as repeat Formation
   - Simplified GUI with Rate in Seconds or Minutes or Hours as appropriate instead of milliseconds
   - Fixed variables and labels (subroutines) having the same name vAutoUlt sets AutoUlt & AutoUlt as a method...  Separated into VAutoUltimates and doAutoUltimates
   - added temporary tooltips to show setting effects
   - add gui boxes and sections for better gui positioning
   - fix bug where setting or clearing all level/ult checks did not also update the pointers (it would continue with old settings until gui submit runs)
   - added game feature to change formations at certain time elapsed since setting checked off

# Helpful tips

- if you set your rate to 1 second, and then you have a hard time changing settings because the spamming is focusing out,
- use the PAUSE / BREAK key on your keyboard to pause the script.
- if you want to restart the Increment Formations Timer you can reload the script.  (I will add a reset button later)
- you can "increment" the formations in any order by setting them to a lower Time than another.
- you can pick just one formation to increment by only setting a time for that formation.

# todo 2021-09-23

- add rate / time for autoprogress to repeat on
- add a checkbox / setting to allow NumpadSub or choose a hotkey to reload the script?
- add a checkbox / setting that chooses a different hotkey for pause / unpause
