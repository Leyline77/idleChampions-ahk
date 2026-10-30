; Original Author: Abydos, Fritz
; orig filename: idlechamp-v1.4.ahk
; from striderx2048 210614
; edited retaki
; edited Leyline (Swamp Fox II)
	; Clarified some GUI options, such as repeat Formation
	; Simplifieed GUI with Rate in Seconds or Minutes or Hours as appropriate instead of milliseconds
	; Fixed variables and labels (subroutines) having the same name vAutoUlt sets AutoUlt & AutoUlt as a method...  Separated into VAutoUltimates and doAutoUltimates

	; review stuck key stuff here:
	; https://www.autohotkey.com/boards/viewtopic.php?t=19711
	;	While GetKeyState("Ctrl","P") || GetKeyState("LWin","P") || GetKeyState("RWin","P") || GetKeyState("Shift","P") || GetKeyState("Alt","P")
	;		Sleep 50
	;	Send {something}
	;	return

#SingleInstance force
#IfWinExist ahk_exe IdleDragons.exe
#MaxThreadsPerHotkey 10

;global PBS_SMOOTH            := 0x00000001

initialTick := 0
bIncrementFormationQ := 0
bIncrementFormationW := 0
bIncrementFormationE := 0


tmrHours := 0
tmrMinutes := 0
tmrSeconds := 0

Gui 1:Add, CheckBox, w90 y10 vAutoLevel gUpdate Checked0, Auto Leveling

Gui 1:Add, CheckBox, vC1 gUpdate Checked, Seat 1
Gui 1:Add, CheckBox, vC2 gUpdate Checked, Seat 2
Gui 1:Add, CheckBox, vC3 gUpdate Checked, Seat 3
Gui 1:Add, CheckBox, vC4 gUpdate Checked, Seat 4
Gui 1:Add, CheckBox, vC5 gUpdate Checked, Seat 5
Gui 1:Add, CheckBox, vC6 gUpdate Checked, Seat 6
Gui 1:Add, CheckBox, vClickDmg gUpdate Checked0, Click Damage

Gui 1:Add, CheckBox, x+5 y28 vC7 gUpdate Checked, Seat 7
Gui 1:Add, CheckBox, vC8 gUpdate Checked, Seat 8
Gui 1:Add, CheckBox, vC9 gUpdate Checked0, Seat 9
Gui 1:Add, CheckBox, vC10 gUpdate Checked, Seat 10
Gui 1:Add, CheckBox, vC11 gUpdate Checked, Seat 11
Gui 1:Add, CheckBox, vC12 gUpdate Checked0, Seat 12

Gui 1:Add, Text, w90 x+5 y28, Rate (seconds):
Gui 1:Add, DropDownList, w90 vLevelingRate gUpdate, 1|5||10|15|30|60

Gui 1:Add, Text, w90 y+6, Priority Seat:
Gui 1:Add, DropDownList, w90 vPriorityChamp gUpdate, 1|2|3|4|5|6||7|8|9|10|11|12|


Gui 1:Add, CheckBox, w90 y10 vAutoUltimates gUpdate Checked0, Auto Ultimates

Gui 1:Add, CheckBox, vU1 gUpdate Checked, Ult 1
Gui 1:Add, CheckBox, vU2 gUpdate Checked, Ult 2
Gui 1:Add, CheckBox, vU3 gUpdate Checked, Ult 3
Gui 1:Add, CheckBox, vU4 gUpdate Checked, Ult 4
Gui 1:Add, CheckBox, vU5 gUpdate Checked, Ult 5

Gui 1:Add, Text, w90 , Rate (seconds):
Gui 1:Add, DropDownList, w90 vUltRate gUpdate, 1|5||10|15|30|60|300

Gui 1:Add, CheckBox, x+5 y28 vU6 gUpdate Checked, Ult 6
Gui 1:Add, CheckBox, vU7 gUpdate Checked, Ult 7
Gui 1:Add, CheckBox, vU8 gUpdate Checked, Ult 8
Gui 1:Add, CheckBox, vU9 gUpdate Checked, Ult 9
Gui 1:Add, CheckBox, vU10 gUpdate Checked, Ult 10




Gui 1:Add, CheckBox,  x+25 y10 vRepeatFormation gUpdate Checked0, Repeat Formation
Gui 1:Add, Text, , Formation:
Gui 1:Add, DropDownList,  vRepeatFormationSelect gUpdate, 1||2|3
Gui 1:Add, Text, , Rate (Seconds):
Gui 1:Add, DropDownList,  vRepeatFormationRate gUpdate, 1|5||10|15|30|60|120

Gui 1:Add, CheckBox, y+20 vAutoProgress gUpdate Checked0, Auto Progress [ON] (every hour)


;trying to add progress bars for the firing of the events....
;Gui 1:Add, Progress, y+10 w120 h20 -%PBS_SMOOTH% vProgPercent, 0

;Gui 1:Add, Text, y+15 w200, Increment Formations (hours)
Gui 1:Add, CheckBox, y10 w150  vIncrementFormations gdoIncrementFormation Checked0, Increment Formations`n`(Set hours till start)
;Gui 1:Add, CheckBox, y+10 w120 vIncrementFormationQ gUpdate Checked0, Q
Gui 1:Add, Text, y+5, Formation 1 (Q)
Gui 1:Add, DropDownList,  y+1 vIncrementFormationQRate gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5
;Gui 1:Add, CheckBox, y+10 w120 vIncrementFormationW gUpdate Checked0, W
Gui 1:Add, Text, , Formation 2 (W)
Gui 1:Add, DropDownList, y+1 vIncrementFormationWRate gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5
;Gui 1:Add, CheckBox, y+10 w120 vIncrementFormationE gUpdate Checked0, E
Gui 1:Add, Text, , Formation 3 (E)
Gui 1:Add, DropDownList, y+1 vIncrementFormationERate gUpdate, 0||0.5|1.0|1.5|2.0|2.5|3.0|3.5|4.0|4.5|5.0|5.5|6.0|6.5|7.0|7.5|8.0|8.5

; Gui 1: Add, edit, vtmrHours Limit2 Number Right Border w30, %tmrHours%
; Gui 1: Add, text, X+2, :
; Gui 1: Add, edit, X+2 vtmrMinutes Limit2 Number Right Border Range1-5 w30, %tmrMinutes%
; Gui 1: Add, text, X+2, :
; Gui 1: Add, edit, X+2 vtmrSeconds Limit2 Number Right Border w30, %tmrSeconds%

Gui 1: Add, edit, y+10 w120 vidletime,

Gui 1:Add, Button, y10 x+25 gQuit, Quit
Gui 1:Add, Button, w100 y+6 gUnsetAllHeroLevel, Unset All Leveling
Gui 1:Add, Button, w100 y+6 gSetAllHeroLevel, Set All Leveling
Gui 1:Add, Button, w100 y+6 gUnsetAllUlt, Unset All Ult
Gui 1:Add, Button, w100 y+6 gSetAllUlt, Set All Ult

Gui 1:Add, Text,, Win+P (Pause script)

Gui 1:Show


setmousedelay -1
setbatchlines -1


;This is called each time a UI element is updaded it is tied to gUpdate?
Update: ; for the GUI
	Gui, Submit, NoHide

	;ToolTip, Starting Skill Upgrader Loop

	if ( AutoLevel = 1 ) {
		autoLevelingTime := (LevelingRate * 1000)
		;ToolTip I do the level %A_TickCount%
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
		ToolTip doAutoFormation %RepeatFormationRate% - %RepeatFormationTime%
		SetTimer, doRepeatFormation, %RepeatFormationTime%
	} else {
		SetTimer, doRepeatFormation, Off
	}


	if (IncrementFormations = 1 or IncrementFormationQ = 1 or IncrementFormationW = 1 or IncrementFormationE = 1) {
		gosub doIncrementFormation
	}

	;end update function
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

	; tmrHours := ElapsedTime // 1000 // 60 // 60
	; tmrMinutes := ElapsedTime // 1000 // 60
	; tmrSeconds := ElapsedTime // 1000

	; GuiControl,, tmrHours, %tmrHours%
	; GuiControl,, tmrMinutes, %tmrMinutes%
	; GuiControl,, tmrSeconds, %tmrSeconds%




	; test / debug outpuyts...


	; if ( bIncrementFormationQ = 0 and ElapsedTime >= 5 * 1000  ) {
	; 	bIncrementFormationQ := 1
	; 	ToolTip, %ElapsedTime% q
	; }

	; if ( bIncrementFormationW = 0 and ElapsedTime >= 10 * 1000  ) {
	; 	bIncrementFormationW := 1
	; 	ToolTip, %ElapsedTime% w
	; }

	; if ( bIncrementFormationE = 0 and ElapsedTime >= 15 * 1000  ) {
	; 	bIncrementFormationE := 1
	; 	ToolTip, %ElapsedTime% e
	; }

	;IncrementFormations := 0
	;Gui, Submit, NoHide
	;ToolTip, elapsed %ElapsedTime%

	if ( bIncrementFormationQ = 0 and IncrementFormationQRate > 0 and ElapsedTime >= IncrementFormationQRate * 60 * 60 * 1000  ) {
		ControlFocus,, Idle Champions
		toolTip, I did the formation - Q
		bIncrementFormationQ := 1
		GuiControl,, IncrementFormationQRate, 0||
		;Gui, Submit, NoHide
		;SendControlKey("q")
	}

	if ( bIncrementFormationW = 0 and IncrementFormationWRate > 0 and ElapsedTime >= IncrementFormationWRate * 60 * 60 * 1000  ) {
		ControlFocus,, Idle Champions
		toolTip, I did the formation - W
		bIncrementFormationW := 1
		;SendControlKey("w")
	}

	if ( bIncrementFormationE = 0 and IncrementFormationERate > 0 and ElapsedTime >= IncrementFormationERate * 60 * 60 * 1000  ) {
		ControlFocus,, Idle Champions
		toolTip, I did the formation - E
		bIncrementFormationE := 1
		;SendControlKey("e")
	}

	if ((bIncrementFormationQ = 1 OR IncrementFormationQRate = 0) and (bIncrementFormationW = 1 OR IncrementFormationWRate = 0) and (bIncrementFormationE = 1 OR IncrementFormationERate = 0) ) {
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
		ToolTip,  I will increment the formations every hour.
		initialTick := A_TickCount
	}


	if (IncrementFormations = 1) {
		SetTimer checkMasterTicks, 500
	} else {
		ToolTip,  I will NOT increment the formations every hour.
		SetTimer checkMasterTicks, off
	}

	if (false) {

	ToolTip doAutoFormation : FormationSelect

	; add an option to restart the incrementFormation NoTimers
	; add a control in the GUI to show the timer countdown till they fire :)
	; add configs to choose the number of hours to run the formation upgrades


	;perhaps we could check the timers once, and then never re-set them, only clear.  or start them from the original again?


	ControlFocus,, Idle Champions
	if ( IncrementFormationQ = 1 ) {
		;setGlobalTimer here  something like checkTicksQ
		;SendControlKey("q")
	}
	if ( IncrementFormationW = 2 ) {
		;setGlobalTimer here  something like checkTicksW
		;SendControlKey("w")
	}
	if ( IncrementFormationE = 3 ) {
		;setGlobalTimer here  something like checkTicksE
		;SendControlKey("e")
	}


	}

return


doAutoProgress:
	;Turns off autoprogress with left key, then G to resume
	ControlFocus,, Idle Champions
	SendControlKey("Left")
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

;	SendControlKey("Right")

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
return

SendControlKey(x) {
	if (A_TimeIdleKeyboard > 3000) {
		ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
	}
	if (A_TimeIdleKeyboard > 30000) {
		ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
	}
}


;Esc::
	;ExitApp
;return

NumpadSub::
	Reload
return

Pause::Pause  ; The Pause/Break key.
#p::Pause  ; Win+P
;=::Pause  ; Win+P

Quit:
ExitApp

