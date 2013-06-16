;relative
Func is_trigger_walkable($x,$y)
	$trig = get_trigger($x,$y)	
	if $trig <> false then
		if 	$trig[2] == $TRIGGER_TYPE_DOOR or _ ;$trig[2] == $TRIGGER_TYPE_COMBAT or _			
			$trig[2] == $TRIGGER_TYPE_CUT then
			return true
		EndIf
	EndIf
	return false
EndFunc

;relative
Func get_trigger($x,$y)
	for $i == 0 to UBound($TRIGGERS)-1
		if $TRIGGERS[$i][0] == $x and $TRIGGERS[$i][1] == $y then
			dim $trigger[4] = [$TRIGGERS[$i][0],$TRIGGERS[$i][1],$TRIGGERS[$i][2],$TRIGGERS[$i][3]]
			return $trigger
		EndIf
	Next
	return false
EndFunc

Func load_triggerindicators($file)	
	do_log("load Triggerindicators")
	$TRIGGER_INDICATORS = ""
	do_log("Load Triggerindicators: "&$file)
	FileOpen($file, 0)
	For $i = 2 to _FileCountLines($file)
		$line = FileReadLine($file, $i)			
		if IsArray($TRIGGER_INDICATORS) then			
			ReDim $TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)+1][16]
		Else
			Dim $TRIGGER_INDICATORS[1][16]
		EndIf		
		$ar = StringSplit($line,";")
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][0] = $ar[1]		
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][1] = $ar[2]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][2] = $ar[3]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][3] = $ar[4]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][4] = $ar[5]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][5] = $ar[6]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][6] = $ar[7]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][7] = $ar[8]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][8] = $ar[9]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][9] = $ar[10]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][10] = $ar[11]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][11] = $ar[12]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][12] = $ar[13]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][13] = $ar[14]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][14] = $ar[15]
		$TRIGGER_INDICATORS[UBound($TRIGGER_INDICATORS)-1][15] = $ar[16]		
	Next
	FileClose($file)	
EndFunc

Func save_triggers()
	$file = $PATH_MAPS & $POS[3] &".trigger"
	do_log("Save Triggers: "&$file)
	FileOpen($file,2)

	for $i=0 to UBound($TRIGGERS) -1
		$line = $TRIGGERS[$i][0]&";"&$TRIGGERS[$i][1]&";"&$TRIGGERS[$i][2]&";"
		dim $params = $TRIGGERS[$i][3]
		for $j=0 to UBound($params) -1
			;if  $params[$j] <> "" then 				
				$line &= $params[$j]&";"
			;endif
		Next
		if $i < UBound($TRIGGERS)-1 then 
			$line &= @CRLF
		endif
		FileWrite($file,$line)	
	Next
	
	FileClose($file)
EndFunc

Func load_trigger($file)
	do_log("load triggers")	
	$TRIGGERS = ""
	do_log("Load Triggers: "&$file)
	FileOpen($file, 0)
	For $i = 1 to _FileCountLines($file)
		$line = FileReadLine($file, $i)			
		if IsArray($TRIGGERS) then			
			ReDim $TRIGGERS[UBound($TRIGGERS)+1][4]
		Else
			Dim $TRIGGERS[1][4]
		EndIf		
		$ar = StringSplit($line,";")
		$TRIGGERS[UBound($TRIGGERS)-1][0] = $ar[1] ;x
		$TRIGGERS[UBound($TRIGGERS)-1][1] = $ar[2] ;y
		$TRIGGERS[UBound($TRIGGERS)-1][2] = $ar[3] ;type
		local $params = ""
		for $j = 4 to UBound($ar)-2
			if IsArray($params) then 
				ReDim $params[UBound($params)+1]
			else 
				Dim $params[1]
			EndIf
			$params[$j-4] = $ar[$j]
		Next
		$TRIGGERS[UBound($TRIGGERS)-1][3] = $params ;params
	Next
	FileClose($file)	
EndFunc

; relative
Func insert_trigger($x,$y,$type,$params,$failonexist = true)
	for $i = 0 to UBound($TRIGGERS)-1
		if $TRIGGERS[$i][0] == $x and $TRIGGERS[$i][1] == $y then
			if $failonexist then
				return false
			EndIf
			$TRIGGERS[$i][2] = $type ;type	
			if IsArray($params) then 
				$TRIGGERS[$i][3] = $params;params			
			endif
			save_triggers()
			return true
		EndIf
	Next
	if IsArray($TRIGGERS) then			
		ReDim $TRIGGERS[UBound($TRIGGERS)+1][4]
	Else
		Dim $TRIGGERS[1][4]
	EndIf
	$TRIGGERS[UBound($TRIGGERS)-1][0] = $x ;x
	$TRIGGERS[UBound($TRIGGERS)-1][1] = $y ;y
	$TRIGGERS[UBound($TRIGGERS)-1][2] = $type ;type
	if IsArray($params) then 
		$TRIGGERS[UBound($TRIGGERS)-1][3] = $params ;params
	endif
	
	save_triggers()
	return true
EndFunc

func trigger_cut($trigger,$direction)
	do_log("World: Cut found")
	if $direction == $POS[2] then				
		do_log("World: Do Cut")
		if not $POKEMON_WITH_CUT then 
			return false
		endif 	
		move_action()
		sleep(2000)
		move_action()
		sleep(2000)
		move_action()
		sleep(2000)	
		move_action()
		sleep(2500)					
	endif
	return true
EndFunc

func trigger_door($trigger,$direction)	
	do_log("World: Door found")	
	$mapid = 0
	while FileExists($PATH_MAPS & String($mapid) & ".map")
		$mapid = Random(0,10000,1)
	WEnd
	local $params = $trigger[3]
	if not IsArray($params) or Ubound($params) < 3 then
		dim $params[3] = [String($mapid)&'.map',0,0]			
	endif
	Switch $direction					
	Case $DIRECTION_NORTH		
			insert_trigger($POS[0],$POS[1]-1,$TRIGGER_TYPE_DOOR,$params,false)			
			If $POS[2] <> $DIRECTION_NORTH then 
				sleep($KEY_SLEEP_TIME)
				move_up()
				$POS[2] = $DIRECTION_NORTH
				sleep($KEY_SLEEP_TIME)
			EndIf
			sleep($KEY_SLEEP_TIME)
			move_up()
			sleep($KEY_SLEEP_TIME)
			sleep(1500)
			$old_pos = $POS					
			$POS[0] = int($params[1])
			$POS[1] = int($params[2])
			;$POS[2] no change in direction					
			$POS[3] = $params[0]
			map_load()													
			local $back_params[3] = [$old_pos[3],$old_pos[0],$old_pos[1]-1]
			insert_trigger($POS[0],$POS[1]+1,$TRIGGER_TYPE_DOOR,$back_params,false)								
			screen_gettile_full()
			return true										
		Case $DIRECTION_EAST
			insert_trigger($POS[0]+1,$POS[1],$TRIGGER_TYPE_DOOR,$params,false)
			If $POS[2] <> $DIRECTION_EAST then 
				sleep($KEY_SLEEP_TIME)
				move_right()
				$POS[2] = $DIRECTION_EAST
				sleep($KEY_SLEEP_TIME)
			EndIf
			sleep($KEY_SLEEP_TIME)
			move_right()
			sleep($KEY_SLEEP_TIME)			
			sleep(1500)
			$old_pos = $POS			
			$POS[0] = int($params[1])
			$POS[1] = int($params[2])
			;$POS[2] no change in direction					
			$POS[3] = $params[0]
			map_load()					
			local $back_params[3] = [$old_pos[3],$old_pos[0],$old_pos[1]]										
			$map_arr = $MAP[2]			
			if $map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]-1] == $FIELD_TYPE_TRIGGER_WALKABLE THEN
				insert_trigger($POS[0]-1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)
			ElseIf $map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]]+1 == $FIELD_TYPE_TRIGGER_WALKABLE THEN
				insert_trigger($POS[0]+1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)
			Else
				insert_trigger($POS[0]-1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)
				$map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]-1] = $FIELD_TYPE_TRIGGER_WALKABLE
				$MAP[2] = $map_arr
			EndIf
			screen_gettile_full()
			return true			
		Case $DIRECTION_SOUTH
			insert_trigger($POS[0],$POS[1]+1,$TRIGGER_TYPE_DOOR,$params,false)
			If $POS[2] <> $DIRECTION_SOUTH then 
				sleep($KEY_SLEEP_TIME)
				move_down()
				$POS[2] = $DIRECTION_SOUTH
				sleep($KEY_SLEEP_TIME)
			EndIf
			sleep($KEY_SLEEP_TIME)
			move_down()
			sleep($KEY_SLEEP_TIME)
			sleep(1500)
			$old_pos = $POS					
			$POS[0] = int($params[1])
			$POS[1] = int($params[2])
			;$POS[2] no change in direction					
			$POS[3] = $params[0]
			map_load()					
			local $back_params[3] = [$old_pos[3],$old_pos[0],$old_pos[1]]
			insert_trigger($POS[0],$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)	;no change in pos since we stand omn the door
			screen_gettile_full()
			return true
		Case $DIRECTION_WEST				
			insert_trigger($POS[0]-1,$POS[1],$TRIGGER_TYPE_DOOR,$params,false)
			If $POS[2] <> $DIRECTION_WEST then 
				sleep($KEY_SLEEP_TIME)
				move_left()
				$POS[2] = $DIRECTION_WEST
				sleep($KEY_SLEEP_TIME)
			EndIf
			sleep($KEY_SLEEP_TIME)
			move_left()
			sleep($KEY_SLEEP_TIME)
			sleep(1500)
			$old_pos = $POS					
			$POS[0] = int($params[1])
			$POS[1] = int($params[2])
			;$POS[2] no change in direction					
			$POS[3] = $params[0]
			map_load()					
			local $back_params[3] = [$old_pos[3],$old_pos[0],$old_pos[1]]													
			$map_arr = $MAP[2]
			if $map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]-1] == $FIELD_TYPE_TRIGGER_WALKABLE THEN
				insert_trigger($POS[0]-1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)
			ElseIf $map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]+1] == $FIELD_TYPE_TRIGGER_WALKABLE THEN
				insert_trigger($POS[0]+1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)
			Else
				insert_trigger($POS[0]+1,$POS[1],$TRIGGER_TYPE_DOOR,$back_params,false)				
				$map_arr[$MAP[1] + $POS[1]][$MAP[1] + $POS[0]+1] = $FIELD_TYPE_TRIGGER_WALKABLE
				$MAP[2] = $map_arr
			EndIf
			screen_gettile_full()			
			return true			
		Case Else Exit
	EndSwitch
EndFunc

func trigger($x,$y,$direction)
	$trig = get_trigger($x,$y)
	
	if $trig == false then return false
	
	switch $trig[2]
		case $TRIGGER_TYPE_DOOR
			trigger_door($trig,$direction)
			return false;cancel all move we planed
		case $TRIGGER_TYPE_CUT
			return trigger_cut($trig,$direction)
		case $TRIGGER_TYPE_INFO
		case $TRIGGER_TYPE_NPC
		case $TRIGGER_TYPE_COMBAT
		case $TRIGGER_TYPE_HEAL
		case $TRIGGER_TYPE_PC
		case Else
			exit	
	EndSwitch

EndFunc

Func is_trigger($x,$y)	
	for $i = 0 to UBound($TRIGGERS)-1
		if $TRIGGERS[$i][0] == $x and  $TRIGGERS[$i][1] == $y then
			return True
		EndIf
	Next
	
	return false
EndFunc