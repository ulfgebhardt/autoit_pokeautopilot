#include <File.au3>
#include <Array.au3>
#include "../src/const.au3"


Global const $PATH_BLOCK	= "block\"
Global const $PATH_GRASS	= "grass\"
;Global const $PATH_PGRASS	= "pgrass\"
Global const $PATH_SAND		= "sand\"
;Global const $PATH_DOOR		= "door\"
Global const $PATH_WATER	= "water\"
Global const $PATH_JUMP		= "jump\"
;Global const $PATH_NPC		= "npc\"
;Global const $PATH_CUT		= "cut\"
Global const $PATH_WALK		= "walk\"

Global const $PATH_OUTPUT	= "field.cfg"
Global const $PATH_COPY		= "..\cfg\field.cfg"

Global const $PATH_TRIGGERS = "trigger_indicators\"
Global const $PATH_TRIGGERS_OUTPUT = "triggerindicators.cfg"
Global const $PATH_TRIGGERS_COPY = "..\cfg\triggerindicators.cfg"

Global const $PATH_TRIGGERS_INPLACE = "inplace\"
Global const $PATH_TRIGGERS_NORTH = "north\"
Global const $PATH_TRIGGERS_SOUTH = "south\"
Global const $PATH_TRIGGERS_WEST = "west\"
Global const $PATH_TRIGGERS_EAST = "east\"
Global const $PATH_TRIGGERS_NORTH2 = "north2\"
Global const $PATH_TRIGGERS_SOUTH2 = "south2\"
Global const $PATH_TRIGGERS_WEST2 = "west2\"
Global const $PATH_TRIGGERS_EAST2 = "east2\"

Global const $PATH_TRIGGERS_COMBAT = "pgrass\"
Global const $PATH_TRIGGERS_HEAL = "heal\"
Global const $PATH_TRIGGERS_PC = "pc\"
Global const $PATH_TRIGGERS_NPC = "npc\"
Global const $PATH_TRIGGERS_CUT = "cut\"
Global const $PATH_TRIGGERS_DOOR = "door\"
Global const $PATH_TRIGGERS_INFO = "info\"

Func dotriggerfolder($path,$directionx,$directiony,$type)
	Local $FileList = _FileListToArray($path , "*.bmp")
	for $i = 1 to UBound($FileList) -1
		$str = StringSplit($FileList[$i],'.')
		FileWrite($PATH_TRIGGERS_OUTPUT,$str[1]&";"&$str[2]&";"&$str[3]&";"&$str[4]&";"&$str[5]&";"&$str[6]&";"&$str[7]&";"&$str[8]&";"&$str[9]&";"&$str[10]&";"&$str[11]&";"&$str[12]&";"&$str[13]&";"&String($directionx)&";"&String($directiony)&";"&String($type)& @CRLF)
	Next
EndFunc

Func dofolder($path,$type)
	Local $FileList = _FileListToArray($path , "*.bmp")
	for $i = 1 to UBound($FileList) -1
		$str = StringSplit($FileList[$i],'.')
		FileWrite($PATH_OUTPUT,$str[1]&";"&$str[2]&";"&$str[3]&";"&$str[4]&";"&$str[5]&";"&$str[6]&";"&$str[7]&";"&$str[8]&";"&$str[9]&";"&$str[10]&";"&$str[11]&";"&$str[12]&";"&$str[13]&";"&String($type)& @CRLF)
	Next
EndFunc

FileOpen($PATH_OUTPUT,2)
FileWrite($PATH_OUTPUT,"tl;tr;bl;br;ce;type" & @CRLF)

dofolder($PATH_BLOCK,$FIELD_TYPE_BLOCK)
dofolder($PATH_GRASS,$FIELD_TYPE_GRASS)
dofolder($PATH_SAND,$FIELD_TYPE_SAND)
dofolder($PATH_WATER,$FIELD_TYPE_WATER)
dofolder($PATH_JUMP&"left\",$FIELD_TYPE_JUMP_L)
dofolder($PATH_JUMP&"right\",$FIELD_TYPE_JUMP_R)
dofolder($PATH_JUMP&"down\",$FIELD_TYPE_JUMP_D)
dofolder($PATH_WALK,$FIELD_TYPE_WALK)

FileClose($PATH_OUTPUT)

FileCopy($PATH_OUTPUT,$PATH_COPY,1)



FileOpen($PATH_TRIGGERS_OUTPUT,2)
FileWrite($PATH_TRIGGERS_OUTPUT,"tl;tr;bl;br;ce;type" & @CRLF)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_COMBAT,0,0,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_HEAL,0,0,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_PC,0,0,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_NPC,0,0,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_CUT,0,0,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_DOOR,0,0,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_INPLACE & $PATH_TRIGGERS_INFO,0,0,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_COMBAT,0,-1,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_HEAL,0,-1,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_PC,0,-1,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_NPC,0,-1,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_CUT,0,-1,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_DOOR,0,-1,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH & $PATH_TRIGGERS_INFO,0,-1,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_COMBAT,0,-2,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_HEAL,0,-2,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_PC,0,-2,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_NPC,0,-2,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_CUT,0,-2,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_DOOR,0,-2,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_NORTH2 & $PATH_TRIGGERS_INFO,0,-2,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_COMBAT,0,1,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_HEAL,0,1,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_PC,0,1,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_NPC,0,1,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_CUT,0,1,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_DOOR,0,1,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH & $PATH_TRIGGERS_INFO,0,1,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_COMBAT,0,2,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_HEAL,0,2,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_PC,0,2,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_NPC,0,2,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_CUT,0,2,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_DOOR,0,2,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_SOUTH2 & $PATH_TRIGGERS_INFO,0,2,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_COMBAT,-1,0,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_HEAL,-1,0,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_PC,-1,0,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_NPC,-1,0,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_CUT,-1,0,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_DOOR,-1,0,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST & $PATH_TRIGGERS_INFO,-1,0,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_COMBAT,-2,0,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_HEAL,-2,0,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_PC,-2,0,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_NPC,-2,0,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_CUT,-2,0,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_DOOR,-2,0,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_WEST2 & $PATH_TRIGGERS_INFO,-2,0,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_COMBAT,1,0,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_HEAL,1,0,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_PC,1,0,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_NPC,1,0,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_CUT,1,0,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_DOOR,1,0,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST & $PATH_TRIGGERS_INFO,1,0,$TRIGGER_TYPE_INFO)

dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_COMBAT,2,0,$TRIGGER_TYPE_COMBAT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_HEAL,2,0,$TRIGGER_TYPE_HEAL)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_PC,2,0,$TRIGGER_TYPE_PC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_NPC,2,0,$TRIGGER_TYPE_NPC)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_CUT,2,0,$TRIGGER_TYPE_CUT)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_DOOR,2,0,$TRIGGER_TYPE_DOOR)
dotriggerfolder($PATH_TRIGGERS & $PATH_TRIGGERS_EAST2 & $PATH_TRIGGERS_INFO,2,0,$TRIGGER_TYPE_INFO)

FileClose($PATH_TRIGGERS_OUTPUT)

FileCopy($PATH_TRIGGERS_OUTPUT,$PATH_TRIGGERS_COPY,1)