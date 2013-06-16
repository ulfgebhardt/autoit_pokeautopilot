Global const $PROCESS_NAME 					= "javaw.exe" ; Process PokeMMO
Global const $DEBUG 						= True           ;show Tooltip (DEBUG)? "True" to turn on, "False" to turn off

Global const $PATH_WORDS					= "word\"
Global const $PATH_FIELDS					= "field\"
Global const $PATH_MAPS						= "map\"
Global const $PATH_LOGS						= "log\"
Global const $PATH_CFGS						= "cfg\"

Global const $KEY_ACTION 					= "{q down}"
Global const $KEY_ACTION_R 					= "{q up}"
Global const $KEY_CANCEL 					= "e"
Global const $KEY_UP 						= "{w down}"
Global const $KEY_UP_R 						= "{w up}"
Global const $KEY_DOWN 						= "{s down}"
Global const $KEY_DOWN_R 					= "{s up}"
Global const $KEY_LEFT 						= "{a down}"
Global const $KEY_LEFT_R 					= "{a up}"
Global const $KEY_RIGHT 					= "{d down}"
Global const $KEY_RIGHT_R 					= "{d up}"
Global const $KEY_BIKE 						= "1"
;Global const $KEY_ROD 						= "2"
;Global const $KEY_DETECTOR 				= "3"


Global const $KEY_SLEEP_TIME 				= 60
Global const $KEY_HOLD_TIME 				= 35
Global const $SCREEN_SLEEP_TIME 			= 750

Global const $DIRECTION_NORTH				= 0
Global const $DIRECTION_EAST				= 1
Global const $DIRECTION_SOUTH				= 2
Global const $DIRECTION_WEST				= 3

Global const $TRIGGER_TYPE_DOOR				= "TD"
Global const $TRIGGER_TYPE_CUT				= "TC"
Global const $TRIGGER_TYPE_INFO				= "TI"
Global const $TRIGGER_TYPE_NPC				= "TN"
Global const $TRIGGER_TYPE_COMBAT			= "TP"
Global const $TRIGGER_TYPE_HEAL				= "TH"
Global const $TRIGGER_TYPE_PC				= "PC"

Global const $FIELD_TYPE_UNK				= "  "
Global const $FIELD_TYPE_GRASS				= " G"
Global const $FIELD_TYPE_SAND				= " S"
Global const $FIELD_TYPE_BLOCK				= " X"
;Global const $FIELD_TYPE_DOOR				= " D"
;Global const $FIELD_TYPE_PGRASS				= " P"
Global const $FIELD_TYPE_WATER				= " W"
Global const $FIELD_TYPE_JUMP_L				= "JL"
Global const $FIELD_TYPE_JUMP_R				= "JR"
Global const $FIELD_TYPE_JUMP_D				= "JD"
;Global const $FIELD_TYPE_NPC				= " N"
;Global const $FIELD_TYPE_CUT				= " C"
Global const $FIELD_TYPE_NEW				= "NW"
Global const $FIELD_TYPE_WALK				= "WK"
Global const $FIELD_TYPE_TRIGGER_WALKABLE	= "TW"
Global const $FIELD_TYPE_TRIGGER_OBSTACLE	= "TO"

Global const $POS_CATCHCLICK[2]				= [1235,410]
Global const $POS_COMBAT[3]					= [1200,520,0xE0E8E8]
Global const $POS_DIALOG[4]					= [1200,520,0x527dc5,0x729bdf] ; notmouseover; mouseover
Global const $POS_CATCH[3]					= [1200,400,0x5898F8]
Global const $POS_COMBATTEXT[6]				= [450,514,441,21,"00000000",0x000000]
;Global const $POS_DETECTWORLD[2]			= [841,515] ;on bike
Global const $POS_DETECTWORLD[2]			= [873,515]

Global const $MAX_DOORS						= 15

Global const $DETECT_NEWFIELDS				= true
Global const $POKEMON_WITH_CUT				= true

Global const $WORD_WILD 					= 495
Global const $WORDSPACING					= 20