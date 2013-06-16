#Include <WinAPI.au3>
#include <Array.au3>
#include <Math.au3>

#include "src/const.au3"

#include "src/fastfind/FastFind.au3"

#include "src/util.au3"
#include "src/move.au3"
#include "src/move_go.au3"
#include "src/map.au3"
#include "src/trigger.au3"
#include "src/screen.au3"

#include "src/move_combat.au3"
#include "src/logic_catch.au3"
#include "src/logic_combat.au3"
#include "src/logic_dialog.au3"
#include "src/loader.au3"
#include "src/A_Star.au3"

;current pos: x,y,direction,map
Global $POS[4]					= [0,0,$DIRECTION_SOUTH,"fuchsia.city.map"]
;current map loaded: size,zero(center),maparray,a*map
Global $MAP[4]					= [13,4,0,0]
Dim $map_arr[$MAP[0]][$MAP[0]]
$MAP[2] = $map_arr

Global $STATE					= "Startup"

Dim $POKEMON_CATCH				; loaded from file
Dim $FIELDS						; loaded from file
Dim $TRIGGERS					; loaded from file
DIM $TRIGGER_INDICATORS			; loaded from file

Global $PROCESS_HANDLE = findProcess($PROCESS_NAME)

__main__()
Func __main__()		
	load_catch($PATH_CFGS & "catch.cfg")
	load_field($PATH_CFGS & "field.cfg")	
	load_triggerindicators($PATH_CFGS & "triggerindicators.cfg")
		
	map_load()	
	;_ArrayDisplay($map_arr)
	do_log("wait till start")
	WinActivate($PROCESS_NAME)
	sleep(2500)
	do_log("PokeBot: start")
	screen_gettile_full()	
	while 1
		;do_safariwalk()					
		;do_walkleft()		
		;do_randomtargetwalk()
		;sleep(10)
		do_randomtargetwalk()
		sleep(10)
		do_randomtargetwalk()
		sleep(10)
		do_randomdoorwalk()		
		sleep(10)		
		do_edgewalk()
		sleep(10)
		;do_randomwalk()
		;sleep(10)
	WEnd
EndFunc

func do_edgewalk()
	$STATE = "Edge Walker"
	;go_target(2,2)	
	;go_target(2,$MAP[0]-3)	
	;go_target($MAP[0]-3,2)	
	;go_target($MAP[0]-3,$MAP[0]-3)	
	;go_target($MAP[1],2)	
	;go_target(2,$MAP[1])	
	;go_target($MAP[0]-3,$MAP[1])	
	;go_target($MAP[1],$MAP[0]-3)
	$map_arr = $MAP[2]
	$i = Random(0,$MAP[0]-1,1)
	if is_walkable($map_arr[$i][0],$i,0) then 
		go_target(-$MAP[1],$i-$MAP[1])
	ElseIf is_walkable($map_arr[$i][$MAP[0]-1],$i,$MAP[0]-1) then 
		go_target($MAP[1],$i-$MAP[1])
	ElseIf is_walkable($map_arr[0][$i],0,$i) then 
		go_target($i-$MAP[1],-$MAP[1])
	ElseIf is_walkable($map_arr[$MAP[0]-1][$i],$MAP[0]-1,$i) then 
		go_target($i-$MAP[1],$MAP[1])
	EndIf		
EndFunc

func do_finddoor($n)
	$n_c = 0
	for $i = 0 to Ubound($TRIGGERS)-1
		if $TRIGGERS[$i][2] == $TRIGGER_TYPE_DOOR then
			if $n_c == $n then				
					dim $door[2]=[$TRIGGERS[$i][0],$TRIGGERS[$i][1]]					
				return $door
			EndIf
			$n_c += 1
		EndIf
	Next
	
	return false
EndFunc

func do_randomdoorwalk()
	$STATE = "Random Door"	
	$door_n = Random(0,$MAX_DOORS,1)
	do_log("Random Door Move: start: "&String($door_n))
	$door = do_finddoor($door_n)
	if $door == false then 
		do_log("Random Door Move: failed no door found: "&String($door_n))		
		;sleep(2000)		
		return false
	endif
	do_log("Random Map Door Move: rand ("&String($door[0])&"|"&String($door[1])&"):"&String($door_n))
	
	if not go_target($door[0],$door[1]) then
		;_ArrayDisplay($door)		
		do_log("Random Door Move: failed ("&String($door[0])&"|"&String($door[1])&"):"&String($door_n))		
		;sleep(2000)		
		return false
	endif	
	return true
EndFunc

func do_randomtargetwalk()	
	$STATE = "Random Target"
	do_log("Random Target Move: start")
	;$tx = $map_zero[1]+$POS[0]
	;$ty = $map_zero[0]+$POS[1]-1
	;$tx = Random($map_zero[1]+$POS[0]-2,$map_zero[1]+$POS[0]+2,1);
	;$ty = Random($map_zero[0]+$POS[1]-2,$map_zero[0]+$POS[1]+2,1)
	$tx = Random(-$MAP[1], $MAP[1],1)
	$ty = Random(-$MAP[1], $MAP[1],1)
	do_log("Random Target Move: rand ("&String($tx)&"|"&String($ty)&")")
	
	if not go_target($tx,$ty) then
		do_log("Random Target Move: failed ("&String($tx)&"|"&String($ty)&")")
		;sleep(2000)
		return false
	endif
	;$door_fails = 0 ;stay we have discovered stuff?
	return true
EndFunc

Func do_randomwalk()		
	$STATE = "Random Walker"
	$r = Random(0,3,1)
	$r2 = Random(2,10,1)
	
	switch $r
		case 0
			for $i = 0 to $r2
				if not go_up("Random Walker: Up") then ExitLoop
			Next
		case 1
			for $i = 0 to $r2
				if not go_left("Random Walker: Left") then ExitLoop
			Next		
		case 2
			for $i = 0 to $r2
				if not go_down("Random Walker: Down") then ExitLoop	
			Next
		case 3
			for $i = 0 to $r2
				if not go_right("Random Walker: Right") then ExitLoop
			Next
		Case Else
			exit
	EndSwitch
EndFunc

Func do_walkleft()
	go_left("left")	
EndFunc

Func do_safariwalk()

	go_left("Safari Walker: Left")
	go_left()
	go_left()
	go_left()
	go_left()
		
	go_right("Safari Walker: Right")
	go_right()
	go_right()
	go_right()
	go_right()	
	
EndFunc