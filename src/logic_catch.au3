Func catch()
	;w8 for animation
	sleep(5)
	if is_catch() then
		do_catch()
		return True
	EndIf
	
	Return False
EndFunc

Func do_catch()
	MouseClick("left",$POS_CATCHCLICK[0],$POS_CATCHCLICK[1])
	sleep(8500)
EndFunc

Func is_catch()	
	$col = PixelGetColor($POS_CATCH[0],$POS_CATCH[1],$PROCESS_HANDLE)
	if $col == $POS_CATCH[2] Then
		do_log("Catch: detected")
		Return True
	Else		
		Return False
	EndIf
EndFunc