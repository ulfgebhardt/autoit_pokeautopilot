Func is_fieldsave($field)
	return 	$field == $FIELD_TYPE_GRASS OR _
			$field == $FIELD_TYPE_SAND or _			
			$field == $FIELD_TYPE_WALK OR _
			$field == $FIELD_TYPE_TRIGGER_WALKABLE
EndFunc

Func is_checkablefield($field)	
	return 	$field <> "" and _
			$field <> $FIELD_TYPE_NEW and _
			$field <> $FIELD_TYPE_UNK and _		
			$field <> $FIELD_TYPE_TRIGGER_WALKABLE and _
			$field <> $FIELD_TYPE_TRIGGER_OBSTACLE
EndFunc

Func is_validfield($field)
	return 	$field == $FIELD_TYPE_GRASS OR _ 
			$field == $FIELD_TYPE_SAND OR _
			$field == $FIELD_TYPE_BLOCK OR _
			$field == $FIELD_TYPE_WATER OR _
			$field == $FIELD_TYPE_JUMP_L OR _
			$field == $FIELD_TYPE_JUMP_R OR _
			$field == $FIELD_TYPE_JUMP_D OR _			
			$field == $FIELD_TYPE_NEW or _
			$field == $FIELD_TYPE_WALK or _
			$field == $FIELD_TYPE_TRIGGER_WALKABLE or _
			$field == $FIELD_TYPE_TRIGGER_OBSTACLE
EndFunc
Func is_walkable($field,$x,$y)
	return 	$field == $FIELD_TYPE_GRASS OR _
			$field == $FIELD_TYPE_SAND or _
			$field == $FIELD_TYPE_UNK  or _
			$field == "" or _						
			$field == $FIELD_TYPE_WALK OR _
			$field == $FIELD_TYPE_TRIGGER_WALKABLE
EndFunc

; relative
Func go_target($x,$y)		
	$tx = $MAP[1] + $y
	$ty = $MAP[1] + $x
	;local $a[3] = [$map_arr[$tx][$ty],$tx,$ty]
	;_ArrayDisplay($a)
	if not is_walkable($map_arr[$tx][$ty],$x,$y) then					
		return
	endif
		
	if $MAP[3] == 0 then 
		do_log("Target Move: Create Map ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&")")	
		$map_as = $MAP[2]
		_CreateMap($map_as,$MAP[0],$MAP[0])	
		$MAP[3] = $map_as
	else 		
		$map_as = $MAP[3]
	EndIf
	
	do_log("Target Move: Find Path ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&")")	
    Dim $path = _FindPath($map_as,$map_as[$MAP[1]+$POS[1]][$MAP[1]+$POS[0]],$map_as[$tx][$ty])	
	;_ArrayDisplay($path)	
	for $i = 0 to UBound($path)-1
		$p = StringSplit($path[$i],',')
		$x = Int($p[1]) - $MAP[1] - $POS[0] 
		$y = Int($p[2]) - $MAP[1] - $POS[1]	
		if $x == 1 then
			if $POS[2] <> $DIRECTION_EAST then 
				go_right("Target Move: Right Direction ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))
			EndIf
			if not go_right("Target Move: Right ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path)) then 
				do_log("Target Move: Problem Right! ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))
				return false;
			EndIf			
		EndIf
		if $x == -1 then
			if $POS[2] <> $DIRECTION_WEST then 
				go_left("Target Move: Left Direction ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))				
			EndIf
			if not go_left("Target Move: Left ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path)) then 
				do_log("Target Move: Problem Left! ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))				
				return false;
			EndIf						
		EndIf
		if $y == 1 then
			if $POS[2] <> $DIRECTION_SOUTH then 
				go_down("Target Move: Down Direction ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))
			EndIf
			if not go_down("Target Move: Down ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path)) then 
				do_log("Target Move: Problem Down! ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))				
				return false;
			EndIf					
		EndIf
		if $y == -1 then
			if $POS[2] <> $DIRECTION_NORTH then 
				go_up("Target Move: Up Direction ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))
			EndIf
			if not go_up("Target Move: Up ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path)) then 
				do_log("Target Move: Problem Up! ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))	
				return false;
			EndIf			
		EndIf				
	Next
	do_log("Target Move: finish ("&String($ty-$MAP[1])&"|"&String($tx-$MAP[1])&")("&String($ty)&"|"&String($tx)&") "&String($i+1)&"/"&UBound($path))
	
	if Ubound($path) > 1 then 
		screen_gettile_full()
	endif
	
	return true;
EndFunc

Func go($direction,$message = "")
	;check next field
	local $p
	Switch $direction
		Case $DIRECTION_NORTH
			$p = map_update_point(0,-1)
			if is_trigger($POS[0],$POS[1]-1) then								
				if not trigger($POS[0],$POS[1]-1,$direction) then						
					return false ; we trigger, new move	
				EndIf
			EndIf
		Case $DIRECTION_EAST			
			$p = map_update_point(1,0)			
			if is_trigger($POS[0]+1,$POS[1]) then				
				if not trigger($POS[0]+1,$POS[1],$direction) then
					return false ; we trigger, new move
				endif
			EndIf
		Case $DIRECTION_SOUTH
			$p = map_update_point(0,1)
			if is_trigger($POS[0],$POS[1]+1) then				
				if not trigger($POS[0],$POS[1]+1,$direction) then				
					return false ; we trigger, new move
				EndIf
			EndIf
		Case $DIRECTION_WEST
			$p = map_update_point(-1,0)
			if is_trigger($POS[0]-1,$POS[1]) then				
				if not trigger($POS[0]-1,$POS[1],$direction) then									
					return false ; we trigger, new move
				endif
			EndIf
		Case Else Exit
	EndSwitch
	
	;if is_trigger($POS[0],$POS[1]) and is_trigger_walkable($POS[0],$POS[1]) then		
	;	trigger($POS[0],$POS[1],$direction)		
	;	return false
	;EndIf
	
	if not is_fieldsave($p) then
		;handle special fields
		switch $p		
			case $FIELD_TYPE_JUMP_D
				do_log("World: Jump found down, save?")				
				If $POS[2] == $DIRECTION_SOUTH then
					local  $p2
					$p2 = map_update_point(0,2)				
					;we move our curser 1 additional field in that direction cuz jump skips one field.
					if is_fieldsave($p2) then
						$POS[1] += 1
					Else
						do_log("World: Canceled Move, not save there: "& $p2)
						;_ArrayDisplay($POS)
						;_ArrayDisplay($map_arr)
						screen_gettile_full()
						return false
					EndIf
				Else
					do_log("World: Canceled Move, not save there")
					screen_gettile_full()
					return false
				EndIf
			case $FIELD_TYPE_JUMP_L
				do_log("World: Jump found left, save?")
				If $POS[2] == $DIRECTION_WEST then
					local  $p2
					$p2 = map_update_point(-2,0)				
					;we move our curser 1 additional field in that direction cuz jump skips one field.
					if is_fieldsave($p2) then
						$POS[0] -= 1
					Else
						do_log("World: Canceled Move, not save there: "& $p2)
						screen_gettile_full()
						return false
					EndIf
				Else
					do_log("World: Canceled Move, not save there")
					screen_gettile_full()
					return false
				EndIf
			case $FIELD_TYPE_JUMP_R
				do_log("World: Jump found right, save?")
				If $POS[2] == $DIRECTION_EAST then
					local  $p2
					$p2 = map_update_point(2,0)				
					;we move our curser 1 additional field in that direction cuz jump skips one field.
					if is_fieldsave($p2) then
						$POS[0] += 1
					Else
						do_log("World: Canceled Move, not save there: "& $p2)
						screen_gettile_full()
						return false
					EndIf
				Else
					do_log("World: Canceled Move, not save there")
					screen_gettile_full()
					return false
				EndIf			
			Case Else
				do_log("World: Canceled Move, not save there: "& $p)
				screen_gettile_full()				
				return false
		EndSwitch
	EndIf
	
	;do the move
	Switch $direction
		Case $DIRECTION_NORTH
			move_up()
		Case $DIRECTION_EAST
			move_right()
		Case $DIRECTION_SOUTH
			move_down()
		Case $DIRECTION_WEST
			move_left()
		Case Else Exit
	EndSwitch
		
	;message
	do_log($message)
		
	if $p == $FIELD_TYPE_JUMP_L or $p == $FIELD_TYPE_JUMP_R or $p == $FIELD_TYPE_JUMP_D Then
		sleep(2500) ;sleep so jump finishes
	EndIf
	sleep($KEY_SLEEP_TIME)
	
	;state + update pos
	;dialog()
	;catch()
	if not combat() then
		If $POS[2] <> $direction then
			$POS[2] = $direction
		Else
			Switch $direction
				Case $DIRECTION_NORTH
					$POS[1] -= 1
				Case $DIRECTION_EAST
					$POS[0] += 1
				Case $DIRECTION_SOUTH
					$POS[1] += 1
				Case $DIRECTION_WEST
					$POS[0] -= 1
				Case Else Exit
			EndSwitch
		EndIf
	EndIf
	
	return true
EndFunc


Func go_left($message = "")
	return go($DIRECTION_WEST,$message)	
EndFunc

Func go_right($message = "")
	return go($DIRECTION_EAST,$message)
EndFunc

Func go_up($message = "")	
	return go($DIRECTION_NORTH,$message)
EndFunc

Func go_down($message = "")	
	return go($DIRECTION_SOUTH,$message)
EndFunc