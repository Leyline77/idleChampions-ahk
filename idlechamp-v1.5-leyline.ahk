; Original Author: Abydos, Fritz
; orig filename: idlechamp-v1.4.ahk
; from striderx2048 210614
; edited retaki
; credit to https://github.com/mikebaldi/Idle-Champions with courtesy permission to use
;
; Current Version: 1.6.0
;
; edited Leyline (Discord: Swamp Fox II) 2021-09-23
;	https://github.com/Leyline77/idleChampions-ahk
;
;	This script adopted and maintained for the benefit of the gaming community.  It is free to use for non commercial purposes.
;
;	Idle Champions of the Forgotten Realms AHK Macro Scripts
;	The purpose of this macro script is to automate levelups and simple tasks in the game: Idle Champions of the forgotton Realms
;		Requires AutohotKey (AHK) to run.
;		Developed and tested on AHK Version 1.1.33.10 https://www.autohotkey.com
;		Works by sending key or mouse clicks to the game client window, it does not read or edit memory.
;		Developed and defaults for screen 1280x720
;
;	Helpful tips:
;	Use the PAUSE / BREAK key on your keyboard to pause the script.
;		example: If you set your rate to 1 second or turn on a clicking feature,
;		you may have a hard time changing settings because the click / key spam is focuses back to IC
;	The script has a 3s delay for typing safety, if you have pressed a key (anywhere in your PC) recently, you may think the script did not fire
;		correct: it skipped the command and it will pick itself back up in the next loop (after 3s that is)
;	Increment Formations:
;		if you want to restart the Increment Formations Timer you can reload the script.  (I will add a reset button later)
;		you can "increment" the formations in any order by setting them to a lower Time than another.
;		you can pick just one formation to increment by only setting a time for that formation.
;
;	1.5.0
;		started development off ot the 1.4e code base
;		fix auto progress - was only pressing G this would turn it off for 30 mins, turn it on for 30 mins.  now it will break progress with {left} and then g to continue
;		Clarified some GUI options, such as repeat Formation
;		Simplified GUI with Rate in Seconds or Minutes or Hours as appropriate instead of milliseconds
;		Fixed variables and labels (subroutines) having the same name vAutoUlt sets AutoUlt & AutoUlt as a method...  Separated into VAutoUltimates and doAutoUltimates
;		added temporary tooltips to show setting effects
;		add gui boxes and sections for better gui positioning
;		fix bug where setting or clearing all level/ult checks did not also update the pointers (it would continue with old settings until gui submit runs)
;		added game feature to change formations at certain time elapsed since setting checked off
;	1.5.1
;		Fixed Increment Formation 3 (E)
;	1.5.2
;		Added spam {right} to skip boss
;		Added autoclicker - (kill distractions add dps)
;	1.5.3
;		script version increment forgotten, still says 1.5.2
;		in commit changes in commit message (remove controlclick2, remove killdistractions (temp))
;	1.5.4
;		Removed second key send from the function that was firing a second keystroke if the keys had not been used in 30s.
;		This old code had been causing issues with double levelling, and also hindering AutoProgress
;		TIP: skip boss animations is just press right, this will hinder the auto progress theory*
;			*The auto progress theory - if your party wipes, they fall back to a stable area, on the next hour turn autoprogress back on to see if they can push
;	1.5.5
;		reintroduced kill distractions, WARNING this will hijack ytour mouse, remember the Pause key
;		reformatted the GUI
;			removed the word Seat all the time, the numbers should be self explanatory
;			Made the columns narrower
;			Adopted the left=cancel right=ok format for Clear All and Set All Buttons (they are backwards)
;		added test code to develop / test controlClick2 hopefully for sending background clicks
;		* fix - Change formation may work if the party is tanking.
;		Added setFormation - go back 1 level, change and then resume autoprogress or right once depending on resume autoprogress checkbox.
;	1.5.6
;		Added center click to kill distractions to grab gem bags.  Also adds a click on the field, do not need advance boss if you use this(?)
;	1.5.7
;		Wow sorry for all the changes, reformatted notes and such on the top of the script,
;		added a return at the end of the (apparent?) main code section,
;		scoped all of the GUI and GuiControl calls to 1: (the current named gui?)
;		Made makeGui function so the code is not sitting in the main area,
;		other code cleanups and updates, some dev code sitting around too.
;
;	1.5.8
;		Parameterize all client window target vie new variables: game_title, game_exe, game_ahk_id
;		#ifWinExist does not accept variable parameters, upgrade to groupAdd
;
;	1.5.91 - Added L hotkey for pause / resume so that when using steam link from a mobile phone there was a compatible key with it's keyboard.
;
;	1.6.0 - Added memory checking capabilities -  https://github.com/mikebaldi/Idle-Champions
;		These features now read the current zone from game memory and will attempt to load Havilar, Imp, Party when modron resets to zone 1.
;		If the game client updates and the memory pointers fail, all other features from 1.5.x should work the same, just avoid using the Gem Farm Setup if it causes issues
;		(It should fail gracefully and skip the process, but you know... computers...)
;		If you see cannot load json.ahk or other includes do this:
;			Make a shortcut to load AHK and the script:
; 			[Target] 	D:\Dropbox\_tools\AutoHotkey.v1.1.33.10\AutoHotkeyU64.exe idlechamp-v1.5-leyline.ahk
;			[Start In Directory] {the same as the script location} ie: D:\Dropbox\Games\IdleChampions\idleChampions-ahk\
;
;	1.6.1 - Placeholder
;
; 	1.5.9+ - Todo - I think this was covered in 1.5.8 I will review
;		Add game_exe to all methods that are currently only useing game_title so that we can add steam/epic toggle
;		We may be able to, we may should remove control focus for key things since sendControlKey might be capable without it
;
;	todo 2021-09-23
;		add rate / time for autoprogress to repeat on
;		add a checkbox / setting to allow NumpadSub or choose a hotkey to reload the script?
;		add a checkbox / setting that chooses a different hotkey for pause / unpause
;		Add instructions / clarifications
;
;		Will this help? Add a 3250ms delay when GUI is checked before starting key send timers - because sendControlKey ignore all input for 3s anyway....
;
;	TODO: will add Priority Click Damage if block in HeroLevel
;
;	investigate: see if this is appropriate (does it help?)
;		https://autohotkey.com/board/topic/11347-control-key-sticks-sometimes-since-i-added-blind/#entry73409
;
;	investigate: review stuck keys code - perhaps we can solidify this script?
;		https://www.autohotkey.com/boards/viewtopic.php?t=19711
;		  While GetKeyState("Ctrl","P") || GetKeyState("LWin","P") || GetKeyState("RWin","P") || GetKeyState("Shift","P") || GetKeyState("Alt","P")
;		      Sleep 50
;		  Send {something}
;		  return

global game_Title := "Idle Champions"
global game_Exe := "IdleDragons.exe"
global game_ahk_id := GetGameAhkId()


;class and methods for parsing JSON (User details sent back from a server call)
#include json.ahk

;wrapper with memory reading functions sourced from: https://github.com/Kalamity/classMemory
#include classMemory.ahk

;Check if you have installed the class correctly.
if (_ClassMemory.__Class != "_ClassMemory") {
	msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
	ExitApp
}

;pointer addresses and offsets
#include IC_MemoryFunctions.ahk

;server call functions and variables Included after GUI so chest tabs maybe non optimal way of doing it
#include IC_ServerCallFunctions.ahk


GroupAdd, myGroup , %game_title% ; game_Title

#SingleInstance force
#IfWinExist ahk_group myGroup
#MaxThreadsPerHotkey 10

CoordMode, Mouse, Client
setmousedelay -1
setbatchlines -1

;global PBS_SMOOTH            := 0x00000001

global initialTick := 0
global IdleTime := 0
global vFormationChecks := 0


global absurdPauseKey := 0

global gCheckRestartLevelOne := 0

global loadHavilarImp:=0

OpenProcess()
ModuleBaseAddress()

makeGui()

;end of main code area
return

makeGui() {

	Gui, 1:New
	; BOX AREA
	Gui, 1:Add, GroupBox, r13 w120,

	Gui, 1:Add, CheckBox, w90 xp+10 vAutoLevel gUpdateFromGUI Checked0, Auto Leveling

	Gui, 1:Add, CheckBox, w50 vC1 gUpdateFromGUI Checked Section, 1
	Gui, 1:Add, CheckBox, vC2 gUpdateFromGUI Checked, 2
	Gui, 1:Add, CheckBox, vC3 gUpdateFromGUI Checked, 3
	Gui, 1:Add, CheckBox, vC4 gUpdateFromGUI Checked, 4
	Gui, 1:Add, CheckBox, vC5 gUpdateFromGUI Checked, 5
	Gui, 1:Add, CheckBox, vC6 gUpdateFromGUI Checked, 6
	Gui, 1:Add, CheckBox, vClickDmg gUpdateFromGUI Checked, Click

	Gui, 1:Add, Text, w50 xs ys+150, Rate (seconds):
	Gui, 1:Add, DropDownList, w50 vLevelingRate gUpdateFromGUI, 1|5||10|15|30|60

	Gui, 1:Add, Button, w50 y+6 gUnsetAllHeroLevel, Clear All



	Gui, 1:Add, CheckBox, x+5 ys vC7 gUpdateFromGUI Checked Section, 7
	Gui, 1:Add, CheckBox, vC8 gUpdateFromGUI Checked, 8
	Gui, 1:Add, CheckBox, vC9 gUpdateFromGUI Checked, 9
	Gui, 1:Add, CheckBox, vC10 gUpdateFromGUI Checked, 10
	Gui, 1:Add, CheckBox, vC11 gUpdateFromGUI Checked, 11
	Gui, 1:Add, CheckBox, vC12 gUpdateFromGUI Checked, 12

	Gui, 1:Add, Text, w50 xs ys+150, Priority Seat:
	Gui, 1:Add, DropDownList, w50 vPriorityChamp gUpdateFromGUI, 1|2|3|4|5|6||7|8|9|10|11|12|

	Gui, 1:Add, Button, w50 y+6 gSetAllHeroLevel, Set All


	; BOX AREA
	Gui, 1:Add, GroupBox, x+10 y6 r13 w120,

	Gui, 1:Add, CheckBox, w90 xp+10 vAutoUltimates gUpdateFromGUI Checked0, Auto Ultimates

	Gui, 1:Add, CheckBox, w50 vU1 gUpdateFromGUI Checked Section, Ult 1
	Gui, 1:Add, CheckBox, vU2 gUpdateFromGUI Checked, Ult 2
	Gui, 1:Add, CheckBox, vU3 gUpdateFromGUI Checked, Ult 3
	Gui, 1:Add, CheckBox, vU4 gUpdateFromGUI Checked, Ult 4
	Gui, 1:Add, CheckBox, vU5 gUpdateFromGUI Checked, Ult 5

	Gui, 1:Add, Text, w50 xs ys+150, Rate (seconds):
	Gui, 1:Add, DropDownList, w50 vUltRate gUpdateFromGUI, 1|5||10|15|30|60|300

	Gui, 1:Add, Button, w50 y+6 gUnsetAllUlt, Clear All


	Gui, 1:Add, CheckBox, x+5 ys vU6 gUpdateFromGUI Checked Section, Ult 6
	Gui, 1:Add, CheckBox, vU7 gUpdateFromGUI Checked, Ult 7
	Gui, 1:Add, CheckBox, vU8 gUpdateFromGUI Checked, Ult 8
	Gui, 1:Add, CheckBox, vU9 gUpdateFromGUI Checked, Ult 9
	Gui, 1:Add, CheckBox, vU10 gUpdateFromGUI Checked, Ult 10


	Gui, 1:Add, Button, w50 xs ys+209 gSetAllUlt, Set All

	; BOX AREA
	Gui, 1:Add, GroupBox, x+10 y6 r13 w190,
	Gui, 1:Add, CheckBox, xp+10 vRepeatFormation gUpdateFromGUI Checked0, Repeat Formation

	Gui, 1:Add, Text, Section , Formation:
	Gui, 1:Add, DropDownList, vRepeatFormationSelect gUpdateFromGUI, 1||2|3
	Gui, 1:Add, Text, , Rate (Seconds):
	Gui, 1:Add, DropDownList, vRepeatFormationRate gUpdateFromGUI, 1|5||10|15|30|60|120

	Gui, 1:Add, CheckBox, vSkipBossAnimation gUpdateFromGUI Checked0, Skip Level Animation (500ms)

	Gui, 1:Add, CheckBox, vAutoClicker gUpdateFromGUI Checked0, AutoClicker (100ms)

	Gui, 1:Add, CheckBox, vKillDistractions gUpdateFromGUI Checked0, Kill Distractions (80ms)

	Gui, 1:Add, CheckBox, vAutoProgress gUpdateFromGUI Checked0, Auto Progress [ON] (every hour)

	Gui, 1:Add, CheckBox, vloadHavilarImp gUpdateFromGUI Checked0, Load Havilar Imp

	Gui, 1:Add, CheckBox, w180 vLevelUpOnReset gUpdateFromGUI Checked0, Quick Level Ups on Reset

	;trying to add progress bars for the firing of the events....
	;Gui, 1:Add, Progress, y+10 w120 h20 -%PBS_SMOOTH% vProgPercent, 0


	; BOX AREA
	Gui, 1:Add, GroupBox, x+5 y6 r13 w150,
	Gui, 1:Add, CheckBox, xp+10 w130  vIncrementFormations gdoIncrementFormation Checked0 Section, Increment Formations

	Gui, 1:Add, Text, xs y+5, Formation 1 (Q)
	Gui, 1:Add, DropDownList,  vIncrementFormationRateQ gUpdateFromGUI, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5

	Gui, 1:Add, Text, , Formation 2 (W)
	Gui, 1:Add, DropDownList, vIncrementFormationRateW gUpdateFromGUI, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5

	Gui, 1:Add, Text, , Formation 3 (E)
	Gui, 1:Add, DropDownList, vIncrementFormationRateE gUpdateFromGUI, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5


	Gui, 1:Add, Text, xp y+15, (Set hours until each switch)
	Gui, 1:Add, Text, xp y+10, AutoProgress Reccomended

	Gui, 1:Add, edit, xs ys+216 w120 vidletime, 00:00:00

	; BOX AREA
	Gui, 1:Add, GroupBox, x+25 y6 r13 w140,

	; Just hit the X ?+
	; Gui, 1:Add, Button, xp+10 yp+20 gQuit, Quit

	Gui, 1:Add, Button, xp+10 yp+20 w100 gSubPause, Pause
	Gui, 1:Add, Button, w100 gsubResume, Resume
	; Gui, 1:Add, Button, w100 gUpdoot, upDoot

	if (vFormationChecks = 1) {
		; Upgrqade and move these to a settings JSON or INI
		Gui, 1:Add, Button, w100 y+6 gSetAllHeroLevel_Q, Set ToA Q
		Gui, 1:Add, Button, w100 y+6 gSetAllHeroLevel_W, Set ToA W
		Gui, 1:Add, Button, w100 y+6 gSetAllHeroLevel_E, Set ToA E
	}

	Gui, 1:Add, Button, w100 y+6 gSetAllHeroLevel_GemFarm, Quick Settings



	Gui, 1:Add, Text,, Pause script with: `n [Win+P] `n [Pause/Break]`n

	Gui, 1:Add, CheckBox, vabsurdPauseKey gUpdateFromGUI Checked0, Allow L pause

	Gui, 1:Show

	goSub UpdateFromGUI

}



Updoot() {
	; test calling a function from GUI button
	dooty:=2
	mTip("upddoot %dooty% %A_TickCount%")
}

UpdateFromGUI: ; do the work based on GUI controls calling this subroutine
	Gui, 1:Submit, NoHide

	; mTip("Starting Skill Upgrader Loop")

	if ( AutoLevel = 1 ) {
		autoLevelingTime := (LevelingRate * 1000)
		; mTip("I do the level %A_TickCount%")
		SetTimer, HeroLevel, %autoLevelingTime%
	}
	else {
		SetTimer, HeroLevel, Off
	}

	if ( AutoUltimates = 1 ) {
		autoUltimatesTime := (UltRate * 1000)
		SetTimer, doUltimates, %autoUltimatesTime%
	} else {
		SetTimer, doUltimates, Off
	}

	if ( AutoProgress = 1 ) {
		; 1 hour
		autoProgressTime := (60 * 60 * 1000)
		SetTimer, doAutoProgress, %autoProgressTime%
	} else {
		SetTimer, doAutoProgress, Off
	}

	if ( RepeatFormation = 1 ) {
		RepeatFormationTime := (1000 * RepeatFormationRate)
		mTip("doAutoFormation %RepeatFormationRate% - %RepeatFormationTime%")
		SetTimer, doRepeatFormation, %RepeatFormationTime%
	} else {
		SetTimer, doRepeatFormation, Off
	}

	if ( SkipBossAnimation = 1 ) {
		SetTimer, doSkipBossAnimation, 500
	} else {
		SetTimer, doSkipBossAnimation, Off
	}

	if ( KillDistractions = 1 ) {
		SetTimer, doKillDistractions, 68
	} else {
		SetTimer, doKillDistractions, Off
	}

	if ( LevelUpOnReset = 1 ) {
		SetTimer, doLevelUpOnReset, 1000
	} else {
		SetTimer, doLevelUpOnReset, Off
	}

	if ( AutoClicker = 1 ) {
		SetTimer, doAutoClicker, 100
	} else {
		SetTimer, doAutoClicker, Off
	}



	; if (IncrementFormations = 1 AND (IncrementFormationRateQ > 0 or IncrementFormationRateW > 0 or IncrementFormationRateE > 0) ){
	;   gosub doIncrementFormation
	; }

	;end UpdateFromGUI subroutine
return


doSkipBossAnimation:
	ControlFocus,, %game_Title%
	SendControlKey("right")
return


doAutoClicker:
	if ( IsGameActive() ) {
		ControlClick, x380 y265, %game_Title%,, LEFT, 1, NA ;
	}
return

doClickTest:
	ControlFocus,, %game_title% ahk_exe %game_Exe%
	; click on familiar box to see click flashes (debug)
	; MouseMove, 880, 410, 4
	; ControlClick, x880 y410, %game_title%,, LEFT, 1, x880 y410 ;

	; SendMessage, WM_SETCURSOR, [wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]
	; WinGetPos , , , , , %game_title%
	; SetControlDelay -1

	; ControlMouseMove(x, y, c%A_Index%, "ahk_id " w%A_Index%, "", "L K")
	;ControlClick, x880 y410, %game_title%,, LEFT, 1, NA ;

	ControlClick2(880, 410, game_title) ;
return

doKillDistractions:
	; mouse grid, 3 rows center screen spam clicks kill distractions - this works but takes cursor
	if ( IsGameActive() ) {
		ControlFocus,, %game_title% ahk_exe %game_Exe%

		; MouseClick - works but takes mouse cursor
		MouseClick, left, 640, 125, 1
		sleep 17
		MouseClick, left, 640, 175, 1
		sleep 17
		MouseClick, left, 640, 225, 1
		sleep 17

		; MouseClick, left, 1175, 300, 1 ; Also click to collect gold
		; sleep 17

		; MouseClick, left, 1175, 350, 1 ; Also click to collect gold
		; sleep 17

		; MouseClick, left, 1175, 450, 1 ; Also click to collect gold
		; sleep 17


		; if ( SkipBossAnimation != 1 ) {
		; 	naw, leave it in; it adds dps on the field :P
		; }
		MouseClick, left, 640, 360, 1 ; click gems center
		sleep 17
	}
return

doRepeatFormation:
	ControlFocus,, %game_title% ahk_exe %game_Exe%

	if ( RepeatFormationSelect = 1 ) {
		SendControlKey("q")
	}
	if ( RepeatFormationSelect = 2 ) {
		SendControlKey("w")
	}
	if ( RepeatFormationSelect = 3 ) {
		SendControlKey("e")
	}
return


mTip(msg) {
	toolTip, %msg%
	setTimer clearToolTip, 5000
}


clearToolTip:
	ToolTip
	setTimer clearToolTip, off
return

checkMasterTicks:
	; checks ticks elapsed globally, will not reset from a settimer
	if (initialTick = 0) {
		return
	}

	ElapsedTime := UpdateElapsedTime(initialTick)

	; time since boot
	;T = %A_YYYY%%A_MM%%A_DD%%A_Hour%%A_Min%%A_Sec%
	;T += A_TickCount/1000,Seconds

	;FormatTime FormdT, %T%, HH:mm:ss
	;GuiControl, 1:, idletime, %FormdT%

	; current time
	;T = initialTick/1000, seconds

	;make a timer from zero (well 1/1/2000 00:00:00)
	T = 20000101000000
	T += ElapsedTime/1000,Seconds

	FormatTime FormdT, %T%, HH:mm:ss
	GuiControl, 1:, idletime, %FormdT%

	; test / debug output...

	; mTip("elapsed %ElapsedTime%")

	; testing condition block to see about changing the selected option of the dropdown
	if ( false AND IncrementFormationRateQ > 0 and ElapsedTime >= IncrementFormationRateQ * 1000  ) {
		;set to false this is test-debug only
		mTip("Test DropDownList update from formation Q")
		;either we set the variable now, or we Gui-submit, noHide, I think setting the variable direcly is less intensive
		IncrementFormationRateQ := 0
		GuiControl, 1:ChooseString, IncrementFormationRateQ, 0
		;Gui, 1:Submit, NoHide
	}


	if ( IncrementFormationRateQ > 0 and ElapsedTime >= IncrementFormationRateQ * 60 * 60 * 1000  ) {
		mTip("I did the formation - Q")
		IncrementFormationRateQ := 0
		GuiControl, 1:ChooseString, IncrementFormationRateQ, 0
		setFormation("q")
		; gosub SetAllHeroLevel_Q
	}

	if ( IncrementFormationRateW > 0 and ElapsedTime >= IncrementFormationRateW * 60 * 60 * 1000  ) {
		mTip("I did the formation - W")
		IncrementFormationRateW := 0
		GuiControl, 1:ChooseString, IncrementFormationRateW, 0
		setFormation("w")
		; gosub SetAllHeroLevel_W
	}

	if ( IncrementFormationRateE > 0 and ElapsedTime >= IncrementFormationRateE * 60 * 60 * 1000  ) {
		ControlFocus,, %game_title% ahk_exe %game_Exe%
		mTip("I did the formation - E")
		IncrementFormationRateE := 0
		GuiControl, 1:ChooseString, IncrementFormationRateE, 0
		setFormation("e")
		; gosub SetAllHeroLevel_E
	}

	if ( (IncrementFormationRateQ = 0) and (IncrementFormationRateW = 0) and (IncrementFormationRateE = 0) ) {
		; this is where I turn off the main Checkbox if all formation rates have gone to zero
		; mTip("Every formation rate 0 turn off.")
		IncrementFormations := 0
		GuiControl, 1:, IncrementFormations, 0
		Gui, 1:Submit, NoHide
		SetTimer checkMasterTicks, off
	}
return

doIncrementFormation:
	Gui, 1:Submit, NoHide
	;turn it off if we only want it to set once and stop.

	if (initialTick = 0) {
		mTip("I will increment the formations every x hour(s).")
		initialTick := A_TickCount
	}

	if (IncrementFormations = 1) {
		SetTimer checkMasterTicks, 500
	} else {
		mTip("I will NOT increment the formations every x hour(s).")
		SetTimer checkMasterTicks, off
	}

return

setFormation(sFormation) {
	ControlFocus,, %game_title% ahk_exe %game_Exe%

	sleep 3250 ; for testing make sure noone was typing.
	SendControlKey("left")
	SendControlKey(sFormation)
	if ( true or AutoProgress = 1 ) {
		SendControlKey("g")
	} else {
		sleep 10000
		SendControlKey("right")
	}
}

doAutoProgress:
	;Turns off autoprogress with left key, then G to resume
	ControlFocus,, %game_title% ahk_exe %game_Exe%
	SendControlKey("Left")
	sleep 750
	SendControlKey("g")
return


doUltimates:
	ControlFocus,, %game_title% ahk_exe %game_Exe%
	Ults := [U1, U2, U3, U4, U5, U6, U7, U8, U9, U10]
	if ( U1 = 1) {
		SendControlKey("1")
	}
	if ( U2 = 1) {
		SendControlKey("2")
	}
	if ( U3 = 1) {
		SendControlKey("3")
	}
	if ( U4 = 1) {
		SendControlKey("4")
	}
	if ( U5 = 1) {
		SendControlKey("5")
	}
	if ( U6 = 1) {
		SendControlKey("6")
	}
	if ( U7 = 1) {
		SendControlKey("7")
	}
	if ( U8 = 1) {
		SendControlKey("8")
	}
	if ( U9 = 1) {
		SendControlKey("9")
	}
	if ( U10 = 1) {
		SendControlKey("0")
	}

return


doLevelUpOnReset:

	gLevel_Number := ReadCurrentZone(1)

	; Hack for now until I can make it more graceful,   Set Havi Ultimate
	if (gCheckRestartLevelOne = 0 AND gLevel_Number > 1) {
		; set this up so that we will load group one time next load.
		mTip("Toggle Level Watch")
		gCheckRestartLevelOne := 1
	} else if (gLevel_Number = 1 and gCheckRestartLevelOne = 1) {
		gCheckRestartLevelOne := 0

		SetKeyDelay 20,20
		mTip("Level 1 restart Detected, Leveling Group in 5s")
		sleep 5000

		if ( C10 = 1 OR loadHavilarImp = 1 ) {
			mTip("Load Havilar")
			DirectedInput("{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}{F10}")

			if (loadHavilarImp = 1) {
				sleep 250
				mTip("Load Imp")
				DirectedInput("1")
			}
		}

		mTip("Load Group")

		if ( C1 = 1 ) {
			DirectedInput("{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}{F1}")
		}
		if ( C6 = 1 ) {
			DirectedInput("{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}{F6}")
		}
		if ( C8 = 1 ) {
			DirectedInput("{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}{F8}")
		}
		if ( C4 = 1 ) {
			DirectedInput("{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}{F4}")
		}
		if ( ClickDmg = 1 ) {
			DirectedInput("{Ctrl down}``{Ctrl up}")
		}

		SetKeyDelay -1,-1
	}

return

HeroLevel:
	ControlFocus,, %game_title% ahk_exe %game_Exe%

	champs := [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12]
	if ( champs[PriorityChamp] = 1 ) {
		x := Format("F{1}", PriorityChamp)
		SendControlKey(x)
	}
	if ( C12 = 1 ) {
		SendControlKey("F12")
	}
	if ( C11 = 1 ) {
		SendControlKey("F11")
	}
	if ( C10 = 1 ) {
		SendControlKey("F10")
	}
	if ( C9 = 1 ) {
		SendControlKey("F9")
	}
	if ( C8 = 1 ) {
		SendControlKey("F8")
	}
	if ( C7 = 1 ) {
		SendControlKey("F7")
	}
	if ( C6 = 1 ) {
		SendControlKey("F6")
	}
	if ( C5 = 1 ) {
		SendControlKey("F5")
	}
	if ( C4 = 1 ) {
		SendControlKey("F4")
	}
	if ( C3 = 1 ) {
		SendControlKey("F3")
	}
	if ( C2 = 1 ) {
		SendControlKey("F2")
	}
	if ( C1 = 1 ) {
		SendControlKey("F1")
	}
	if ( ClickDmg = 1 ) {
		SendControlKey("``")
	}

return

UnsetAllHeroLevel:
	GuiControl, 1:, C1, 0
	GuiControl, 1:, C2, 0
	GuiControl, 1:, C3, 0
	GuiControl, 1:, C4, 0
	GuiControl, 1:, C5, 0
	GuiControl, 1:, C6, 0
	GuiControl, 1:, C7, 0
	GuiControl, 1:, C8, 0
	GuiControl, 1:, C9, 0
	GuiControl, 1:, C10, 0
	GuiControl, 1:, C11, 0
	GuiControl, 1:, C12, 0
	GuiControl, 1:, ClickDmg, 0
	Gui, 1:Submit, NoHide
return

SetAllHeroLevel:
	GuiControl, 1:, C1, 1
	GuiControl, 1:, C2, 1
	GuiControl, 1:, C3, 1
	GuiControl, 1:, C4, 1
	GuiControl, 1:, C5, 1
	GuiControl, 1:, C6, 1
	GuiControl, 1:, C7, 1
	GuiControl, 1:, C8, 1
	GuiControl, 1:, C9, 1
	GuiControl, 1:, C10, 1
	GuiControl, 1:, C11, 1
	GuiControl, 1:, C12, 1
	GuiControl, 1:, ClickDmg, 1
	Gui, 1:Submit, NoHide
return


; Upgrqade and move these - SetAllHeroLevel subroutines - to a settings JSON or INI


SetAllHeroLevel_GemFarm: ; Leyline Custom GemFarm
	gosub SetAllUlt
	gosub UnsetAllHeroLevel

	GuiControl, 1:, U1, 0 ; Deekin off
	GuiControl, 1:, U5, 0 ; Havilar off

	GuiControl, 1:, C1, 1
	GuiControl, 1:, C4, 1
	GuiControl, 1:, C6, 1
	GuiControl, 1:, C8, 1

	GuiControl, 1:, loadHavilarImp, 1

	GuiControl, 1:, AutoLevel, 1

	GuiControl, 1:, AutoUltimates, 1

	; LevelingRate := 1
	; GuiControl, 1:ChooseString, LevelingRate, 1

	SkipBossAnimation := 1
	GuiControl, 1:, SkipBossAnimation, 1

	LevelUpOnReset := 1
	GuiControl, 1:, LevelUpOnReset, 1

	GuiControl, 1:, ClickDmg, 1
	Gui, 1:Submit, NoHide

	gCheckRestartLevelOne := 1

	gosub UpdateFromGUI ; start clicking

return


SetAllHeroLevel_Q: ; Leyline Custom TOA speed formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl, 1:, U1, 0 ; deekin off

	GuiControl, 1:, C3, 0
	GuiControl, 1:, C12, 0

	GuiControl, 1:, ClickDmg, 1
	Gui, 1:Submit, NoHide
return

SetAllHeroLevel_W: ; Leyline Custom TOA gold formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl, 1:, C3, 0
	GuiControl, 1:, C12, 0

	GuiControl, 1:, ClickDmg, 0
	Gui, 1:Submit, NoHide
return

SetAllHeroLevel_E: ; Leyline Custom TOA push formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl, 1:, C9, 0
	GuiControl, 1:, C12, 0

	GuiControl, 1:, ClickDmg, 0
	Gui, 1:Submit, NoHide
return

UnsetAllUlt:
	GuiControl, 1:, U1, 0
	GuiControl, 1:, U2, 0
	GuiControl, 1:, U3, 0
	GuiControl, 1:, U4, 0
	GuiControl, 1:, U5, 0
	GuiControl, 1:, U6, 0
	GuiControl, 1:, U7, 0
	GuiControl, 1:, U8, 0
	GuiControl, 1:, U9, 0
	GuiControl, 1:, U10, 0
	Gui, 1:Submit, NoHide
return

SetAllUlt:
	GuiControl, 1:, U1, 1
	GuiControl, 1:, U2, 1
	GuiControl, 1:, U3, 1
	GuiControl, 1:, U4, 1
	GuiControl, 1:, U5, 1
	GuiControl, 1:, U6, 1
	GuiControl, 1:, U7, 1
	GuiControl, 1:, U8, 1
	GuiControl, 1:, U9, 1
	GuiControl, 1:, U10, 1
	Gui, 1:Submit, NoHide
return


IsGameActive() {
	WinGetTitle, title, A ; fetch the title of the active windo
	return title == game_Title ; compare the fecthed title to our game_title
}


GetGameAhkId() {
	return WinExist("ahk_exe" . game_Exe)
}

GetGameAhkIdByGroup() {
	return WinExist("ahk_group myGroup")
}

SendControlKey(x) {
	; if ( IsGameActive() ) { ; Protects firing when off the game, but also will not fire at all if the game was not fully focus
	; }
	if (A_TimeIdleKeyboard > 3000) {
		ControlSend,, {%x%}, %game_title% ahk_exe %game_Exe%
	}
}


; from zee / mike's script
DirectedInput(s) {
	; ReleaseStuckKeys()
	; SafetyCheck()
	ControlFocus,, ahk_exe %game_Exe%
	ControlSend,, {Blind}%s%, ahk_exe %game_Exe%
	Sleep, 25  ; Sleep for 25 sec formerly ScriptSpeed global, not used elsewhere.
}

UpdateElapsedTime(StartTime) {
	ElapsedTime := A_TickCount - StartTime
	GuiControl, MyWindow:, ElapsedTimeID, % ElapsedTime
	return ElapsedTime
}


ControlFromPoint(X, Y, WinTitle="", WinText="", ByRef cX="", ByRef cY="", ExcludeTitle="", ExcludeText="") {
	static EnumChildFindPointProc=0
	if !EnumChildFindPointProc {
		EnumChildFindPointProc := RegisterCallback("EnumChildFindPoint","Fast")
	}


	if !(target_window := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText)) {
		return false
	}

	VarSetCapacity(rect, 16)
	DllCall("GetWindowRect","uint",target_window,"uint",&rect)
	VarSetCapacity(pah, 36, 0)
	NumPut(X + NumGet(rect,0,"int"), pah,0,"int")
	NumPut(Y + NumGet(rect,4,"int"), pah,4,"int")
	DllCall("EnumChildWindows","uint",target_window,"uint",EnumChildFindPointProc,"uint",&pah)
	control_window := NumGet(pah,24) ? NumGet(pah,24) : target_window
	DllCall("ScreenToClient","uint",control_window,"uint",&pah)
	cX:=NumGet(pah,0,"int"), cY:=NumGet(pah,4,"int")
	return control_window
}

; Ported from AutoHotkey::script2.cpp::EnumChildFindPoint()
EnumChildFindPoint(aWnd, lParam) {
	if !DllCall("IsWindowVisible","uint",aWnd)
	return true

	VarSetCapacity(rect, 16)
	if !DllCall("GetWindowRect","uint",aWnd,"uint",&rect)
	return true

	pt_x:=NumGet(lParam+0,0,"int"), pt_y:=NumGet(lParam+0,4,"int")
	rect_left:=NumGet(rect,0,"int"), rect_right:=NumGet(rect,8,"int")
	rect_top:=NumGet(rect,4,"int"), rect_bottom:=NumGet(rect,12,"int")

	if (pt_x >= rect_left && pt_x <= rect_right && pt_y >= rect_top && pt_y <= rect_bottom) {
		center_x := rect_left + (rect_right - rect_left) / 2
		center_y := rect_top + (rect_bottom - rect_top) / 2
		distance := Sqrt((pt_x-center_x)**2 + (pt_y-center_y)**2)
		update_it := !NumGet(lParam+24)

		if (!update_it) {
			rect_found_left:=NumGet(lParam+8,0,"int"), rect_found_right:=NumGet(lParam+8,8,"int")
			rect_found_top:=NumGet(lParam+8,4,"int"), rect_found_bottom:=NumGet(lParam+8,12,"int")
			if (rect_left >= rect_found_left && rect_right <= rect_found_right
			&& rect_top >= rect_found_top && rect_bottom <= rect_found_bottom)
			update_it := true
			else if (distance < NumGet(lParam+28,0,"double")
			&& (rect_found_left < rect_left || rect_found_right > rect_right
			| rect_found_top < rect_top || rect_found_bottom > rect_bottom))
			update_it := true
		}

		if (update_it) {
			NumPut(aWnd, lParam+24)
			DllCall("RtlMoveMemory","uint",lParam+8,"uint",&rect,"uint",16)
			NumPut(distance, lParam+28, 0, "double")
		}
	}

	return true
}

MAKELONG(LOWORD, HIWORD, Hex := False) {
	; WORD = 2 bytes = 16 bits
	LONG := (LOWORD & 0xFFFF) | ((HIWORD & 0xFFFF) << 16)
	Sign := (LONG & 0x80000000) ? (Hex ? "-" : -1) : (Hex ? "" : 1)
	Return (Hex ? Format(Sign . "0x{:08X}", LONG) : (LONG * Sign))
}

; attempt a postMessage function that can send cursor and mouse clicks to unfocused window. (do not hijack cursor)
ControlClick2(X, Y, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	lparam := MakeLong(X, Y)
	; lParam := X&0xFFFF | (Y & 0xFFFF) <<16 ; do it manually?
	wParam := 0 ;
	hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)


	; PostMessage, 0x200, 0, %lparam%, , ahk_id %hwnd% ; Move
	; PostMessage, 0x201, 0x0001, %lparam%, , ahk_id %hwnd% ; LButtonDown
	; PostMessage, 0x202 , 0, %lparam%, , ahk_id %hwnd% ; LButtonUp

	PostMessage, 0x200, %wParam%, %lParam%,, ahk_id %hwnd% ; WM_MOUSEMOVE
	PostMessage, 0x2A1, %wParam%, %lParam%,, ahk_id %hwnd% ; WM_MOUSEHOVER
	;PostMessage, 0x06, 0x0001, %lParam%,, ahk_id %hwnd% ; Activate
	;PostMessage, 0x20, 0x0001, %lParam%,, ahk_id %hwnd% ; Set Cursor
	PostMessage, 0x201, 0x0001, %lParam%,, ahk_id %hwnd% ; WM_LBUTTONDOWN
	PostMessage, 0x202, %wParam%, %lParam%,, ahk_id %hwnd% ; WM_LBUTTONUP
}

ControlClick2_original(X, Y, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
	hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)
	PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_MOUSEMOVE
	PostMessage, 0x2A1, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_MOUSEHOVER
	PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDOWN
	PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
}

;Esc::
	;ExitApp
;return

; CoordMode, mouse, screen ; does NOT use active window coords
^numpad7:: ; hotkey
	SetTimer, doClickTest, off
Return
^numpad8:: ; hotkey
	SetTimer, doClickTest, 60
Return

^numpad9:: ; hotkey
	; This is my debug testing area, move along.
	; OpenProcess()
	; ModuleBaseAddress()
	; gCheckRestartLevelOne := 1

	if (ReadChampBenchedByID(0,, 58) = 1) {
		mTip("Couldn't find Briv in [Q] formation. Check saved formations. Ending Gem Farm.")
	;    Return, 1
	}

	if (ReadChampBenchedByID(0,, 56) = 1) {
		mTip("Couldn't find Havilar in [Q] formation. Check saved formations. Ending Gem Farm.")
	;    Return, 1
	}

	mtip("champID Bly Slot " . ReadChampLvlByID(0,, 56) )

	; mtip("current zone: " . ReadCurrentZone(0))
Return


>^NumpadSub:: ; hotkey (rightCTRL) + Numpad + - (minus) for quick reloads during development
	Reload
return


subPause:
	mTip("Script Paused")
	Pause
return


subResume:
	mTip("Script Resumed")
	Pause, 0
return



; hotkey Pause/Break OR Win+P.
#P::
Pause::
>!p:: ; (rightAlt) + p
	Pause
return


l::	; yes I did this, so that paying from steam streaming you can pause with "L"
	; Make this configurable later with choose hotkey and INI settings.
	if (absurdPauseKey = 1) {
		Pause
	} else {
		send, l
	}
return



Quit:
ExitApp

