; Original Author: Abydos, Fritz
; orig filename: idlechamp-v1.4.ahk
; from striderx2048 210614
; edited retaki

; Current Version: 1.5.5

; edited Leyline (Swamp Fox II) 2021-09-23
	; https://github.com/Leyline77/idleChampions-ahk

	; 1.5.0
	; 	started development off ot the 1.4e code base
	; 	fix auto progress - was only pressing G this would turn it off for 30 mins, turn it on for 30 mins.  now it will break progress with {left} and then g to continue
	; 	Clarified some GUI options, such as repeat Formation
	; 	Simplified GUI with Rate in Seconds or Minutes or Hours as appropriate instead of milliseconds
	; 	Fixed variables and labels (subroutines) having the same name vAutoUlt sets AutoUlt & AutoUlt as a method...  Separated into VAutoUltimates and doAutoUltimates
	; 	added temporary tooltips to show setting effects
	; 	add gui boxes and sections for better gui positioning
	; 	fix bug where setting or clearing all level/ult checks did not also update the pointers (it would continue with old settings until gui submit runs)
	; 	added game feature to change formations at certain time elapsed since setting checked off

	; 1.5.1
	; 	Fixed Increment Formation 3 (E)
	; 1.5.2
	; 	Added spam {right} to skip boss
	; 	Added autoclicker - (kill distractions add dps)
	; 1.5.3
	;	script version increment forgotten, still says 1.5.2
	;	in commit changes in commit message (remove controlclick2, remove killdistractions (temp))

	; 1.5.4
	;	Removed second key send from the function that was firing a second keystroke if the keys had not been used in 30s.
	; 	This old code had been causing issues with double levelling, and also hindering AutoProgress
	; 	TIP: skip boss animations is just press right, this will hinder the auto progress theory*
	;		*The auto progress theory - if your party wipes, they fall back to a stable area, on the next hour turn autoprogress back on to see if they can push

	; 1.5.5
	; 	reintroduced kill distractions, WARNING this will hijack ytour mouse, remember the Pause key
	; 	reformatted the GUI
	; 		removed the word Seat all the time, the numbers should be self explanatory
	; 		Made the columns narrower
	; 		Adopted the left=cancel right=ok format for Clear All and Set All Buttons (they are backwards)
	; 	added test code to develop / test controlClick2 hopefully for sending background clicks
	; fix - Change formation may work if the party is tanking.
	; 	Added setFormation - go back 1 level, change and then resume autoprogress or right once depending on resume autoprogress checkbox.


	; Helpful tips
	; if you set your rate to 1 second, and then you have a hard time changing settings because the spamming is focusing out,
	; use the PAUSE / BREAK key on your keyboard to pause the script.
	; if you want to restart the Increment Formations Timer you can reload the script.  (I will add a reset button later)
	; you can "increment" the formations in any order by setting them to a lower Time than another.
	; you can pick just one formation to increment by only setting a time for that formation.



	; todo 2021-09-23
	; add rate / time for autoprogress to repeat on
	; add a checkbox / setting to allow NumpadSub or choose a hotkey to reload the script?
	; add a checkbox / setting that chooses a different hotkey for pause / unpause
	; Add instructions / clarifications

	; note: see if this is appropriate (does it help?)
	; https://autohotkey.com/board/topic/11347-control-key-sticks-sometimes-since-i-added-blind/#entry73409

	; review stuck keys here:  perhaps we can solidify the code
	; https://www.autohotkey.com/boards/viewtopic.php?t=19711
	;   While GetKeyState("Ctrl","P") || GetKeyState("LWin","P") || GetKeyState("RWin","P") || GetKeyState("Shift","P") || GetKeyState("Alt","P")
	;       Sleep 50
	;   Send {something}
	;   return

#SingleInstance force
#IfWinExist ahk_exe IdleDragons.exe
#MaxThreadsPerHotkey 10

CoordMode, Mouse, Client

IsGameActive() {
  WinGetTitle, title, A
  return title == "Idle Champions"
}


;global PBS_SMOOTH            := 0x00000001

initialTick := 0


Gui 1:Add, GroupBox, r13 w120,

Gui 1:Add, CheckBox, w90 xp+10 vAutoLevel gUpdate Checked0, Auto Leveling

Gui 1:Add, CheckBox, w50 vC1 gUpdate Checked Section, 1
Gui 1:Add, CheckBox, vC2 gUpdate Checked, 2
Gui 1:Add, CheckBox, vC3 gUpdate Checked, 3
Gui 1:Add, CheckBox, vC4 gUpdate Checked, 4
Gui 1:Add, CheckBox, vC5 gUpdate Checked, 5
Gui 1:Add, CheckBox, vC6 gUpdate Checked, 6
Gui 1:Add, CheckBox, vClickDmg gUpdate Checked, Click

Gui 1:Add, Text, w50 xs ys+150, Rate (seconds):
Gui 1:Add, DropDownList, w50 vLevelingRate gUpdate, 1|5||10|15|30|60

Gui 1:Add, Button, w50 y+6 gUnsetAllHeroLevel, Clear All



Gui 1:Add, CheckBox, x+5 ys vC7 gUpdate Checked Section, 7
Gui 1:Add, CheckBox, vC8 gUpdate Checked, 8
Gui 1:Add, CheckBox, vC9 gUpdate Checked, 9
Gui 1:Add, CheckBox, vC10 gUpdate Checked, 10
Gui 1:Add, CheckBox, vC11 gUpdate Checked, 11
Gui 1:Add, CheckBox, vC12 gUpdate Checked, 12


Gui 1:Add, Text, w50 xs ys+150, Priority Seat:
Gui 1:Add, DropDownList, w50 vPriorityChamp gUpdate, 1|2|3|4|5|6||7|8|9|10|11|12|

Gui 1:Add, Button, w50 y+6 gSetAllHeroLevel, Set All




Gui 1:Add, GroupBox, x+10 y6 r13 w120,

Gui 1:Add, CheckBox, w90 xp+10 vAutoUltimates gUpdate Checked0, Auto Ultimates

Gui 1:Add, CheckBox, w50 vU1 gUpdate Checked Section, Ult 1
Gui 1:Add, CheckBox, vU2 gUpdate Checked, Ult 2
Gui 1:Add, CheckBox, vU3 gUpdate Checked, Ult 3
Gui 1:Add, CheckBox, vU4 gUpdate Checked, Ult 4
Gui 1:Add, CheckBox, vU5 gUpdate Checked, Ult 5

Gui 1:Add, Text, w50 xs ys+150, Rate (seconds):
Gui 1:Add, DropDownList, w50 vUltRate gUpdate, 1|5||10|15|30|60|300

Gui 1:Add, Button, w50 y+6 gUnsetAllUlt, Clear All


Gui 1:Add, CheckBox, x+5 ys vU6 gUpdate Checked Section, Ult 6
Gui 1:Add, CheckBox, vU7 gUpdate Checked, Ult 7
Gui 1:Add, CheckBox, vU8 gUpdate Checked, Ult 8
Gui 1:Add, CheckBox, vU9 gUpdate Checked, Ult 9
Gui 1:Add, CheckBox, vU10 gUpdate Checked, Ult 10


Gui 1:Add, Button, w50 xs ys+209 gSetAllUlt, Set All

Gui 1:Add, GroupBox, x+10 y6 r13 w200,
Gui 1:Add, CheckBox,  xp+10 vRepeatFormation gUpdate Checked0, Repeat Formation

Gui 1:Add, Text, Section , Formation:
Gui 1:Add, DropDownList,  vRepeatFormationSelect gUpdate, 1||2|3
Gui 1:Add, Text, , Rate (Seconds):
Gui 1:Add, DropDownList,  vRepeatFormationRate gUpdate, 1|5||10|15|30|60|120

Gui 1:Add, CheckBox, y+10 vSkipBossAnimation gUpdate Checked0, Skip Level Animation (500ms)

Gui 1:Add, CheckBox, y+10 vAutoClick gUpdate Checked0, AutoClicker (100ms)

Gui 1:Add, CheckBox, y+10 vKillDistractions gUpdate Checked0, Kill Distractions (60ms)


Gui 1:Add, CheckBox, xs ys+170 vAutoProgress gUpdate Checked0, Auto Progress [ON] (every hour)


;trying to add progress bars for the firing of the events....
;Gui 1:Add, Progress, y+10 w120 h20 -%PBS_SMOOTH% vProgPercent, 0


Gui 1:Add, GroupBox, x+25 y6 r13 w150,
Gui 1:Add, CheckBox, xp+10 w130  vIncrementFormations gdoIncrementFormation Checked0 Section, Increment Formations

Gui 1:Add, Text, xs y+5, Formation 1 (Q)
Gui 1:Add, DropDownList,  vIncrementFormationRateQ gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5

Gui 1:Add, Text, , Formation 2 (W)
Gui 1:Add, DropDownList, vIncrementFormationRateW gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5

Gui 1:Add, Text, , Formation 3 (E)
Gui 1:Add, DropDownList, vIncrementFormationRateE gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5


Gui 1:Add, Text, xp y+15, (Set hours until each switch)
Gui 1:Add, Text, xp y+10, AutoProgress Reccomended

Gui 1: Add, edit, xs ys+216 w120 vidletime, 00:00:00

Gui 1:Add, GroupBox, x+25 y6 r13 w140,

Gui 1:Add, Button, xp+10 yp+20 gQuit, Quit

Gui 1:Add, Button, w100 y+6 gSetAllHeroLevel_Q, Set ToA Q
Gui 1:Add, Button, w100 y+6 gSetAllHeroLevel_W, Set ToA W
Gui 1:Add, Button, w100 y+6 gSetAllHeroLevel_E, Set ToA E


Gui 1:Add, Text,, Win+P (Pause script)

Gui 1:Show


setmousedelay -1
setbatchlines -1


Update: ; do the work based on GUI controls calling this subroutine
	Gui, Submit, NoHide

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

	; yes I know this is not here now.
	if ( KillDistractions = 1 ) {
		SetTimer, doKillDistractions, 60
	} else {
		SetTimer, doKillDistractions, Off
	}

	if ( AutoClick = 1 ) {
		SetTimer, doAutoClick, 100
	} else {
		SetTimer, doAutoClick, Off
	}



	; if (IncrementFormations = 1 AND (IncrementFormationRateQ > 0 or IncrementFormationRateW > 0 or IncrementFormationRateE > 0) ){
	;   gosub doIncrementFormation
	; }

	;end update function
return

doSkipBossAnimation:
	ControlFocus,, Idle Champions
	SendControlKey("right")
return


doAutoClick:
	if ( IsGameActive() ) {
		ControlClick, x380 y265, Idle Champions,, LEFT, 1, NA ;
	}
return

doClickTest:
	ControlFocus,, Idle Champions
	; click on familiar box to see click flashes (debug)
	; MouseMove, 880, 410, 4
	; ControlClick, x880 y410, Idle Champions,, LEFT, 1, x880 y410 ;

	; SendMessage, WM_SETCURSOR, [wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]
	; WinGetPos , , , , , Idle Champions
	; SetControlDelay -1

	; ControlMouseMove(x, y, c%A_Index%, "ahk_id " w%A_Index%, "", "L K")
	;ControlClick, x880 y410, Idle Champions,, LEFT, 1, NA ;

	ControlClick2(880, 410, "Idle Champions") ;
return

doKillDistractions:
	; mouse grid, 3 rows center screen spam clicks kill distractions - this works but takes cursor
	ControlFocus,, Idle Champions

	MouseClick, left, 640, 125, 1 ; works but takes mouse
	sleep 20
	MouseClick, left, 640, 175, 1 ; works but takes mouse
	sleep 20
	MouseClick, left, 640, 225, 1 ; works but takes mouse
	sleep 20
return

doRepeatFormation:
	ControlFocus,, Idle Champions

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

	ElapsedTime := A_TickCount - initialTick

	; time since boot
	;T = %A_YYYY%%A_MM%%A_DD%%A_Hour%%A_Min%%A_Sec%
	;T += A_TickCount/1000,Seconds

	;FormatTime FormdT, %T%, HH:mm:ss
	;GuiControl,, idletime, %FormdT%

	; current time
	;T = initialTick/1000, seconds

	;make a timer from zero (well 1/1/2000 00:00:00)
	T = 20000101000000
	T += ElapsedTime/1000,Seconds

	FormatTime FormdT, %T%, HH:mm:ss
	GuiControl,, idletime, %FormdT%

	; test / debug output...

	; mTip("elapsed %ElapsedTime%")

	; testing condition block to see about changing the selected option of the dropdown
	if ( IncrementFormationRateQ > 0 and ElapsedTime >= IncrementFormationRateQ * 1000  ) {
		mTip("Test DropDownList update from formation Q")
		;either we set the variable now, or we Gui, submut, noHide, I think setting the variable direcly is less intensive
		IncrementFormationRateQ := 0
		GuiControl, ChooseString, IncrementFormationRateQ, 0
		;Gui, Submit, NoHide
	}


	if ( false AND IncrementFormationRateQ > 0 and ElapsedTime >= IncrementFormationRateQ * 1000  ) {
		mtip("Test DropDownList update from formation Q bravo")

		; can we do this more properly by setting the value and then refreshing the gui?
		; try gui altSubmit?
		; IncrementFormationRateQ:= 0
		; Gui, Submit, NoHide

	}


	if ( IncrementFormationRateQ > 0 and ElapsedTime >= IncrementFormationRateQ * 60 * 60 * 1000  ) {
		mTip("I did the formation - Q")
		IncrementFormationRateQ := 0
		GuiControl, ChooseString, IncrementFormationRateQ, 0
		ControlFocus,, Idle Champions

		setFormation("q")
		; gosub SetAllHeroLevel_Q
	}

	if ( IncrementFormationRateW > 0 and ElapsedTime >= IncrementFormationRateW * 60 * 60 * 1000  ) {
		mTip("I did the formation - W")
		IncrementFormationRateW := 0
		GuiControl, ChooseString, IncrementFormationRateW, 0
		ControlFocus,, Idle Champions
		setFormation("w")
		; gosub SetAllHeroLevel_W
	}

	if ( IncrementFormationRateE > 0 and ElapsedTime >= IncrementFormationRateE * 60 * 60 * 1000  ) {
		ControlFocus,, Idle Champions
		mTip("I did the formation - E")
		IncrementFormationRateE := 0
		GuiControl, ChooseString, IncrementFormationRateE, 0
		setFormation("e")
		; gosub SetAllHeroLevel_E
	}

	if ( (IncrementFormationRateQ = 0) and (IncrementFormationRateW = 0) and (IncrementFormationRateE = 0) ) {
		; this is where I turn off the main Checkbox if all formation rates have gone to zero
		; mTip("Every formation rate 0 turn off.")
		IncrementFormations := 0
		GuiControl,, IncrementFormations, 0
		Gui, Submit, NoHide
		SetTimer checkMasterTicks, off
	}
return

doIncrementFormation:
	Gui, Submit, NoHide
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
	ControlFocus,, Idle Champions

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
	ControlFocus,, Idle Champions
	SendControlKey("Left")
	sleep 750
	SendControlKey("g")
return


doUltimates:
	ControlFocus,, Idle Champions
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

HeroLevel:
	ControlFocus,, Idle Champions ahk_exe IdleDragons.exe
	champs := [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12]
	if ( champs[PriorityChamp] = 1) {
		x := Format("F{1}", PriorityChamp)
		SendControlKey(x)
	}
	if ( C12 = 1) {
		SendControlKey("F12")
	}
	if ( C11 = 1) {
		SendControlKey("F11")
	}
	if ( C10 = 1) {
		SendControlKey("F10")
	}
	if ( C9 = 1) {
		SendControlKey("F9")
	}
	if ( C8 = 1) {
		SendControlKey("F8")
	}
	if ( C7 = 1) {
		SendControlKey("F7")
	}
	if ( C6 = 1) {
		SendControlKey("F6")
	}
	if ( C5 = 1) {
		SendControlKey("F5")
	}
	if ( C4 = 1) {
		SendControlKey("F4")
	}
	if ( C3 = 1) {
		SendControlKey("F3")
	}
	if ( C2 = 1) {
		SendControlKey("F2")
	}
	if ( C1 = 1) {
		SendControlKey("F1")
	}
	if ( ClickDmg = 1) {
		SendControlKey("``")
	}

return

UnsetAllHeroLevel:
	GuiControl,, C1, 0
	GuiControl,, C2, 0
	GuiControl,, C3, 0
	GuiControl,, C4, 0
	GuiControl,, C5, 0
	GuiControl,, C6, 0
	GuiControl,, C7, 0
	GuiControl,, C8, 0
	GuiControl,, C9, 0
	GuiControl,, C10, 0
	GuiControl,, C11, 0
	GuiControl,, C12, 0
	GuiControl,, ClickDmg, 0
	Gui, Submit, NoHide
return

SetAllHeroLevel:
	GuiControl,, C1, 1
	GuiControl,, C2, 1
	GuiControl,, C3, 1
	GuiControl,, C4, 1
	GuiControl,, C5, 1
	GuiControl,, C6, 1
	GuiControl,, C7, 1
	GuiControl,, C8, 1
	GuiControl,, C9, 1
	GuiControl,, C10, 1
	GuiControl,, C11, 1
	GuiControl,, C12, 1
	GuiControl,, ClickDmg, 1
	Gui, Submit, NoHide
return


SetAllHeroLevel_Q: ; Leyline Custom TOA speed formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl,, U1, 0

	GuiControl,, C3, 0
	GuiControl,, C12, 0

	GuiControl,, ClickDmg, 1
	Gui, Submit, NoHide
return

SetAllHeroLevel_W: ; Leyline Custom TOA gold formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl,, C3, 0
	GuiControl,, C12, 0

	GuiControl,, ClickDmg, 0
	Gui, Submit, NoHide
return

SetAllHeroLevel_E: ; Leyline Custom TOA push formation
	gosub SetAllUlt
	gosub SetAllHeroLevel

	GuiControl,, C9, 0
	GuiControl,, C12, 0

	GuiControl,, ClickDmg, 0
	Gui, Submit, NoHide
return

UnsetAllUlt:
	GuiControl,, U1, 0
	GuiControl,, U2, 0
	GuiControl,, U3, 0
	GuiControl,, U4, 0
	GuiControl,, U5, 0
	GuiControl,, U6, 0
	GuiControl,, U7, 0
	GuiControl,, U8, 0
	GuiControl,, U9, 0
	GuiControl,, U10, 0
	Gui, Submit, NoHide
return

SetAllUlt:
	GuiControl,, U1, 1
	GuiControl,, U2, 1
	GuiControl,, U3, 1
	GuiControl,, U4, 1
	GuiControl,, U5, 1
	GuiControl,, U6, 1
	GuiControl,, U7, 1
	GuiControl,, U8, 1
	GuiControl,, U9, 1
	GuiControl,, U10, 1
	Gui, Submit, NoHide
return

SendControlKey(x) {
	; if ( IsGameActive() ) { ; Protects firing when off the game, but also will not fire at all if the game was not fully focus
	; }
	if (A_TimeIdleKeyboard > 3000) {
		ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
	}
	; send the key a second time if > 30s  no idea why this is here, removing.
	; if (A_TimeIdleKeyboard > 30000) {
	; 	ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
	; }
}


; from zee / mike's script
DirectedInput(s) {
	; ReleaseStuckKeys()
	; SafetyCheck()
	ControlFocus,, ahk_exe IdleDragons.exe
	ControlSend,, {Blind}%s%, ahk_exe IdleDragons.exe
	Sleep, 25  ; Sleep for 25 sec formerly ScriptSpeed global, not used elsewhere.
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

ControlClick2_orig(X, Y, WinTitle="", WinText="", ExcludeTitle="", ExcludeText="") {
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
^numpad0:: ; Ctrl + left hotkey
	SetTimer, doClickTest, off
Return
^numpad1:: ; Ctrl + right hotkey
	SetTimer, doClickTest, 60
Return

;^up:: ;control up hotkey
;	setFormation("q")
;return

NumpadSub:: ; for quick reloads during development
	Reload
return

Pause::Pause  ; The Pause/Break key.
#p::Pause  ; Win+P
;=::Pause  ; placeholder for an easy key during mobile remote desktop, or steam link play.


Quit:
ExitApp

