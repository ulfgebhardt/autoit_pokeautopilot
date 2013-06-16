Global $processName = "javaw.exe" ; Process PokeMMO
Global $processHandle = findProcess($processName)

Global $key_action = "q"
Global $key_cancel = "e"
Global $key_up = "w"
Global $key_down = "s"
Global $key_left = "a"
Global $key_right = "d"
Global $key_bike = "1"
Global $key_rod = "2"
Global $key_detector = "3"

Global $_debug = True           ;show Tooltip (DEBUG)? "True" to turn on, "False" to turn off

__main__()

Func __main__()
	while 1
		do_slots()
	WEnd
EndFunc


Func do_slots()			
	do_log("Slots routine");
	ControlSend($processHandle, "", 0, $key_down)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_down)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_down)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_down)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_action)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_action)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_action)
	sleep(Random(100,200))
	ControlSend($processHandle, "", 0, $key_action)
EndFunc

Func findProcess($pid)
	If IsString($pid) Then $pid = ProcessExists($pid)
	If $pid = 0 Then Return -1
	$list = WinList()
	For $i = 1 To $list[0][0]
		If $list[$i][0] <> "" And BitAND(WinGetState($list[$i][1]), 2) Then
			$wpid = WinGetProcess($list[$i][0])
			If $wpid = $pid Then Return $list[$i][0]
		EndIf
	Next
	Return -1
EndFunc

Func do_log($message)
	if $_debug then ToolTip($message,0,0);
EndFunc