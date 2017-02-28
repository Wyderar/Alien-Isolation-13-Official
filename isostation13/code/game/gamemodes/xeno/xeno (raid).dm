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
	antag_tags = list(MODE_XENOMORPH, MODE_IH_RAIDER)

	New()
		..()
		if (!config.debug_mode_on)
			required_players = 2
		shuttle_delay = pick(99,100) //no shuttles
