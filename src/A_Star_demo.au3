;==============================
; Author: Toady
; Site: www.itoady.com
; Updated: May 21, 2008
; AutoIt Ver: 3.2.12.0
;
; A * Searching Alorithm
; Artificial Intelligence
; Robot path finding
;==============================
#include <array.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>

;==================== START OF MAIN =================
; Example GUI by, Hallman and Toady

ProcessSetPriority("Autoit3.exe", 4)
Global $first_label = 0
Global $last_label = 0

Global Const $rows = 16
Global Const $cols = 16

Global $estimate
Global $closedList_data
Global $closedList_Str = "_"
Global $openList_Str = "_"
Global $start_handel[3]
Global $end_handel[3]
Global $barrier = _ArrayCreate(-1)
Dim $data[16][16]
$MainWindow = GUICreate("A * Search Algorithm - Bot pathing", 400, 540)
Dim $gridboxes = _ArrayCreate("none")
For $i = 1 To 16 Step 1
	For $ii = 1 To 16 Step 1
		If $i <> 1 And $i <> 16 And $ii <> 1 And $ii <> 16 Then
			$temp = GUICtrlCreateLabel("", (($i - 1) * 25), (($ii - 1) * 25), 25, 25, $SS_SUNKEN )
			_ArrayAdd($gridboxes, $temp)
			GUICtrlSetBkColor(-1, 0x000000)
		Else
			$temp = GUICtrlCreateLabel("", (($i - 1) * 25), (($ii - 1) * 25), 25, 25)
			GUICtrlSetBkColor(-1, 0x0220099)
		EndIf
		$data[$i - 1][$ii - 1] = "x"
		If $i = 1 And $ii = 1 Then
			$first_label = $temp
			$start_handel[0] = $temp
			$start_handel[1] = 1
			$start_handel[2] = 1
		EndIf
		If $i = 16 And $ii = 16 Then
			$last_label = $temp
			$end_handel[0] = $temp
			$end_handel[1] = 16
			$end_handel[2] = 16
		EndIf
		If $ii = 1 Or $ii = 16 Then
			_ArrayAdd($barrier, $temp)
		EndIf
	Next
Next

Dim $map = $data
Dim $resetData = $data

$Wall_Radio = GUICtrlCreateRadio("Wall", 90, 410, 50, 20)
GUICtrlSetState($Wall_Radio, $GUI_CHECKED)
$Space_Radio = GUICtrlCreateRadio("Flat ground", 10, 410, 80, 20)
$sand_Radio = GUICtrlCreateRadio("Sand", 10, 450, 70, 20)
$water_Radio = GUICtrlCreateRadio("Water", 10, 475, 70, 20)
$hill_Radio = GUICtrlCreateRadio("Hill", 10, 500, 70, 20)
$Start_Radio = GUICtrlCreateRadio("Start", 150, 410, 70, 20)
$End_Radio = GUICtrlCreateRadio("Goal", 220, 410, 70, 20)
GUICtrlSetBkColor($End_Radio, 0xff0000)
GUICtrlCreateGroup("Searching Heuristic", 80, 435, 200, 100)
$md_Radio = GUICtrlCreateRadio("Manhattan", 100, 450, 70, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$ed_Radio = GUICtrlCreateRadio("Euclidean", 180, 450, 70, 20)
GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
GUICtrlSetBkColor($Start_Radio, 0x00ff00)
GUICtrlSetBkColor($End_Radio, 0xff0000)
$show_searched_nodes = GUICtrlCreateCheckbox("Show searched nodes (SN)", 100, 470)
$allow_diagonals = GUICtrlCreateCheckbox("Allow diagonal moves", 100, 490)
$allow_overestimate = GUICtrlCreateCheckbox("Overestimate", 100, 510)
GUICtrlSetTip($allow_overestimate, "Faster, no guaranteed shortest path")
$go_btn = GUICtrlCreateButton("Go!", 300, 410, 80, 20)
$reset_btn = GUICtrlCreateButton("Reset", 300, 435, 80, 20)
GUICtrlCreateLabel("Total cost:", 300, 470)
$total_cost = GUICtrlCreateLabel("0", 355, 470, 40)
GUICtrlCreateLabel("Nodes:", 300, 490)
$total_nodes = GUICtrlCreateLabel("0", 355, 490, 40)
GUICtrlCreateLabel("Time (ms):", 300, 510)
$total_time = GUICtrlCreateLabel("0", 355, 510, 40)
Global $Sel_Type = 1
GUISetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $go_btn
			$buffer = ""
			$closedList_Str = "_"
			$openList_Str = "_"
			Global $heuristic = BitAND(GUICtrlRead($md_Radio), $GUI_CHECKED)
			$SLocation = _GetStartingLocation($data, $rows, $cols) ;starting location
			$GLocation = _GetGoalLocation($data, $rows, $cols) ;goal location
			If $SLocation = 0 Or $GLocation = 0 Then
				MsgBox(0, "Error", "A Goal and a Start must be placed")
				$map = $data
			Else
				Dim $temp[16][16]
				$temp = $data
				Local $allow_overestimate_Boolean = BitAND(GUICtrlRead($allow_overestimate), $GUI_CHECKED)
				If $allow_overestimate_Boolean = 1 Then
					$estimate = 1.001 ;used to overestimate heuristic by a small amount
				Else
					$estimate = 1
				EndIf
				Global $allow_diagonals_Boolean = BitAND(GUICtrlRead($allow_diagonals), $GUI_CHECKED)
				SplashTextOn("A * Algorithm processing", "Please wait until bot is finished", 200, 100)
				GUICtrlSetState($go_btn, $GUI_DISABLE)
				GUICtrlSetState($reset_btn, $GUI_DISABLE)
				$map = $data
				_CreateMap($data, $cols, $rows) ;replaces data with node objects
				Local $timer = TimerInit()
				Dim $path = _FindPath($data, $data[$SLocation[1]][$SLocation[0]], $data[$GLocation[1]][$GLocation[0]])
				Local $timerend = TimerDiff($timer)
				$closedList_data = StringSplit($closedList_Str, '_', 1) ;not part of algorithm, used in gui
				GUICtrlSetData($total_nodes, UBound($closedList_data) - 4) ;used in gui also
				GUICtrlSetData($total_time, Round($timerend, 0))
				SplashOff()
				;display searched nodes
				Local $show_searched_Boolean = BitAND(GUICtrlRead($show_searched_nodes), $GUI_CHECKED)
				If $show_searched_Boolean Then
					Dim $searchedNodes[UBound($closedList_data) ]
					For $i = 3 To UBound($closedList_data) - 3
						Local $coord = StringSplit($closedList_data[$i], ",")
						Local $coord_last = StringSplit($closedList_data[$i - 1], ",")
						$searchedNodes[$i] = GUICtrlCreateLabel(" SN", $coord[1] * 25, $coord[2] * 25, 25, 25, BitOR($SS_SUNKEN, $SS_CENTERIMAGE))
						;GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT) ;uses this if you want transparent nodes
						GUICtrlSetBkColor(-1, 0xFFFF00)
						Sleep(100)
					Next
				EndIf
				If IsArray($path) Then ;if path exists
					Dim $trail[UBound($path) ]
					$label = GUICtrlCreateLabel("", 0, 0, 25, 25)
					Local $last_temp[3] = [2, 1, 1]
					For $i = 0 To (UBound($path) - 1) Step 1
						If UBound($path) = 1 Then
							Local $nextToCoord = StringSplit($path[0], ",")
							GUICtrlSetPos($label, $nextToCoord[1] * 25, $nextToCoord[2] * 25)
							GUICtrlSetBkColor(-1, 0xccffff)
							GUICtrlSetData($total_cost, 1)
							ExitLoop
						EndIf
						$temp = $path[$i]
						$temp = StringSplit(StringReplace($temp, "|", ""), ",")
						If $i > 0 Then
							$last_temp = $path[$i - 1]
							$last_temp = StringSplit(StringReplace($last_temp, "|", ""), ",")
						EndIf
						GUICtrlSetPos($label, $temp[2] * 25, $temp[1] * 25)
						GUICtrlSetBkColor(-1, 0xccffff)
						$trail[$i] = GUICtrlCreateLabel("", $temp[2] * 25, $temp[1] * 25, 25, 25, $SS_SUNKEN)
						GUICtrlSetBkColor($trail[$i], 0x00dddd)
						Local $obj = $data[$temp[2]][$temp[1]]
						GUICtrlSetData($total_cost, Round($obj[3], 2))
						If Abs($temp[1] - $last_temp[1]) + Abs($temp[2] - $last_temp[2]) < 2 Then
							Sleep(200)
						Else
							Sleep(280) ;delay a little long to make animation smooth
						EndIf
					Next
					Sleep(500)
					GUICtrlDelete($label)
					For $i = 0 To UBound($path) - 1
						GUICtrlDelete($trail[$i])
					Next
					If $show_searched_Boolean Then
						If IsArray($searchedNodes) Then
							For $i = 0 To UBound($searchedNodes) - 1
								GUICtrlDelete($searchedNodes[$i])
							Next
						EndIf
					EndIf
					GUICtrlSetState($Wall_Radio, $GUI_CHECKED)
					$data = $map
				Else
					MsgBox(0, "", "No path to goal") ;if goal can't be reached
					If $show_searched_Boolean Then
						If IsArray($searchedNodes) Then
							For $i = 0 To UBound($searchedNodes) - 1
								GUICtrlDelete($searchedNodes[$i])
							Next
						EndIf
					EndIf
					$data = $map
					GUICtrlSetState($Wall_Radio, $GUI_CHECKED)
					$Sel_Type = 1
				EndIf
				GUICtrlSetState($go_btn, $GUI_ENABLE)
				GUICtrlSetState($reset_btn, $GUI_ENABLE)
			EndIf
		Case $msg >= $first_label + 16 And $msg <= $last_label - 16 And _ArraySearch($barrier, $msg) < 0
			$sel_X = Ceiling(($msg - $first_label + 1) / 16)
			$sel_Y = Ceiling($msg - $first_label + 1) - ($sel_X - 1) * 16
			If $Sel_Type = 1 Then
				GUICtrlSetBkColor($msg, 0x000000)
				$data[$sel_X - 1][$sel_Y - 1] = "x"
			ElseIf $Sel_Type = 2 Then
				GUICtrlSetBkColor($msg, 0xeeeeee)
				$data[$sel_X - 1][$sel_Y - 1] = "1"
			ElseIf $Sel_Type = 3 Then
				If $data[$start_handel[1] - 1][$start_handel[2] - 1] = "s" Then
					GUICtrlSetBkColor($start_handel[0], 0xeeeeee)
					$data[$start_handel[1] - 1][$start_handel[2] - 1] = "1"
				EndIf
				$start_handel[0] = $msg
				$start_handel[1] = $sel_X
				$start_handel[2] = $sel_Y
				GUICtrlSetBkColor($msg, 0x00ff00)
				$data[$sel_X - 1][$sel_Y - 1] = "s"
			ElseIf $Sel_Type = 4 Then
				If $data[$end_handel[1] - 1][$end_handel[2] - 1] = "g" Then
					GUICtrlSetBkColor($end_handel[0], 0xeeeeee)
					$data[$end_handel[1] - 1][$end_handel[2] - 1] = "1"
				EndIf
				$end_handel[0] = $msg
				$end_handel[1] = $sel_X
				$end_handel[2] = $sel_Y
				GUICtrlSetBkColor($msg, 0xff0000)
				$data[$sel_X - 1][$sel_Y - 1] = "g"
			ElseIf $Sel_Type = 5 Then;sand
				GUICtrlSetBkColor($msg, 0xFFdd44)
				$data[$sel_X - 1][$sel_Y - 1] = "2" ;2 times harder than flat ground
			ElseIf $Sel_Type = 6 Then;water
				GUICtrlSetBkColor($msg, 0x2222FF)
				$data[$sel_X - 1][$sel_Y - 1] = "3" ;3 times harder than flat ground
			ElseIf $Sel_Type = 7 Then;hill
				GUICtrlSetBkColor($msg, 0x885500)
				$data[$sel_X - 1][$sel_Y - 1] = "4" ;4 times harder than flat ground
			EndIf
		Case $msg = $Wall_Radio
			$Sel_Type = 1
		Case $msg = $Space_Radio
			$Sel_Type = 2
		Case $msg = $Start_Radio
			$Sel_Type = 3
		Case $msg = $End_Radio
			$Sel_Type = 4
		Case $msg = $sand_Radio
			$Sel_Type = 5
		Case $msg = $water_Radio
			$Sel_Type = 6
		Case $msg = $hill_Radio
			$Sel_Type = 7
		Case $msg = $reset_btn
			$data = $resetData
			For $i = 1 To UBound($gridboxes) - 1
				GUICtrlSetBkColor($gridboxes[$i], 0x000000)
			Next
			GUICtrlSetData($total_cost, "0")
			GUICtrlSetData($total_nodes, "0")
			GUICtrlSetData($total_time, "0")
	EndSelect
WEnd
;==================== END OF MAIN =================

;============ * How to use this code * ============
; Below is the A * Searching algorithm and its
; required functions to work.
; This is coded to work with 2D spaces only.
; Everything below is all you need to get started.

; 1. Initialize a 2D array
;     $data[5][5] = [["x","x","x","x","x"], _
;                    ["x","s","0","x","x"], _
;                    ["x","x","0","x","x"], _
;                    ["x","x","0","g","x"], _
;                    ["x","x","x","x","x"]]
;       NOTE: Array MUST have x's around entire paremeter
;       There must be a "s" and a "g". "0" means bot can walk here
; 2. Convert array into node objects
;       _CreateMap($data,5,5)
; 3. Calculate path
;       Dim $path = _FindPath($data,$data[1][1],$data[3][3])
; 4. Thats all!
;       The variable $path contains an array of the path in "x,y" format
;       _ArrayDisplay($path) will show the the full path
;==================================================

;=============================================================================
; Replaces data grid with node objects
; Converts $data into a 2D array of node objects from previous $data array
; consisting of only string characters.
;=============================================================================
Func _CreateMap(ByRef $data, $x, $y) ;converts a 2D array of data to node objects
	For $i = 0 To $y - 1 ;for each row
		For $j = 0 To $x - 1 ;for each column
			If StringRegExp($data[$i][$j], "[x,s,g]") <> 1 Then;if not a x,s,g
				$data[$i][$j] = _CreateNode($i & "," & $j, "null", 0, $data[$i][$j], 0, $data[$i][$j])
			Else
				If $data[$i][$j] = "s" Then
					$data[$i][$j] = _CreateNode($i & "," & $j, "null", 0, 0, 0, $data[$i][$j])
				Else
					$data[$i][$j] = _CreateNode($i & "," & $j, "null", 0, 1, 0, $data[$i][$j])
				EndIf
			EndIf
		Next
	Next
EndFunc   ;==>_CreateMap
;=============================================================================
; Creates a node struct object with the following parameters
; struct node {
;   char self_coord[8];          // Format = "x,y"
;   char parent_coord[8];        // Format = "x,y"
;   int f;                       // F = G + H
;   int g;                       // G = current cost to this node from start node
;   int h;                       // H = Heuristic cost, this node to goal node
;   char value[8];               // Type of node (ex. "s","g","x","1,2,3..n")
;   int cost;                    // Cost of node (difficulty of traveling on this)
; }
;=============================================================================
Func _CreateNode($self, $parent, $f, $g, $h, $value) ;returns struct object
	Local $node[6] = [$self, $parent, $f, $g, $h, $value]
	Return $node
EndFunc   ;==>_CreateNode
;=============================================================================
; Checks to see if start node exists in map
; Returns an array: [y,x]
;=============================================================================
Func _GetStartingLocation(ByRef $data, $cols, $rows)
	For $i = 0 To $cols - 1
		For $j = 0 To $rows - 1
			If $data[$i][$j] = "s" Then
				Local $pos[2] = [$j, $i]
				Return $pos
			EndIf
		Next
	Next
	Return 0 ;no starting location found
EndFunc   ;==>_GetStartingLocation
;=============================================================================
; Checks to see if goal node exists in map
; Returns an array: [y,x]
;=============================================================================
Func _GetGoalLocation(ByRef $data, $cols, $rows)
	For $i = 0 To $cols - 1
		For $j = 0 To $rows - 1
			If $data[$i][$j] = "g" Then
				Local $pos[2] = [$j, $i]
				Return $pos
			EndIf
		Next
	Next
	Return 0 ;no starting location found
EndFunc   ;==>_GetGoalLocation
;=============================================================================
; Calculates the manhattan distance between two nodes
; MD = |G(x) - N(x)| + |G(y) - N(x)|
; Returns an integer
;=============================================================================
Func _MD(ByRef $node, ByRef $goal) ;returns integer
	Local $node_coord = StringSplit($node[0], ",") ;current node
	Local $goal_coord = StringSplit($goal[0], ",") ;goal node
	Return (Abs($goal_coord[1] - $node_coord[1]) + Abs($goal_coord[2] - $node_coord[2])) * $estimate
EndFunc   ;==>_MD
;=============================================================================
; Calculates the Euclidean distance between two nodes
; MD = SquareRoot ( (G(x) - N(x))^2 + (G(y) - N(x))^2 )
; Returns an integer
;=============================================================================
Func _ED(ByRef $node, ByRef $goal) ;returns integer
	Local $node_coord = StringSplit($node[0], ",") ;current node
	Local $goal_coord = StringSplit($goal[0], ",") ;goal node
	Return Sqrt(($goal_coord[1] - $node_coord[1]) ^ 2 + ($goal_coord[2] - $node_coord[2]) ^ 2) * $estimate
EndFunc   ;==>_ED
;=============================================================================
; A * Searching Algorithm
; Keep searching nodes until the goal is found.
; Returns: Array if path found
; Returns: 0 if no path
;=============================================================================
Func _FindPath(ByRef $map, $start_node, $goal_node) ;returns array of coords
	Local $openlist = _ArrayCreate("empty") ;start with empty open list
	Local $closedlist = _ArrayCreate("empty") ;start with empty closed list
	Local $current_node = $start_node ;set current node to start nodeF
	$closedList_Str &= $current_node[0] & "_"
	$openList_Str &= $current_node[0] & "_"
	_AddAdjacents_Openlist($map, $openlist, $closedlist, $current_node, $goal_node) ;add all possible adjacents to openlist
	While 1 ;while goal is not in closed list, or open list is not empty
		If UBound($openlist) = 1 Then ExitLoop ;if open list is empty then no path found
		$current_node = _GetLowest_F_Cost_Node($openlist) ;pick node with lowest F cost
		$closedList_Str &= $current_node[0] & "_"
		_AddAdjacents_Openlist($map, $openlist, $closedlist, $current_node, $goal_node) ;add all possible adjacents to openlist
		If $current_node[0] = $goal_node[0] Then ExitLoop ;if current node is goal then path is found!
	WEnd
	If _IsInClosedList($goal_node[0]) = 0 Then ;if no goal found then return 0
		Return 0 ; no path found
	Else
		Return _GetPath($map, $current_node, $start_node) ;return array of coords (x,y) in string format
	EndIf
EndFunc   ;==>_FindPath
;=============================================================================
; Returns node object with the lowest F cost
; F = G + H
; Returns 0 with openlist is emtpy, there is no path
;=============================================================================
Func _GetLowest_F_Cost_Node(ByRef $openlist)
	If UBound($openlist) > 1 Then ;If open list is not empty
		Local $obj = $openlist[1] ;Pop first item in the queue
		_ArrayDelete($openlist, 1) ;remove this node from openlist
		Return $obj ;return lowest F cost node
	EndIf
	Return 0 ;openlist is empty
EndFunc   ;==>_GetLowest_F_Cost_Node
;=============================================================================
; Start from goal node and traverse each parent node until starting node is
; reached.
; Each node will have a parent node (use this to get path bot will take)
; Returns: Array of coords, first index is starting location
;=============================================================================
Func _GetPath(ByRef $data, ByRef $ending_node, ByRef $start_node)
	Local $path = _ArrayCreate($ending_node[0]) ;start from goal node
	Local $node_coord = StringSplit($path[0], ",")
	Local $x = $node_coord[1]
	Local $y = $node_coord[2]
	Local $start = $start_node[0] ;starting nodes coord
	Local $obj = $data[$x][$y] ;current node starting from the goal
	While $obj[1] <> $start ;keep adding until reached starting node
		_Add_List($path, $y & "," & $x) ;add the parent node to the list
		$obj = $data[$x][$y] ;get node from 2D data array
		$node_coord = StringSplit($obj[1], ",")
		If $node_coord[0] = 1 Then ExitLoop
		$x = $node_coord[1]
		$y = $node_coord[2]
	WEnd
	_ArrayDelete($path, 0) ;no need to starting node
	_ArrayReverse($path) ;flip array to make starting node at index 0
	Return $path ;return path as array in "x,y" format for each item
EndFunc   ;==>_GetPath
;=============================================================================
; Adds adjacent nodes to the open list if:
; 1. Node is not a barrier "x"
; 2. Node is not in open list
; 3. Node is not in closed list
; Set newly added node's parent to the current node and update its F,G, and H
; Only need to check North, South, East and West nodes.
;=============================================================================
Func _AddAdjacents_Openlist(ByRef $data, ByRef $openlist, ByRef $closedlist, ByRef $node, ByRef $goal)
	Local $current_coord = StringSplit($node[0], ",")
	Local $x = $current_coord[1]
	Local $y = $current_coord[2]
	Local $h ; heuristic
	Local $north = 0
	Local $south = 0
	Local $east = 0
	Local $west = 0
	Local $obj = $data[$x][$y - 1]
	If $obj[5] <> "x" And _ ;north
			Not _IsInAnyList($obj[0]) Then ;If not in closed list or openlist and is not a barrier
		If $heuristic = 1 Then
			$h = _MD($obj, $goal)
		Else
			$h = _ED($obj, $goal)
		EndIf
		$obj[1] = $node[0] ;set nodes parent to last node
		$obj[3] = $node[3] + $obj[3] ;set g score (current node's G score + adjacent node's G score)
		$obj[2] = $obj[3] + $h ;set f = g + h score
		$data[$x][$y - 1] = $obj
		$north = 1
		$openList_Str &= $obj[0] & "_"
		_Insert_PQ($openlist, $obj)
	EndIf
	$obj = $data[$x][$y + 1]
	If $obj[5] <> "x" And _ ;south
			Not _IsInAnyList($obj[0]) Then
		If $heuristic = 1 Then
			$h = _MD($obj, $goal)
		Else
			$h = _ED($obj, $goal)
		EndIf
		$obj[1] = $node[0] ;set nodes parent to last node
		$obj[3] = $node[3] + $obj[3]  ;set g score (current node's G score + adjacent node's G score)
		$obj[2] = $obj[3] + $h ;set f = g + h score
		$data[$x][$y + 1] = $obj
		$south = 1
		$openList_Str &= $obj[0] & "_"
		_Insert_PQ($openlist, $obj)
	EndIf
	$obj = $data[$x + 1][$y]
	If $obj[5] <> "x" And _ ;east
			Not _IsInAnyList($obj[0]) Then
		If $heuristic = 1 Then
			$h = _MD($obj, $goal)
		Else
			$h = _ED($obj, $goal)
		EndIf
		$obj[1] = $node[0] ;set nodes parent to last node
		$obj[3] = $node[3] + $obj[3]  ;set g score (current node's G score + adjacent node's G score)
		$obj[2] = $obj[3] + $h ;set f = g + h score
		$data[$x + 1][$y] = $obj
		$east = 1
		$openList_Str &= $obj[0] & "_"
		_Insert_PQ($openlist, $obj)
	EndIf
	$obj = $data[$x - 1][$y]
	If $obj[5] <> "x" And _ ;west
			Not _IsInAnyList($obj[0]) Then
		If $heuristic = 1 Then
			$h = _MD($obj, $goal)
		Else
			$h = _ED($obj, $goal)
		EndIf
		$obj[1] = $node[0] ;set nodes parent to last node
		$obj[3] = $node[3] + $obj[3]  ;set g score (current node's G score + adjacent node's G score)
		$obj[2] = $obj[3] + $h ;set f = g + h score
		$data[$x - 1][$y] = $obj
		$west = 1
		$openList_Str &= $obj[0] & "_"
		_Insert_PQ($openlist, $obj)
	EndIf
	;diagonals moves
	If $allow_diagonals_Boolean Then ;if GUI checkbox is checked, then check other 4 directions
		If $north + $east = 2 Then ;Not allowed to cut around corners, not realistic
			$obj = $data[$x + 1][$y - 1]
			If $obj[5] <> "x" And _ ;northeast
					Not _IsInAnyList($obj[0]) Then
				If $heuristic = 1 Then
					$h = _MD($obj, $goal)
				Else
					$h = _ED($obj, $goal)
				EndIf
				$obj[1] = $node[0] ;set nodes parent to last node
				$obj[3] = $node[3] + (Sqrt(2) * $obj[3])  ;set g score (current node's G score + adjacent node's G score* Sqrt(2))
				$obj[2] = $obj[3] + $h ;set f = g + h score
				$data[$x + 1][$y - 1] = $obj
				$openList_Str &= $obj[0] & "_"
				_Insert_PQ($openlist, $obj)
			EndIf
		EndIf
		If $north + $west = 2 Then
			$obj = $data[$x - 1][$y - 1]
			If $obj[5] <> "x" And _ ;north west
					Not _IsInAnyList($obj[0]) Then
				If $heuristic = 1 Then
					$h = _MD($obj, $goal)
				Else
					$h = _ED($obj, $goal)
				EndIf
				$obj[1] = $node[0] ;set nodes parent to last node
				$obj[3] = $node[3] + (Sqrt(2) * $obj[3])  ;set g score (current node's G score + adjacent node's G score* Sqrt(2))
				$obj[2] = $obj[3] + $h  ;set f = g + h score
				$data[$x - 1][$y - 1] = $obj
				$openList_Str &= $obj[0] & "_"
				_Insert_PQ($openlist, $obj)
			EndIf
		EndIf
		If $south + $east = 2 Then
			$obj = $data[$x + 1][$y + 1]
			If $obj[5] <> "x" And _ ;southeast
					Not _IsInAnyList($obj[0]) Then
				If $heuristic = 1 Then
					$h = _MD($obj, $goal)
				Else
					$h = _ED($obj, $goal)
				EndIf
				$obj[1] = $node[0] ;set nodes parent to last node
				$obj[3] = $node[3] + (Sqrt(2) * $obj[3])  ;set g score (current node's G score + adjacent node's G score)
				$obj[2] = $obj[3] + $h  ;set f = g + h score
				$data[$x + 1][$y + 1] = $obj
				$openList_Str &= $obj[0] & "_"
				_Insert_PQ($openlist, $obj)
			EndIf
		EndIf
		If $south + $west = 2 Then
			$obj = $data[$x - 1][$y + 1]
			If $obj[5] <> "x" And _ ;southwest
					Not _IsInAnyList($obj[0]) Then
				If $heuristic = 1 Then
					$h = _MD($obj, $goal)
				Else
					$h = _ED($obj, $goal)
				EndIf
				$obj[1] = $node[0] ;set nodes parent to last node
				$obj[3] = $node[3] + (Sqrt(2) * $obj[3])  ;set g score (current node's G score + adjacent node's G score)
				$obj[2] = $obj[3] + $h  ;set f = g + h score
				$data[$x - 1][$y + 1] = $obj
				$openList_Str &= $obj[0] & "_"
				_Insert_PQ($openlist, $obj)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_AddAdjacents_Openlist
;=============================================================================
; Returns true if node is in closed list
; Search the list backwards, its faster
;=============================================================================
Func _IsInClosedList(ByRef $node)
	If StringRegExp($closedList_Str, "_" & $node & "_") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_IsInClosedList
;=============================================================================
; Returns true if node is in open list
; Regular expressions are used rather than searching an array list for speed.
;=============================================================================
Func _IsInAnyList(ByRef $node)
	If StringRegExp($openList_Str, "_" & $node & "_") Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_IsInAnyList
;=============================================================================
; Inserts object into openlist and preserves ascending order
; This way will result in a priority queue with the lowest F cost at
; position 1 in the openlist array.
;=============================================================================
Func _Insert_PQ(ByRef $openlist, $node)
	Local $obj
	For $i = 1 To UBound($openlist) - 1
		Local $obj = $openlist[$i]
		If $node[2] < $obj[2] Then
			_ArrayInsert($openlist, $i, $node)
			Return
		EndIf
	Next
	_Add_List($openlist, $node)
EndFunc   ;==>_Insert_PQ
;=============================================================================
; Adds nodes the a list
;=============================================================================
Func _Add_List(ByRef $list, $node)
	ReDim $list[UBound($list) + 1]
	$list[UBound($list) - 1] = $node
EndFunc   ;==>_Add_List
;============================================================================
; End of Algorithm
;============================================================================