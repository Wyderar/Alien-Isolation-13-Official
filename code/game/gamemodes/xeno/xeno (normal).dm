/datum/game_mode/xeno/normal
	name = "Xenomorph"
	round_description = "Something is not quite right on the CEV Eris..."
	extended_round_description = ""
	config_tag = "xeno"
	required_players = 2
	required_enemies = 1
	end_on_antag_death = 1
	shuttle_delay = 6
//	antag_scaling_coeff = 10
//	antag_tags = list(MODE_XENOMORPH)
//	antag_templates = list(MODE_WORKING_JOE)
	antag_tags = list(MODE_XENOMORPH, MODE_WORKING_JOE)
	equalize_antag_spawntargets = TRUE

	New()
		..()

		if (config.debug_mode_on)
			required_players = 1
			required_enemies = 0

		shuttle_delay = pick(6,7)


/datum/game_mode/xeno/declare_completion()

	var/is_antag_mode = (antag_templates && antag_templates.len)
	check_victory()
	if(is_antag_mode)
		sleep(10)
		for(var/datum/antagonist/antag in antag_templates)
			sleep(10)
			antag.check_victory()
			antag.print_player_summary()
		sleep(10)
		print_ownerless_uplinks()

/*
	var/surviving_total = 0
	var/ghosts = 0

	var/escaped_total = 0


	var/list/area/escape_locations = list(/area/shuttle/escape/centcom, /area/shuttle/escape_pod1/centcom, /area/shuttle/escape_pod2/centcom, /area/shuttle/escape_pod3/centcom, /area/shuttle/escape_pod5/centcom)

	for(var/mob/M in player_list)
		if(M.client)

			if(M.stat != DEAD)
				surviving_total++
				if(M.loc && M.loc.loc && M.loc.loc.type in escape_locations)
					escaped_total++



			if(isghost(M))
				ghosts++*/
/*
	var/text = "<font size = 3>"
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]</b>) and <b>[ghosts] ghosts</b>.<br>"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."
	text += "</font>"*/
//	world << text

	var/xenos = 0

	for (var/datum/mind/mind in xenomorphs.current_antagonists)
		++xenos

	if (xenos && xenos < 5)
		world << "<font size = 3><span class = 'danger'>Xeno Minor Victory! (4 or less Xenomorphs survived)</font>"
	else if (xenos && xenos >= 5)
		world << "<font size = 3><span class = 'danger'>Xeno Major Victory! (5 or more Xenomorphs survived)</font>"
	else if (xenos == 0)
		world << "<font size = 3><span class = 'danger'>Station Major Victory! The Hive has been annihilated!</font>"
	else
		world << "<font size = 3><span class = 'danger'>Station Minor Victory! The Hive has been weakened, but not destroyed!</font>"