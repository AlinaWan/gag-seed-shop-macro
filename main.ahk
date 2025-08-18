; Grow A Garden Seed Shop Macro by Riri
;
; Source code: https://github.com/AlinaWan/gag-seed-shop-macro
;
; MIT License
;
; Copyright (c) 2025 Alina <https://github.com/AlinaWan>
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

; AutoHotkey Script
#NoEnv
#SingleInstance Force
SendMode Input
SetBatchLines -1
SetTitleMatchMode, 2

; Default values
pressDelay := 100
loopCount := 26
running := false

; GUI Setup
Gui, +AlwaysOnTop
Gui, Margin, 10, 10
Gui, Font, s10, Segoe UI

; Tabs: Main + Debug only
Gui, Add, Tab2, x20 y15 w330 h250 vMainTab, Main|Debug

; --- MAIN TAB ---
Gui, Tab, Main
Gui, Add, Text, x30 y50, Object Count:
Gui, Add, Edit, vLoopCountEdit x150 y48 w100, %loopCount%
Gui, Add, Button, gSetLoopCount x255 y47 w90, Set Count

Gui, Add, Text, x30 y90, Press Delay (ms):
Gui, Add, Edit, vDelayEdit x150 y88 w100, %pressDelay%
Gui, Add, Button, gSetDelay x255 y87 w90, Set Delay

Gui, Add, Text, vStatusText x30 y140, F6: Start/Stop | Status: Suspended

; --- DEBUG TAB ---
Gui, Tab, Debug
Gui, Add, Edit, vDebugLog x30 y50 w300 h200 ReadOnly -WantReturn

; Show GUI
Gui, Show, w380 h300, G.A.G Seed Shop Macro by Riri
Return

GuiClose:
ExitApp

; --- Helper logging function ---
Log(msg) {
    GuiControlGet, currentLog, , DebugLog
    FormatTime, timeStr,, HH:mm:ss
    ; Prepend new message to keep latest at top
    newLog := "[" timeStr "] " msg "`n" currentLog
    ; Keep log from growing excessively large, trim from the bottom (oldest entries)
    if (StrLen(newLog) > 3000)
        newLog := SubStr(newLog, 1, 3000)
    GuiControl,, DebugLog, %newLog%
    ; Force scroll to top (to show latest message)
    SendMessage, 0x115, 0, 0, DebugLog ; WM_VSCROLL SB_TOP
}

; --- Input validation setters ---
SetLoopCount:
    global loopCount
    Gui, Submit, NoHide
    if RegExMatch(LoopCountEdit, "^\d+$") && LoopCountEdit > 0 {
        loopCount := LoopCountEdit + 0
        Log("Loop count set to: " loopCount)
    } else {
        loopCount := 26
        GuiControl,, LoopCountEdit, %loopCount%
        Log("Invalid loop count entered. Reverting to default: 26")
    }
Return

SetDelay:
    global pressDelay
    Gui, Submit, NoHide
    if RegExMatch(DelayEdit, "^\d+$") && DelayEdit > 0 {
        pressDelay := DelayEdit + 0
        Log("Delay set to: " pressDelay " ms")
    } else {
        pressDelay := 100
        GuiControl,, DelayEdit, %pressDelay%
        Log("Invalid delay entered. Reverting to default: 100 ms")
    }
Return

; --- Toggle on F6 ---
F6::
    running := !running
    if (running) {
        GuiControl,, StatusText, F6: Start/Stop | Status: Running
        Log("Started")
        SetTimer, DoWork, -10
    } else {
        GuiControl,, StatusText, F6: Start/Stop | Status: Suspended
        Log("Cancelled")
    }
Return

DoWork:
    while (running) {
        ; Initial sequence (once per cycle)
        Send, \
        Send, \
        Sleep, %pressDelay%
        Loop, 10 {
            Send, {Up}
            Sleep, %pressDelay%
        }
        Send, {Down}
        Sleep, %pressDelay%

        ; Main loop sequence repeated loopCount times
        Loop, %loopCount% {
            if (!running)
                break
            Send, {Down}
            Sleep, %pressDelay%
            Send, {Enter}
            Sleep, %pressDelay%
            Send, {Down}
            Sleep, %pressDelay%
            Send, {Left}
            Sleep, %pressDelay%
            
            ; press 50 times at 1ms without regard to press delay
            Loop, 50 {
                if (!running)
                    break
                Send, {Enter}
                Sleep, 1
            }
        }

        ; After loop finishes, press Up 50 times
        Loop, 50 {
            if (!running)
                break
            Send, {Up}
            Sleep, %pressDelay%
        }
    }

    running := false
    GuiControl,, StatusText, F6: Start/Stop | Status: Suspended
    Log("Finished")
Return

