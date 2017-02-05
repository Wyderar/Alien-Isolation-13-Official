/mob/living/carbon/proc/make_self_adult_alien()
	var/mob/living/carbon/human/adult_alien = new/mob/living/carbon/human(get_turf(src))
	adult_alien.set_species("Xenomorph")
	if(mind)
		mind.transfer_to(adult_alien)
	else
		adult_alien.key = src.key
	gib()

/mob/living/carbon/proc/make_ghost_adult_alien()
	var/found_no_player = 1
	for (var/mob/m in player_list)
		if (istype(m) && m.mind)
			if (isghost(m))
				var/mob/observer/ghost/g = m
				g.deghost()
			else
				continue
			found_no_player = 0
			m.loc = get_turf(src)
			var/mob/living/carbon/human/adult_alien = new/mob/living/carbon/human(get_turf(src))
			adult_alien.set_species("Xenomorph")
			if (m.mind)
				m.mind.transfer_to(adult_alien)
			else
				adult_alien.key = m.key
			qdel(m)
			break

	if (found_no_player)
		return FALSE

	visible_message("<span style = \"danger\">[src] explodes in a shower of gibs!</span>")


	gib()

	return TRUE

/mob/living/carbon/proc/make_ghost_larva()
	var/found_no_player = 1
	for (var/mob/m in player_list)
		if (istype(m, /mob/living))
			continue
		if (istype(m) && m.mind)
			if (isghost(m))
				var/mob/observer/ghost/g = m
				g.deghost()
			else
				continue

			found_no_player = 0
			m.loc = get_turf(src)
		//	spawn(5)//wait for bursting to finish, might make it faster too //nvm this causes a runtime and ruins alien spawning
			var/mob/living/carbon/alien/larva = new/mob/living/carbon/alien/larva(get_turf(src))
			if (m.mind)
				m.mind.transfer_to(larva)
			else
				larva.key = m.key
			qdel(m)
			break

	if (found_no_player)
		return FALSE

	visible_message("<span style = \"danger\">[src] explodes in a shower of gibs!</span>")


	gib()

	return TRUE
