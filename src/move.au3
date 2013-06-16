; Basic Moves
Func move_bike()
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_BIKE)	
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_action($hold = $KEY_HOLD_TIME)
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_ACTION)		
	sleep($hold)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_ACTION_R)
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_cancel()
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_CANCEL)	
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_up($hold = $KEY_HOLD_TIME)
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_UP)
	sleep($hold)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_UP_R)
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_left($hold = $KEY_HOLD_TIME)
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_LEFT)
	sleep($hold)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_LEFT_R)
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_right($hold = $KEY_HOLD_TIME)
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_RIGHT)
	sleep($hold)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_RIGHT_R)
	sleep($KEY_SLEEP_TIME)
EndFunc

Func move_down($hold = $KEY_HOLD_TIME)
	sleep($KEY_SLEEP_TIME)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_DOWN)
	sleep($hold)
	ControlSend($PROCESS_HANDLE, "", 0, $KEY_DOWN_R)
	sleep($KEY_SLEEP_TIME)
EndFunc