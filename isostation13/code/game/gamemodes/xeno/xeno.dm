/datum/game_mode/xeno
	name = "Xenomorph"
	round_description = "There is a xenomorphic alien loose on the station. Stop it at all costs!"
	extended_round_description = "There is a xenomorphic alien loose on the station. Stop it at all costs!"
	config_tag = "xeno"
	required_players = 1
	required_enemies = 1
	end_on_antag_death = 1
//	antag_scaling_coeff = 10
	antag_tags = list(MODE_XENOMORPH)
	antag_templates = list(MODE_WORKING_JOE)