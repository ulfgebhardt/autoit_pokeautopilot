Func do_combat_ball()
	do_log("Combat: Throw Ball")
	do_action()
	do_log("Combat: Throw Ball done")
EndFunc

Func do_combat_bait()
	do_log("Combat: Throw Bait")
	do_right()
	do_action()	
	do_log("Combat: Throw Bait done")
EndFunc

Func do_combat_rock()
	do_log("Combat: Throw Rock")
	do_down()
	do_action()
	do_log("Combat: Throw Rock done")
EndFunc

Func do_combat_run()
	do_log("Combat: Run")
	do_right()	
	do_down()
	do_action()
	do_log("Combat: Run done")
EndFunc