var/mob/living/carbon/human/H = null

/mob/observer/movement_delay()

	if (!H)
		H = new(locate(1,1,1))
		H.icon = null
		H.layer = -1
		H.set_species("xenomorph")

	return H.movement_delay()
