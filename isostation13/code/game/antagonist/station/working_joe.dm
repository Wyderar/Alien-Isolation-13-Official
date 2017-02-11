var/datum/antagonist/working_joe/working_joes

/datum/antagonist/working_joe
	role_text = "Working Joe"
	role_text_plural = "Working Joes"
	welcome_text = "You are a Working Joe, a Seegson Synthetic. Your sole purpose in life is to serve your human masters. Above all else, do not harm any human."
//	id = MODE_WORKING_JOE
	flags = 0//for now

	//no limit to how many people can be working joe.
	hard_cap = 500
	hard_cap_round = 500
	initial_spawn_req = 0
	initial_spawn_target = 500

/datum/antagonist/working_joe/New()
	..()
	working_joes = src


/datum/antagonist/working_joe/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/datum/antagonist/working_joe/build_candidate_list()
	var/list/candidates = ..()

	for (var/datum/mind/mind in candidates)
		if (!mind.current || !(working_joe_whitelist.Find(mind.current.ckey) || working_joe_whitelist.Find(mind.current.key)))
			candidates -= mind

	return candidates

/datum/antagonist/working_joe/finalize_spawn()
	var/list/spawned = ..()
	for (var/datum/mind/mind in spawned)
		if (ishuman(mind.current))
			var/mob/living/carbon/human/H = mind.current
			H.set_species("Working Joe")
	//		H.equip_to_slot(/obj/item/clothing/under/rank/engineer, slot_wear_suit)