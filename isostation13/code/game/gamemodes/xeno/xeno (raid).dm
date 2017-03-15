/datum/game_mode/xeno/raid
	name = "Xenomorph Raid"
	round_description = "The xenomorphs have won, and took over the station. An elite force of Ironhammer Operatives is coming to save the day."
	extended_round_description = "The xenomorphs have won, and took over the station. An elite force of Ironhammer Operatives is coming to save the day."
	config_tag = "xeno_raid"
	required_players = 1
	required_enemies = 1
	end_on_antag_death = 1
	shuttle_delay = 6
	antag_scaling_coeff = 2
	antag_tags = list(MODE_XENOMORPH_BLOATED, MODE_IH_RAIDER)
	auto_recall_shuttle = 1

	New()
		..()
		if (!config.debug_mode_on)
			required_players = 3


	post_setup()
		..()
		for (var/datum/mind/mind in xenomorphs.current_antagonists)
			var/mob/living/carbon/alien/larva/larva = mind.current
			if (istype(larva))
				larva.force_evolve(list("ELITE", "RAIDMODE"))

		alien_message("<font size = 3>You have taken over the station. You know that the humans are coming back to reclaim it. You must defend your new hive to the death!</font>")

		for (var/datum/mind/mind in ih_raider.current_antagonists)
			var/mob/living/carbon/human/H = mind
			if (istype(H))
				src << "<b><span style = \"color:red\">You have been sent to save the CEV Eris from an xenomorphic infestation. Rescue as many survivors as possible, and eliminate the aliens at all costs. You have a jetpack, and the station is northwest of you.</span></b>"

	send_intercept()
		return