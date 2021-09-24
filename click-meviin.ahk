; Necessary to let a hotkey interrupt itself.
#MaxThreadsPerHotkey 2

; Necessary to prevent sending keys when the user is typing
#InstallKeybdHook

IsGameActive() {
	WinGetTitle, title, A
	return title == "Idle Champions"
}

GetGameAhkId() {
  return WinExist("ahk_exe IdleDragons.exe")
}

DirectedInput(key) {
  global is_skilling
  game_ahk_id := GetGameAhkId()
  if !game_ahk_id {
    is_skilling := false
    return
  }
  ; Don't spam keys on the game when the user typed something
  ; in the last 3 seconds
  if (A_TimeIdleKeyboard > 1000) {
    ControlFocus,, ahk_id %game_ahk_id%
    ControlSend,, {Blind}%key%, ahk_id %game_ahk_id%
  }
}

ReleaseStuckKeys()
{
    if GetKeyState("Alt") && !GetKeyState("Alt", "P")
    {
      Send {Alt up}
    }
    if GetKeyState("Shift") && !GetKeyState("Shift", "P")
    {
      Send {Shift up}
    }
    if GetKeyState("Control") && !GetKeyState("Control", "P")
    {
      Send {Control up}
    }
}

IdleLevelBackground() {
  global is_skilling
  num_ticks := 0
  Loop {
    if !is_skilling {
			return
		}
    game_ahk_id := GetGameAhkId()
		if !game_ahk_id {
			is_skilling := false
			return
		}
    ; Click damage and champions
    ; If you don't want to level up a specific champion,
    ; you can add a semicolon before the line  with the 
    ; champion you don't need to comment it out.
    DirectedInput("``")
    DirectedInput("{F1}")
    DirectedInput("{F2}")
    DirectedInput("{F3}")
    DirectedInput("{F4}")
    DirectedInput("{F5}")
    DirectedInput("{F6}")
    DirectedInput("{F7}")
    DirectedInput("{F8}")
    DirectedInput("{F9}")
    DirectedInput("{F10}")
    DirectedInput("{F11}")
    DirectedInput("{F12}")
    ; Move to the next level to make boss chests faster
    DirectedInput("{Right}")
    ; Use ultimates.  Don't use Deekin's ultimate.
    ; DirectedInput("234567890")
    DirectedInput("23456790")
    ReleaseStuckKeys()
		; sleep time in milliseconds
		sleep_time := 250
    num_ticks := num_ticks + 1
		Sleep % sleep_time
  }
}

; Ctrl+Win+End: Start auto leveling
^#End::
	is_skilling := !is_skilling
	; Send {End}
  IdleLevelBackground()
	return

; Ctrl+Win+Del: Turn it off
^#Delete::
	is_skilling := false
	; Send {Delete}
	return