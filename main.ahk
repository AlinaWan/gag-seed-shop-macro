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

; --- Gui ---
Gui, Destroy
Gui, +AlwaysOnTop +Resize +MinimizeBox
Gui, Margin, 16, 16
Gui, Color, 0x2C2F33, 0x2C2F33  ; Discord dark gray
Gui, Font, s10 cFFFFFF, Segoe UI

; --- Header ---
Gui, Font, s12 c00CED1 Bold, Segoe UI  ; Accent blurple
Gui, Add, Text, x20 y15 w340 Center vHeaderLink gHeaderLinkEvent, G.A.G Seed Shop Macro
Gui, Font, s9 cB9BBBE, Segoe UI
Gui, Add, Text, x20 y40 w340 Center, by Riri

; Tabs
Gui, Font, s9 cFFFFFF, Segoe UI
Gui, Add, Tab2, x20 y70 w360 h200 vMainTab +Background23272A, Main|Debug

; --- MAIN TAB ---
Gui, Tab, Main
Gui, Font, s10 c00CED1 Bold, Segoe UI
Gui, Add, Text, x40 y100, Macro Parameters
Gui, Font, s10 cFFFFFF, Segoe UI
Gui, Add, Text, x40 y135, Object Count:
Gui, Add, Edit, vLoopCountEdit x180 y133 w90 +Background23272A cFFFFFF, %loopCount%
Gui, Add, Button, gSetLoopCount x280 y132 w80 h24 +Background7289DA cFFFFFF, Apply

Gui, Add, Text, x40 y175, Press Delay (ms):
Gui, Add, Edit, vDelayEdit x180 y173 w90 +Background23272A cFFFFFF, %pressDelay%
Gui, Add, Button, gSetDelay x280 y172 w80 h24 +Background7289DA cFFFFFF, Apply

; --- DEBUG TAB ---
Gui, Tab, Debug
Gui, Font, s10 c00CED1 Bold, Segoe UI
Gui, Add, Text, x40 y100, Debug Output

Gui, Font, s9 cE0E0E0, Consolas
Gui, Add, Edit, vDebugLog x40 y125 w300 h120 ReadOnly -WantReturn +Background1E1E1E cFFFFFF

; --- Status Bar ---
Gui, Tab
Gui, Font, s9 cB9BBBE, Segoe UI
Gui, Add, Text, vStatusText x20 y280 w360 Center, Status: Suspended (Press F6 to toggle)

; --- Show GUI ---
Gui, Show, w400 h320, G.A.G Seed Shop Macro by Riri
Return

GuiClose:
ExitApp

HeaderLinkEvent:
    Run, https://github.com/AlinaWan/gag-seed-shop-macro
Return

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
