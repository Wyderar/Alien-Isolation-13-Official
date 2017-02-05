/mob/living/carbon/human/update_sight()
	..()
	if(stat == DEAD)
		return
	if(XRAY in mutations)
		sight |= SEE_TURFS|SEE_MOBS|SEE_OBJS
