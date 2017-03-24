/datum/game_mode/xeno/raid
	name = "Xenomorph Raid"
	round_description = "The xenomorphs have won, and took over the station. An elite force of Ironhammer Operatives is coming to save the day."
	extended_round_description = ""
	config_tag = "xeno_raid"
	required_players = 1
	required_enemies = 1
	end_on_antag_death = 1
	shuttle_delay = 6
	antag_scaling_coeff = 2
	antag_tags = list(MODE_XENOMORPH_BLOATED, MODE_IH_RAIDER)
	auto_recall_shuttle = 1
	require_all_templates = 1

	New()
		..()
		if (!config.debug_mode_on)
			required_players = 3

	pre_setup()
		..()

	post_setup()
		..()

		generate_weeds()
		destroy_some_lights(list(/area/security, /area/medical, /area/engineering))


		spawn (20)

			initial_alien_message("<font size = 3>You have taken over the station. You know that the humans are coming back to reclaim it. You must defend your new hive to the death!</font>")

			for (var/datum/mind/mind in ih_raider.current_antagonists)
				var/mob/living/carbon/human/H = mind
				if (istype(H))
					src << "<b><span style = \"color:red\">You have been sent to save the CEV Eris from an xenomorphic infestation. Rescue as many survivors as possible, and eliminate the aliens at all costs. You have a jetpack, and the station is northwest of you.</span></b>"



	send_intercept()
		return


/datum/game_mode/xeno/raid/declare_completion()

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
				ghosts++

	var/text = "<font size = 3>"
	if(surviving_total > 0)
		text += "<br>There [surviving_total>1 ? "were <b>[surviving_total] survivors</b>" : "was <b>one survivor</b>"]"
		text += " (<b>[escaped_total>0 ? escaped_total : "none"] [emergency_shuttle.evac ? "escaped" : "transferred"]</b>) and <b>[ghosts] ghosts</b>.<br>"
	else
		text += "There were <b>no survivors</b> (<b>[ghosts] ghosts</b>)."
	text += "</font>"
	world << text

	var/xenos = 0

	for (var/datum/mind/mind in xenomorphs.current_antagonists)
		++xenos

	if (xenos && xenos < 5)
		world << "<span class = 'danger'>Xeno Minor Victory! (4 or less Xenomorphs survived)"
	else if (xenos && xenos >= 5)
		world << "<span class = 'danger'>Xeno Major Victory! (5 or more Xenomorphs survived)"
	else
		world << "<span class = 'danger'>Ironhammer Major Victory! The Hive has been annihilated!"