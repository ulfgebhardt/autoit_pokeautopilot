; x, y relative to playerpos!
Func screen_gettile($x,$y,$sleep = true)	
	if $sleep then 
		sleep($SCREEN_SLEEP_TIME)
	endif
	FFSnapShot($POS_DETECTWORLD[0]+($x-1)*64 -1, $POS_DETECTWORLD[1]+($y-1)*64 -1, $POS_DETECTWORLD[0]+$x*64 -2, $POS_DETECTWORLD[1]+$y*64 -2, $FFDefaultSnapShot, $PROCESS_HANDLE)		
	$tl = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1 +5,$POS_DETECTWORLD[1]+($y-1)*64 -1 +5)
	$tr = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1 +59,$POS_DETECTWORLD[1]+($y-1)*64 -1 +5)
	$bl = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1 +5,$POS_DETECTWORLD[1]+($y-1)*64 -1 +59)
	$br = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1 +59,$POS_DETECTWORLD[1]+($y-1)*64 -1 +59)
	$ce = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+32,$POS_DETECTWORLD[1]+($y-1)*64 -1 +32)
	$ctl = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+16,$POS_DETECTWORLD[1]+($y-1)*64 -1 +16)
	$ctr = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+48,$POS_DETECTWORLD[1]+($y-1)*64 -1 +16)	
	$cbl = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+16,$POS_DETECTWORLD[1]+($y-1)*64 -1 +48)
	$cbr = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+48,$POS_DETECTWORLD[1]+($y-1)*64 -1 +48)
	$mt = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+32,$POS_DETECTWORLD[1]+($y-1)*64 -1 +5)
	$mr = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+59,$POS_DETECTWORLD[1]+($y-1)*64 -1 +32)
	$mb = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+32,$POS_DETECTWORLD[1]+($y-1)*64 -1 +59)
	$ml = FFGetPixel($POS_DETECTWORLD[0]+($x-1)*64 -1+5,$POS_DETECTWORLD[1]+($y-1)*64 -1 +32)
	$known = false
	$field_type = $FIELD_TYPE_UNK	
	for $k = 0 to UBound($FIELDS) -1					
		$field_type = $FIELD_TYPE_UNK
		local $field[14] = [$FIELDS[$k][0],$FIELDS[$k][1],$FIELDS[$k][2],$FIELDS[$k][3],$FIELDS[$k][4],$FIELDS[$k][5],$FIELDS[$k][6],$FIELDS[$k][7],$FIELDS[$k][8],$FIELDS[$k][9],$FIELDS[$k][10],$FIELDS[$k][11],$FIELDS[$k][12],$FIELDS[$k][13]]			
		if $field[0] == $tl and $field[1] == $tr and $field[2] == $bl and $field[3] == $br and $field[4] == $ce and $field[5] == $ctl and $field[6] == $ctr and $field[7] == $cbr and $field[8] == $cbl and $field[9] == $mt and $field[10] == $mr and $field[11] == $mb and $field[12] == $ml then		
			$known = true
			$field_type = $FIELDS[$k][13]
			ExitLoop
		EndIf		
		$field_type = $FIELD_TYPE_NEW
	Next
	
	for $k = 0 to UBound($TRIGGER_INDICATORS) -1							
		local $field[13] = [$TRIGGER_INDICATORS[$k][0],$TRIGGER_INDICATORS[$k][1],$TRIGGER_INDICATORS[$k][2],$TRIGGER_INDICATORS[$k][3],$TRIGGER_INDICATORS[$k][4],$TRIGGER_INDICATORS[$k][5],$TRIGGER_INDICATORS[$k][6],$TRIGGER_INDICATORS[$k][7],$TRIGGER_INDICATORS[$k][8],$TRIGGER_INDICATORS[$k][9],$TRIGGER_INDICATORS[$k][10],$TRIGGER_INDICATORS[$k][11],$TRIGGER_INDICATORS[$k][12]]			
		if $field[0] == $tl and $field[1] == $tr and $field[2] == $bl and $field[3] == $br and $field[4] == $ce and $field[5] == $ctl and $field[6] == $ctr and $field[7] == $cbr and $field[8] == $cbl and $field[9] == $mt and $field[10] == $mr and $field[11] == $mb and $field[12] == $ml then					
			insert_trigger($POS[0]+$x+int($TRIGGER_INDICATORS[$k][13]),$POS[1]+$y+int($TRIGGER_INDICATORS[$k][14]),$TRIGGER_INDICATORS[$k][15],0)
			if is_trigger_walkable($POS[0]+$x+int($TRIGGER_INDICATORS[$k][13]),$POS[1]+$y+int($TRIGGER_INDICATORS[$k][14])) then 
				$field_type = $FIELD_TYPE_TRIGGER_WALKABLE
				if int($TRIGGER_INDICATORS[$k][13]) > 0 or int($TRIGGER_INDICATORS[$k][14]) > 0 then
					$map_arr = $MAP[2]
					$map_arr[$POS[1]+$y+int($TRIGGER_INDICATORS[$k][14])+$MAP[1]][$POS[0]+$x+int($TRIGGER_INDICATORS[$k][13])+$MAP[1]] = $FIELD_TYPE_TRIGGER_WALKABLE
					$MAP[2] = $map_arr
				endif
			Else
				if int($TRIGGER_INDICATORS[$k][13]) <> 0 or int($TRIGGER_INDICATORS[$k][14]) <> 0 then
					$map_arr = $MAP[2]
					$map_arr[$POS[1]+$y+int($TRIGGER_INDICATORS[$k][14])+$MAP[1]][$POS[0]+$x+int($TRIGGER_INDICATORS[$k][13])+$MAP[1]] = $FIELD_TYPE_TRIGGER_OBSTACLE
					$MAP[2] = $map_arr
				endif
				$field_type = $FIELD_TYPE_TRIGGER_OBSTACLE
			EndIf			
			$known = true
			ExitLoop
		EndIf
	Next
	
	dim $res[15] = [$tl,$tr,$bl,$br,$ce,$ctl,$ctr,$cbr,$cbl,$mt,$mr,$mb,$ml,$known,$field_type]
		
	
	if $DETECT_NEWFIELDS and not $known and not FileExists($PATH_FIELDS & $res[0] & "." & $res[1] & "." & $res[2] & "." & $res[3] & "." & $res[4] & "." & $res[5] & "." & $res[6] & "." & $res[7] & "." & $res[8] & "." & $res[9] & "." & $res[10] & "." & $res[11] & "." & $res[12] &".bmp") then				
		FFSaveBMP($PATH_FIELDS & $res[0] & "." & $res[1] & "." & $res[2] & "." & $res[3] & "." & $res[4] & "." & $res[5] & "." & $res[6] & "." & $res[7] & "." & $res[8] & "." & $res[9] & "." & $res[10] & "." & $res[11] & "." & $res[12])		
		do_log("World: New Field found " & $PATH_FIELDS & $res[0] & "." & $res[1] & "." & $res[2] & "." & $res[3] & "." & $res[4]& "." & $res[5] & "." & $res[6] & "." & $res[7] & "." & $res[8] & "." & $res[9] & "." & $res[10] & "." & $res[11] & "." & $res[12])										
	EndIf
	
	return $res
EndFunc

Func screen_gettile_full()
	sleep($SCREEN_SLEEP_TIME)
	do_log("World: Read full")
	local $text[9][9];   4<-----0----->4
	$detected = 0
	for $i = -4 to 4
		for $j = -4 to 4
			if $i <> 0 or $j <> 0 then 
				dim $count[15]
				$count = screen_gettile($i,$j,false)
				if $count[14] then
					$text[$j+4][$i+4] = $count[14]
					$detected += 1					
				EndIf
			EndIf
		Next
	Next
	if not map_confirm_pos($text,$POS[0],$POS[1]) then
		do_log("POSITION PROBLEM")
		sleep(10000)
		if map_confirm_pos($text,$POS[0]+1,$POS[1]) then
			$POS[0] += 1			
		ElseIf map_confirm_pos($text,$POS[0]-1,$POS[1]) then
			$POS[0] -= 1			
		ElseIf map_confirm_pos($text,$POS[0],$POS[1]+1) then
			$POS[1] += 1		
		ElseIf map_confirm_pos($text,$POS[0],$POS[1]-1) then
			$POS[1] -= 1			
		Elseif map_confirm_pos($text,$POS[0]+2,$POS[1]) then
			$POS[0] += 2			
		ElseIf map_confirm_pos($text,$POS[0]-2,$POS[1]) then
			$POS[0] -= 2			
		ElseIf map_confirm_pos($text,$POS[0],$POS[1]+2) then
			$POS[1] += 2		
		ElseIf map_confirm_pos($text,$POS[0],$POS[1]-2) then
			$POS[1] -= 2
		Elseif map_confirm_pos($text,$POS[0]+1,$POS[1]+1) then
			$POS[0] += 1			
			$POS[1] += 1
		ElseIf map_confirm_pos($text,$POS[0]-1,$POS[1]-1) then
			$POS[0] -= 1			
			$POS[1] -= 1
		ElseIf map_confirm_pos($text,$POS[0]-1,$POS[1]+1) then
			$POS[0] -= 1		
			$POS[1] += 1
		ElseIf map_confirm_pos($text,$POS[0]+1,$POS[1]-1) then
			$POS[0] += 1
			$POS[1] -= 1			
		Else			
			;ConsoleWrite(_ArrayToString($text))
			;ConsoleWrite(String($POS[0]))
			;ConsoleWrite(String($POS[1]))
			exit
		EndIf
	EndIf
	do_log("Detected "&String($detected)&"/80")		
	map_update($text,$POS[0],$POS[1])
EndFunc