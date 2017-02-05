/mob/living/carbon/alien/death(gibbed)
	if(!gibbed && dead_icon)
		icon_state = dead_icon
	if (!did_evolve)
		alien_message("[src] has been slain at [get_area(src)]!") //disabled until fixed
	alien_list -= src
	return ..(gibbed,death_msg)
