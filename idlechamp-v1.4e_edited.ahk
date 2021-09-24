; Original Author: Abydos, Fritz
; orig filename: idlechamp-v1.4.ahk
;from striderx2048 210614
;edited retaki

#SingleInstance force
#IfWinExist ahk_exe IdleDragons.exe
#MaxThreadsPerHotkey 10

Gui 1:Add, CheckBox, w90 y10 vAutoLevel gUpdate Checked0, Auto Leveling

Gui 1:Add, CheckBox, vC1 gUpdate Checked, Seat 1
Gui 1:Add, CheckBox, vC2 gUpdate Checked, Seat 2
Gui 1:Add, CheckBox, vC3 gUpdate Checked, Seat 3
Gui 1:Add, CheckBox, vC4 gUpdate Checked, Seat 4
Gui 1:Add, CheckBox, vC5 gUpdate Checked, Seat 5
Gui 1:Add, CheckBox, vC6 gUpdate Checked, Seat 6
Gui 1:Add, CheckBox, vClickDmg gUpdate Checked, Click Damage

Gui 1:Add, CheckBox, x+5 y28 vC7 gUpdate Checked, Seat 7
Gui 1:Add, CheckBox, vC8 gUpdate Checked, Seat 8
Gui 1:Add, CheckBox, vC9 gUpdate Checked, Seat 9
Gui 1:Add, CheckBox, vC10 gUpdate Checked, Seat 10
Gui 1:Add, CheckBox, vC11 gUpdate Checked, Seat 11
Gui 1:Add, CheckBox, vC12 gUpdate Checked, Seat 12

Gui 1:Add, Text, w90 x+5 y28, Rate:
Gui 1:Add, DropDownList, w90 vRate gUpdate, 1000|5000||10000|15000|30000

Gui 1:Add, Text, w90 y+6, Priority Seat:
Gui 1:Add, DropDownList, w90 vPriorityChamp gUpdate, 1|2|3|4|5|6|7|8|9|10|11|12||


Gui 1:Add, CheckBox, w90 y10 vAutoUlt gUpdate Checked0, Auto Ult

Gui 1:Add, CheckBox, vU1 gUpdate Checked, Ult 1
Gui 1:Add, CheckBox, vU2 gUpdate Checked, Ult 2
Gui 1:Add, CheckBox, vU3 gUpdate Checked, Ult 3
Gui 1:Add, CheckBox, vU4 gUpdate Checked, Ult 4
Gui 1:Add, CheckBox, vU5 gUpdate Checked, Ult 5

Gui 1:Add, CheckBox, x+5 y28 vU6 gUpdate Checked, Ult 6
Gui 1:Add, CheckBox, vU7 gUpdate Checked, Ult 7
Gui 1:Add, CheckBox, vU8 gUpdate Checked, Ult 8
Gui 1:Add, CheckBox, vU9 gUpdate Checked, Ult 9
Gui 1:Add, CheckBox, vU10 gUpdate Checked, Ult 10


Gui 1:Add, Text, w90 x+5 y28, Rate:
Gui 1:Add, DropDownList, w90 y+0 vUltRate gUpdate, 1000|5000||10000|15000|30000


Gui 1:Add, CheckBox, w90 x+5 y10 vAutoFormation gUpdate Checked0, Auto Load Formation
Gui 1:Add, Text, w90, Formation:
Gui 1:Add, DropDownList, w90 y+0 vFormationSelect gUpdate, 1||2|3
Gui 1:Add, Text, w90, Rate:
Gui 1:Add, DropDownList, w90 y+0 vFormationRate gUpdate, 1000|5000||10000|15000|30000

Gui 1:Add, CheckBox, w90y10 vAutoProgress gUpdate Checked0, Auto Progress

Gui 1:Add, Button, x+5 y10 gQuit, Quit
Gui 1:Add, Button, y+6 w100 gUnsetAllHeroLevel, Unset All Leveling
Gui 1:Add, Button, y+6 w100 gSetAllHeroLevel, Set All Leveling
Gui 1:Add, Button, y+6 w100 gUnsetAllUlt, Unset All Ult
Gui 1:Add, Button, y+6 w100 gSetAllUlt, Set All Ult

Gui 1:Add, Text,, Win+P (Pause script)

Gui 1:Show

Update:
Gui, Submit, NoHide


if ( AutoLevel = 1 ) {
    SetTimer, HeroLevel, %Rate%
}
else {
    SetTimer, HeroLevel, Off
}
if ( AutoUlt = 1 ) {
    SetTimer, AutoUlt, %UltRate%
} else {
    SetTimer, AutoUlt, Off
}
if ( AutoProgress = 1 ) {
    SetTimer, AutoProg, 300000
} else {
    SetTimer, AutoProg, Off
}
if ( AutoFormation = 1 ){
	SetTimer, AutoFormation, %FormationRate%
} else {
	SetTimer, AutoFormation, Off
}
return

setmousedelay -1
setbatchlines -1

AutoFormation:
	ControlFocus,, Idle Champions
		if ( FormationSelect = 1 )
	{
		SendControlKey("q")
	}
	if ( FormationSelect = 2 )
	{
		SendControlKey("w")
	}
	if ( FormationSelect = 3 )
	{
		SendControlKey("e")
	}
return

AutoProg:
    ControlFocus,, Idle Champions
    SendControlKey("g")
return

AutoUlt:
    ControlFocus,, Idle Champions
    Ults := [U1, U2, U3, U4, U5, U6, U7, U8, U9, U10]
	if ( U1 = 1)
    {
        SendControlKey("1")
    }
    if ( U2 = 1)
    {
        SendControlKey("2")
    }
    if ( U3 = 1)
    {
        SendControlKey("3")
    }
    if ( U4 = 1)
    {
        SendControlKey("4")
    }
    if ( U5 = 1)
    {
        SendControlKey("5")
    }
    if ( U6 = 1)
    {
        SendControlKey("6")
    }
    if ( U7 = 1)
    {
        SendControlKey("7")
    }
    if ( U8 = 1)
    {
        SendControlKey("8")
    }
    if ( U9 = 1)
    {
        SendControlKey("9")
    }
    if ( U10 = 1)
    {
        SendControlKey("0")
    }

return

HeroLevel:
    ControlFocus,, Idle Champions ahk_exe IdleDragons.exe
    champs := [C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12]
    if ( champs[PriorityChamp] = 1)
    {
        x := Format("F{1}", PriorityChamp)
        SendControlKey(x)
    }
    if ( C12 = 1)
    {
        SendControlKey("F12")
    }
    if ( C11 = 1)
    {
        SendControlKey("F11")
    }
    if ( C10 = 1)
    {
        SendControlKey("F10")
    }
    if ( C9 = 1)
    {
        SendControlKey("F9")
    }
    if ( C8 = 1)
    {
        SendControlKey("F8")
    }
    if ( C7 = 1)
    {
        SendControlKey("F7")
    }
    if ( C6 = 1)
    {
        SendControlKey("F6")
    }
    if ( C5 = 1)
    {
        SendControlKey("F5")
    }
    if ( C4 = 1)
    {
        SendControlKey("F4")
    }
    if ( C3 = 1)
    {
        SendControlKey("F3")
    }
    if ( C2 = 1)
    {
        SendControlKey("F2")
    }
    if ( C1 = 1)
    {
        SendControlKey("F1")
    }
    if ( ClickDmg = 1)
    {
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

SendControlKey(x)
{
   if (A_TimeIdleKeyboard > 3000) {
		ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
   }
   if (A_TimeIdleKeyboard > 30000)
    {
	ControlSend,, {%x%}, Idle Champions ahk_exe IdleDragons.exe
   }

}


;Esc::
;ExitApp
;return

;Numpad0::
;Reload
;return

Pause::
Pause  ; The Pause/Break key.
#p::Pause  ; Win+P

Quit:
ExitApp

