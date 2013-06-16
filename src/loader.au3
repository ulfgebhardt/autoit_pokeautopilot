#include <File.au3>

Func load_catch($file)	 
	do_log("load Catch")
	FileOpen($file, 0)
	For $i = 2 to _FileCountLines($file)
		$line = FileReadLine($file, $i)			
		if IsArray($POKEMON_CATCH) then			
			ReDim $POKEMON_CATCH[UBound($POKEMON_CATCH)+1][2]
		Else
			Dim $POKEMON_CATCH[1][2]
		EndIf		
		$ar = StringSplit($line,";")
		$POKEMON_CATCH[UBound($POKEMON_CATCH)-1][0] = $ar[1]
		$POKEMON_CATCH[UBound($POKEMON_CATCH)-1][1] = $ar[2]
	Next
	FileClose($file)	
EndFunc

Func load_field($file)	 
	do_log("load Fields")
	FileOpen($file, 0)
	For $i = 2 to _FileCountLines($file)
		$line = FileReadLine($file, $i)			
		if IsArray($FIELDS) then			
			ReDim $FIELDS[UBound($FIELDS)+1][14]
		Else
			Dim $FIELDS[1][14]
		EndIf		
		$ar = StringSplit($line,";")
		$FIELDS[UBound($FIELDS)-1][0] = $ar[1]
		$FIELDS[UBound($FIELDS)-1][1] = $ar[2]
		$FIELDS[UBound($FIELDS)-1][2] = $ar[3]
		$FIELDS[UBound($FIELDS)-1][3] = $ar[4]
		$FIELDS[UBound($FIELDS)-1][4] = $ar[5]
		$FIELDS[UBound($FIELDS)-1][5] = $ar[6]
		$FIELDS[UBound($FIELDS)-1][6] = $ar[7]
		$FIELDS[UBound($FIELDS)-1][7] = $ar[8]
		$FIELDS[UBound($FIELDS)-1][8] = $ar[9]
		$FIELDS[UBound($FIELDS)-1][9] = $ar[10]
		$FIELDS[UBound($FIELDS)-1][10] = $ar[11]
		$FIELDS[UBound($FIELDS)-1][11] = $ar[12]
		$FIELDS[UBound($FIELDS)-1][12] = $ar[13]
		$FIELDS[UBound($FIELDS)-1][13] = $ar[14]		
	Next
	FileClose($file)	
EndFunc