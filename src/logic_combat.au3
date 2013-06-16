Func combat()
	;w8 for animation
	sleep(5)
	if is_combat() then
		return do_combat()		
	EndIf
	Return False
EndFunc

Func is_combat()
	$col = PixelGetColor($POS_COMBAT[0],$POS_COMBAT[1],$PROCESS_HANDLE)
	if $col == $POS_COMBAT[2] Then
		do_log("Combat: detected")
		Return True
	Else		
		Return False
	EndIf
EndFunc

Func do_combat()	
	;w8 for animation
	Sleep(5000)
	;get words
	$words = read_combattext()	
	If _ArraySearch($words,$WORD_WILD) == -1 then
		do_log("Combat: false Alarm, not combat")
		sleep(1000)
		return false
	EndIf
	sleep($KEY_SLEEP_TIME)
	do_action()	
	sleep($KEY_SLEEP_TIME)
	sleep($KEY_SLEEP_TIME)

	$catch = false
	for $i = 0 to UBound($POKEMON_CATCH) -1
		If _ArraySearch($words,$POKEMON_CATCH[$i][0]) <> -1 then						
			;catch
			do_log("Combat: Found Pokemon")
			$catch = true
			ExitLoop
		EndIf
	Next
	
	if $catch then
		$state = 0
		while is_combat()
			switch $state
				Case 0
					do_combat_bait()
					sleep(5000)
					$state = 1
				Case 1
					do_combat_ball()
					sleep(5000)
					$state = 2
				Case 2
					do_combat_ball()
					sleep(5000)	
					$state = 0
				Case Else
					return false
			EndSwitch
		WEnd				
	Else
		;no catch
		sleep($KEY_SLEEP_TIME)
		do_combat_run()
	EndIf
	
	sleep(2500)
	return true
EndFunc

Func read_combattext()	
	do_log("Combat: Readtext")	
	local $text[$POS_COMBATTEXT[3]][$POS_COMBATTEXT[2]] ; 21*441		
	FFSnapShot($POS_COMBATTEXT[0], $POS_COMBATTEXT[1], $POS_COMBATTEXT[0]+$POS_COMBATTEXT[2]-1, $POS_COMBATTEXT[1]+$POS_COMBATTEXT[3]-1, $FFDefaultSnapShot, $PROCESS_HANDLE)	
	$datastr = FFGetRawData()		
			
	;assign $text	
	For $i = 0 To $POS_COMBATTEXT[2]*$POS_COMBATTEXT[3] -1
		$line = Floor(($i) / ($POS_COMBATTEXT[2]))
		$col = ($i) - $line * ($POS_COMBATTEXT[2])		
		if StringMid($datastr, $i *8 +1  ,8) ==  $POS_COMBATTEXT[4] then						
			$text[$line][$col] = 1	
		EndIf		
	Next		
		
	local $words[10]
	$emptycount = 0
	$word = 0
	$word_x = 0	
	For $j = 0 To $POS_COMBATTEXT[2] -1
		$empty = true;
		For $i = 0 To $POS_COMBATTEXT[3] -1		
			if $text[$i][$j] == 1 then
				$empty = false
				ExitLoop
			EndIf
		Next		
	
		if $empty then
			$emptycount += 1			
		Else						
			if $emptycount >= $WORDSPACING then				
				FFSnapShot($POS_COMBATTEXT[0]+$word_x, $POS_COMBATTEXT[1], $POS_COMBATTEXT[0]+$j-21, $POS_COMBATTEXT[1]+$POS_COMBATTEXT[3], $FFDefaultSnapShot, $PROCESS_HANDLE)
				$count = FFColorCount($POS_COMBATTEXT[5], 0, false, 0, 0, 0, 0, $FFLastSnap, $PROCESS_HANDLE)
				if not FileExists($PATH_WORDS & $count & ".bmp") then
					FFSaveBMP($PATH_WORDS & $count)
					do_log("Combat: New Text found " & $count)
					sleep(500)
				EndIf
				$word_x = $j
				$words[$word] = $count
				$word += 1
			EndIf
			$emptycount = 0
		EndIf
	Next	
		
	FFSnapShot($POS_COMBATTEXT[0]+$word_x, $POS_COMBATTEXT[1], $POS_COMBATTEXT[0]+$POS_COMBATTEXT[2], $POS_COMBATTEXT[1]+$POS_COMBATTEXT[3], $FFDefaultSnapShot, $PROCESS_HANDLE)	
	$count = FFColorCount($POS_COMBATTEXT[5], 0, false, 0, 0, 0, 0, $FFLastSnap, $PROCESS_HANDLE)
	if not FileExists($PATH_WORDS & $count & ".bmp") then
		FFSaveBMP($PATH_WORDS & $count)
	EndIf
	$words[$word] = $count
	
	$wordstring = "Combat: Pokemon "
	for $i = 0 to 10-1
		$wordstring &= $words[$i]&" "
	Next
	
	do_log($wordstring)
	sleep(50)
	
	return $words
EndFunc