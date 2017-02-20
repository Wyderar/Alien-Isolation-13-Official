/mob/living/carbon/alien/larva/regenerate_icons()
	overlays = list()
	update_icons()

/mob/living/carbon/alien/larva/update_icons()

	//no real better place to put this
	if (get_prefix())
		real_name = "[get_prefix()] Larva"
	else
		real_name = "Alien Larva"

	name = real_name

	var/state = 0

	if(amount_grown >= max_grown*MAX_GROWN_STATE_1_MULT && amount_grown < max_grown*MAX_GROWN_STATE_2_MULT)
		state = 1
	else if (amount_grown >= max_grown*MAX_GROWN_STATE_2_MULT)
		state = 2

	if(stat == DEAD)
		icon_state = "[initial(icon_state)][state]_dead"
	else if (stunned)
		icon_state = "[initial(icon_state)][state]_stun"
	else if(lying || resting)
		icon_state = "[initial(icon_state)][state]_sleep"
	else
		icon_state = "[initial(icon_state)][state]"
	..()
