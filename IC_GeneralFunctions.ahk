global gfScriptVer := "v1.0, 9/25/21"

;Requires #include JSON.ahk
LoadObjectFromJSON(FileName)
{
    FileRead, oData, %FileName%
    Return JSON.parse(oData)
}

;Requires #include JSON.ahk
WriteObjectToJSON(FileName, ByRef object)
{
    objectJSON := JSON.stringify(object)
    FileDelete, %FileName%
    FileAppend, %objectJSON%, %FileName%
    Return
}

/* Function to send keyboard inputs to Idle Champions while in background.

    Required Parameter(s):
    s ;The string of keyboard inputs to be sent to Idle Champions.

    Optiona Parameter(s):
    timeToWait ;Time, in milliseconds, function will wait after sending inputs. Default value is 0.
*/
DirectedInput_USELEYLINEMAIN(s, timeToWait := 0)
{
    ControlFocus,, ahk_exe IdleDragons.exe
    ControlSend,, {Blind}%s%, ahk_exe IdleDragons.exe
    Sleep, timeToWait
}

/*  Function to reopen Idle Champions if it is closed.

    Accepts optional parameter install path, folder location of the game install. DO NOT INCLUDE FILE NAME.
    Default value is Steam default install path.
    Returns 0 if game does not need to be restarted.
*/
SafetyCheck(InstallPath := "C:\Program Files (x86)\Steam\steamapps\common\IdleChampions\", delay := 5000)
{
    static lastRan := 0
    i := 0
    if (lastRan + 5000 < A_TickCount)
    {
        While (Not WinExist("ahk_exe IdleDragons.exe"))
        {
            InstallFile := InstallPath "IdleDragons.exe"
            Run, %InstallFile%
            Sleep 2500
            ++i
        }
        lastRan := A_TickCount
    }
    if i
    {
        Sleep 7500
        memory.OpenProcess()
        Sleep 5000
        memory.ModuleBaseAddress()
    }
    Return i
}

;Double tap auto progress after defeating a boss
DoubleG()
{
    if (!Mod(memory.ReadMem( memory.currentZone, "Int" ), 5) AND Mod( memory.ReadMem( memory.highestZone, "Int" ), 5) AND !memory.ReadMem( memory.Transitioning, "Char" ) )
    {
        DirectedInput("g")
        DirectedInput("g")
    }
}

UpdateElapsedTime_USELEYLINEMAIN(StartTime, GUIwin := "MyWindow:", GUIid := "ElapsedTimeID")
{
    ElapsedTime := A_TickCount - StartTime
    GuiControl, %GUIwin%, %GUIid%, % ElapsedTime
    Return ElapsedTime
}

EndAdventure()
{
    ;bring up end adventure dialog box
    DirectedInput("r")
    ;dialog box appears to always have same resolution and buttons can be estimated from center of screen
    xClick := ( memory.ReadMem( memory.currentScreenWidth, "Int" ) / 2) - 80
    yClickMax := memory.ReadMem( memory.currentScreenHeight, "Int" )
    yClick := yClickMax / 2
    StartTime := A_TickCount
    ElapsedTime := 0
    ;attempt to click end adventure button for 30s or until memory reads adventure is resetting
    ;closing IC immediately after this can lead to the adventure not actually resetting and unexpected results
    while(!memory.ReadMem( memory.Resetting, "Char" ) AND ElapsedTime < 30000)
    {
        WinActivate, ahk_exe IdleDragons.exe
        MouseClick, Left, xClick, yClick, 1
        if (yClick < yClickMax)
        yClick := yClick + 10
        Else
        yClick := yClickMax / 2
        Sleep, 25
        ElapsedTime := UpdateElapsedTime(StartTime)
    }
}

;A function that closes IC. If IC takes longer than 60 seconds to save and close then the script will force it closed.
CloseIC()
{
    PostMessage, 0x112, 0xF060,,, ahk_exe IdleDragons.exe
    StartTime := A_TickCount
    ElapsedTime := 0
    While (WinExist("ahk_exe IdleDragons.exe") AND ElapsedTime < 60000)
    {
        Sleep 100
        ElapsedTime := UpdateElapsedTime(StartTime)
    }
    While (WinExist("ahk_exe IdleDragons.exe"))
    {
        PostMessage, 0x112, 0xF060,,, ahk_exe IdleDragons.exe
        sleep 1000
        ElapsedTime := UpdateElapsedTime(StartTime)
    }
}

;a function to confirm game has loaded this function reads game started variable from memory.
;it also reads monsters spawned fromthe offline progress handler and from the active campaing (somewhere else at least I can't remember) to confirm adventure is loaded.
GameLoaded()
{
    StartTime := A_TickCount
    ElapsedTime := 0
    While (memory.ReadMem( memory.gameStarted, "Char" ) != 1 AND ElapsedTime < 60000)
    {
        Sleep, 1000
        ElapsedTime := UpdateElapsedTime(StartTime)
    }
    if (ElapsedTime > 60000)
    {
        Return 0
    }
    StartTime := A_TickCount
    ElapsedTime := 0
    While ( memory.ReadMem( memory.finishedOfflineProgressWindow, "Char" ) != 1 AND ElapsedTime < 30000)
    {
        Sleep, 1000
        ElapsedTime := UpdateElapsedTime(StartTime)
        if (memory.ReadMem( memory.monstersSpawnedThisAreaOP, "Int" ) != memory.ReadMem( memory.monstersSpawnedThisArea, "Int" ) AND memory.ReadMem( memory.monstersSpawnedThisArea, "Int" ))
        {
            Break
        }
    }
    if (ElapsedTime > 30000)
    {
        Return 0
    }
    Return 1
}

;takes input of first and second sets of eight byte int64s that make up a quad in memory. Obviously will not work if quad value exceeds double max.
ConvQuadToDouble(FirstEight, SecondEight)
{
    return (FirstEight + (2.0**63)) * (2.0**SecondEight)
}