var/datum/antagonist/xenos/xenomorphs

/datum/antagonist/xenos
	id = MODE_XENOMORPH
	role_text = "Xenomorph"
	role_text_plural = "Xenomorphs"
	mob_path = /mob/living/carbon/alien/larva
	special_path = /datum/species/xenos
	bantype = "Xenomorph"
	flags = ANTAG_OVERRIDE_MOB | ANTAG_RANDSPAWN | ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE
	welcome_text = "Hiss! You are a larval alien. Hide and bide your time until you are ready to evolve."
	antaghud_indicator = "hudalien"

	faction_role_text = "Xenomorph Thrall"
	faction_descriptor = "Hive"
	faction_welcome = "Your will is ripped away as your humanity merges with the xenomorph overmind. You are now \
		a thrall to the queen and her brood. Obey their instructions without question. Serve the hive."
	faction = "xenomorph"

	hard_cap = 5
	hard_cap_round = 8
	initial_spawn_req = 1
	initial_spawn_target = 3

	spawn_announcement = "Unidentified lifesigns detected coming aboard the station. Secure any exterior access, including ducting and ventilation."
	spawn_announcement_title = "Lifesign Alert"
	spawn_announcement_sound = 'sound/AI/aliens.ogg'
	spawn_announcement_delay = 5000

	var/datum/antagonist/working_joe/working_joes

/datum/antagonist/xenos/New(var/no_reference)
	..()
	if(!no_reference)
		xenomorphs = src

	working_joes = new

/datum/antagonist/xenos/attempt_auto_spawn()
	..()
	if (working_joes)
		working_joes.attempt_auto_spawn()

/*

/datum/antagonist/xenos/proc/create_one_default_from_ghost(location)

	var/datum/mind/player = attempt_random_spawn_one()

	if (player == 0 || player == null)//player SHOULD be a mind
		world << "NO PLAYER BAD"
		return FALSE

	world << "SUCCESS!"

	world << player.type

	player.current.loc = location

	world << player.current.type

	return TRUE*/

/datum/antagonist/xenos/attempt_random_spawn()
	if(config.aliens_allowed) return ..()

/datum/antagonist/xenos/attempt_random_spawn_one()
	if(config.aliens_allowed) return ..()

/datum/antagonist/xenos/antags_are_dead()

	var/to_return = TRUE


	for (var/datum/mind/antag in current_antagonists)
		if(!antag.current.client)
			continue
		if (!isalien(antag.current))
			continue
		if(antag.current.stat==2)
			continue

		to_return = FALSE

	for (var/mob/living/carbon/c in mob_list)
		if (isalienfather(c))//also checks if they're carbon
			to_return = FALSE
			break

	return to_return

/datum/antagonist/xenos/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents

/datum/antagonist/xenos/create_objectives(var/datum/mind/player)
	if(!..())
		return
	player.objectives += new /datum/objective/survive()
	player.objectives += new /datum/objective/escape()

/datum/antagonist/xenos/place_mob(var/mob/living/player)
	player.forceMove(get_turf(pick(get_vents())))
