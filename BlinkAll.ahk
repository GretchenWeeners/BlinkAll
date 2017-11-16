;   .-----------------------------------------------------------------.
;  /  .-.                                                         .-.  \
; |  /   \                     BlinkAll                          /   \  |
; | |\_.  |         (Minimize All Open Windows)                 |    /| |
; |\|  | /|                      by                             |\  | |/|
; | `---' |                 Kenzy Carey                         | `---' |
; |       |                                                     |       |
; |       | Desc: Minimize all windows, to bypass kisk software |       |
; |       | Inst: Compile, Optionally burn to CD/DVD            |       |
; |       |-----------------------------------------------------|       |
; \       |                                                     |       /
;  \     /                                                       \     /
;   `---'                                                         `---'

; if burning to CD/DVD, include a file named autorun.inf with the following:
; [Autorun]
; Open=BlinkALL.exe
; Action=BlinkAll
; Label=BlinkAll
; Icon=BlinkAll.exe


#SingleInstance Force										; ensure only one instance of the software is runninh
WinGet, id, list,,, Program Manager							; get list of running programs
Loop, %id%													; loop through programs
{
	var_active_id := id%A_Index%							
	WinGet, var_exstyle, ExStyle, ahk_id %var_active_id%	; determine of the window has AlwaysOnTop set (keeps it on top of all other windows, sometimes prevents minimizing)
	if (ExStyle & 0x8)										; if AlwaysOnTop is set
	{
		WinSet, AlwaysOnTop, Off, ahk_id %var_active_id%	; turn AlwaysOnTop off
		GoSub, Sub_Minimize									; minimize
		WinSet, AlwaysOnTop, On, ahk_id %var_active_id%		; turn AlwaysOnTop back on
	} else GoSub, Sub_Minimize								; if AlwaysOnTop was not set, just minimize
}

var_dir := SubStr(A_ScriptDir,1,1)							; get the drive letter of where the script is running from
DriveGet, var_isdvddrive, StatusCD, %var_dir%:				; get status of the drive letter (to see if its running from cd)
if (var_isdvddrive != "")									; if CDStatus is not blank, we are running from cd
	Drive, Eject, %var_dir%:								; so we better eject
ExitApp														; goo bye bye

Sub_Minimize:												; subroutine to minimize the window
WinGetTitle, active_title, ahk_id %var_active_id%			; get window title
if (active_title!="") 										; if the window has a title, its most likely not a system window, so its safe to minimie it
	WinMinimize, ahk_id %var_active_id%						; minimize the window
return