Func map_confirm_pos($9x9arr,$x,$y)	
	local $ar_pos[2] = [$MAP[1]+$y-4,$MAP[1]+$x-4]	
	$new_ar_pos = map_resize($ar_pos[0]+9,$ar_pos[1]+9)
	$new_ar_pos = map_resize($new_ar_pos[0]-9,$new_ar_pos[1]-9)
	$ar_pos = $new_ar_pos
	$map_arr = $MAP[2]
	for $i = 0 to 9 -1
		for $j = 0 to 9 -1			
			if is_checkablefield($map_arr[$ar_pos[0]+$j][$ar_pos[1]+$i]) and is_checkablefield($9x9arr[$j][$i]) then
				if $map_arr[$ar_pos[0]+$j][$ar_pos[1]+$i] <> $9x9arr[$j][$i] then				
					;_ArrayDisplay($9x9arr)
					do_log($map_arr[$ar_pos[0]+$j][$ar_pos[1]+$i] &" "& $9x9arr[$j][$i] &" "&String($x)&" "&String($y)&" "&String($j)&" "&String($i))
					;sleep(10000)					
					return false
				endif
			EndIf
		Next
	Next
	return true
EndFunc

Func map_load()		
	$file = $PATH_MAPS & $POS[3]
	load_trigger($file &".trigger")
	do_log("Load Map: "&$file)
	$MAP[2] = ""
	FileOpen($file, 0)
	if _FileCountLines($file) <= 0 then 
		FileClose($file)
		$MAP[0] = 13	
		Dim $map_arr[$MAP[0]][$MAP[0]]
		$MAP[1] = ($MAP[0]-1)/2
		$MAP[2] = $map_arr
		return
	EndIf
	$size_str = FileReadLine($file, 1)
	$size_spt = StringSplit($size_str,'x')
	$MAP[0] = Int($size_spt[1])
	Dim $map_arr[$MAP[0]][$MAP[0]]
	$MAP[1] = ($MAP[0]-1)/2	
	For $i = 1 to $MAP[0]
		$line = FileReadLine($file, $i+1)
		$ar = StringSplit($line,";")
		for $j=1 to $MAP[0]
			if $ar[$j] == $FIELD_TYPE_UNK then
				$ar[$j] = ""
			EndIf		
			$map_arr[$i-1][$j-1] = $ar[$j]						
		Next
	Next
	$MAP[2] = $map_arr
	$MAP[3] = 0
	FileClose($file)		
EndFunc

;x,y absolute
Func map_resize($y,$x)
	while $y <= 1 or $y >= $MAP[0]-1 or $x <= 1 or $x >= $MAP[0]-1
		local $new_map[$MAP[0]+4][$MAP[0]+4]
		$map_arr = $MAP[2]
		for $i = 0 to $MAP[0]-1
			for $j = 0 to $MAP[0]-1				
				$new_map[$i+2][$j+2] = $map_arr[$i][$j]				
			Next
		Next
		$MAP[2] = $new_map
		$MAP[0] +=4
		;$POS[0] += 2
		;$POS[1] += 2
		$x += 2
		$y += 2
		$MAP[1] += 2
		$MAP[3] = 0
	WEnd
	dim $the_new_pos[2] = [$y,$x]
	return $the_new_pos
EndFunc

;x,y relative
Func map_update($9x9arr,$x,$y)
	local $ar_pos[2] = [$MAP[1]+$y-4,$MAP[1]+$x-4]
	$new_ar_pos = map_resize($ar_pos[0]+9,$ar_pos[1]+9)
	$new_ar_pos = map_resize($new_ar_pos[0]-9,$new_ar_pos[1]-9)
	$ar_pos = $new_ar_pos
	$map_arr = $MAP[2]
	for $i = 0 to 9 -1
		for $j = 0 to 9 -1
			if $map_arr[$ar_pos[0]+$i][$ar_pos[1]+$j] == ""  or $map_arr[$ar_pos[0]+$i][$ar_pos[1]+$j] == $FIELD_TYPE_NEW or $9x9arr[$i][$j] == $FIELD_TYPE_TRIGGER_WALKABLE or $9x9arr[$i][$j] == $FIELD_TYPE_TRIGGER_OBSTACLE then				
				$map_arr[$ar_pos[0]+$i][$ar_pos[1]+$j] = $9x9arr[$i][$j]
				$MAP[3] = 0
			EndIf
		Next
	Next
	$MAP[2] = $map_arr
	map_save()
EndFunc

Func map_save()
	$file = $PATH_MAPS&$POS[3]
	do_log("Save Map: "&$file)
	FileOpen($file,2)
	FileWrite($file,String($MAP[0])&"x"&String($MAP[0])& @CRLF)	
	for $i=0 to $MAP[0] -1
		$line = ""
		for $j=0 to $MAP[0] -1
			if $map_arr[$i][$j] == "" or $map_arr[$i][$j] == $FIELD_TYPE_NEW then
				$line &= $FIELD_TYPE_UNK&";"
			Else
				$line &= $map_arr[$i][$j] &";"
			EndIf
		Next
		FileWrite($file,$line & @CRLF)	
	Next
	
	FileClose($file)
EndFunc

;x,y relative to absolute
Func map_update_point($x,$y)	
	local $a_pos[2] =  [$MAP[1]+$POS[1]+$y,$MAP[1]+$POS[0]+$x]	
	if $map_arr[$a_pos[0]][$a_pos[1]] == "" OR $map_arr[$a_pos[0]][$a_pos[1]] == $FIELD_TYPE_NEW then
		local $p = screen_gettile($x,$y)
		$new_ar_pos = map_resize($MAP[1]+$POS[1]+$y,$MAP[1]+$POS[0]+$x)
		$a_pos = $new_ar_pos
		;dim $k[4] =[$x,$y,$a_pos[0],$a_pos[1]]	
		$map_arr = $MAP[2]	
		$map_arr[$a_pos[0]][$a_pos[1]] = $p[14]			
		;map_save()
		$MAP[2] = $map_arr
	EndIf	
	
	;do_log($map_arr[$a_pos[0]][$a_pos[1]]&" "&String($a_pos[0])&" "&String($a_pos[1])&" "&String($x)&" "&String($y))
	;sleep(10000)
	return $map_arr[$a_pos[0]][$a_pos[1]]
EndFunc