Func do_log($message)		
	Switch $POS[2]
		Case $DIRECTION_NORTH
			$dir = "NORTH"
		Case $DIRECTION_SOUTH
			$dir = "SOUTH"
		Case $DIRECTION_EAST
			$dir = "EAST"
		Case $DIRECTION_WEST
			$dir = "WEST"
		Case Else
			Exit
		EndSwitch
		
	if $DEBUG and $message <> "" then		
		ToolTip("Pokeautopilot POS("&String($POS[0])&"|"&String($POS[1])&")("&String($MAP[1] + $POS[0])&"|"&String($MAP[1] + $POS[1])&"):"&$dir&" on "&$POS[3]&":"&String($MAP[0])&"x"&String($MAP[0])&": "&$STATE&": "&$message,0,0);
		;sleep(3000)
	EndIf	
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

Func log_mousepos()
	Local $pos = MouseGetPos()
	do_log($pos[0] & ";" & $pos[1])
EndFunc

Func _WinAPI_DrawRect($start_x, $start_y, $iWidth, $iHeight, $iColor)
    Local $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
    Local $tRect = DllStructCreate($tagRECT)
    DllStructSetData($tRect, 1, $start_x)
    DllStructSetData($tRect, 2, $start_y)
    DllStructSetData($tRect, 3, $iWidth)
    DllStructSetData($tRect, 4, $iHeight)
    Local $hBrush = _WinAPI_CreateSolidBrush($iColor)

    _WinAPI_FrameRect($hDC, DllStructGetPtr($tRect), $hBrush)

    ; clear resources
    _WinAPI_DeleteObject($hBrush)
    _WinAPI_ReleaseDC(0, $hDC)
EndFunc   ;==>_WinAPI_DrawRect

Func getGrayValue($in)	
	$Hex = StringTrimLeft($in, 2)
	$R = Dec(StringLeft($Hex, 2))
	$G = Dec(StringMid($Hex, 3, 2))
	$B = Dec(StringRight($Hex, 2))
	return  Dec(Hex(($R + $G + $B) / 3, 2))
EndFunc