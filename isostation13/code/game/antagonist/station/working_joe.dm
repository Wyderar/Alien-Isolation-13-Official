var/datum/antagonist/working_joe/working_joes
var/list/working_joe_occupied_vents = list()

/datum/antagonist/working_joe
	role_text = "Working Joe"
	role_text_plural = "Working Joes"
	welcome_text = "You are a Working Joe, a Seegson Synthetic. Your sole purpose in life is to serve your human masters. Above all else, do not harm any human."
	id = MODE_WORKING_JOE
	flags = ANTAG_OVERRIDE_MOB | ANTAG_RANDSPAWN | ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE

	//no limit to how many people can be working joe.
	hard_cap = 500
	hard_cap_round = 500
	initial_spawn_req = 1
	initial_spawn_target = 500

/datum/antagonist/working_joe/New()
	..()
	working_joes = src


/datum/antagonist/working_joe/attempt_spawn(var/spawn_target = null)
	..()
	if (config.debug_mode_on)
		world << "Spawning WORKING JOES for the gamemode."


/datum/antagonist/working_joe/build_candidate_list()
	var/list/candidates = ..()

	for (var/datum/mind/mind in candidates)
		if (!mind.current || !(working_joe_whitelist.Find(mind.current.ckey) || working_joe_whitelist.Find(mind.current.key)))
			candidates -= mind

	if (config.debug_mode_on)
		world << "Built candidates list for working joe antag, now returning."
		world << "First person in the list is [candidates[1]]"

	return candidates

/datum/antagonist/working_joe/finalize_spawn()
	if (config.debug_mode_on)
		world << "Finalizing spawn for working joe antag."
	var/list/spawned = ..()
	for (var/datum/mind/mind in spawned)
		if (ishuman(mind.current))
			var/mob/living/carbon/human/H = mind.current
			H.set_species("Working Joe")
	//		H.equip_to_slot(/obj/item/clothing/under/rank/engineer, slot_wear_suit)

/datum/antagonist/working_joe/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents

/datum/antagonist/working_joe/antags_are_dead()

	return TRUE

/datum/antagonist/working_joe/place_mob(var/mob/living/player)

	var/vent = pick(get_vents())
	while (vent in xenomorph_occupied_vents)
		vent = pick(get_vents())

	working_joe_occupied_vents += vent
	player.forceMove(get_turf(vent))


/datum/antagonist/working_joe/create_objectives(var/datum/mind/joe)
	if(!..())
		return FALSE

	var/datum/objective/working_joe/ph = new/datum/objective/working_joe/protect_humans
	ph.owner = joe
	joe.objectives += ph

	return TRUE