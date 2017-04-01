/mob/living/proc/handle_vision()
//	client.screen.Remove(global_hud.blurry, global_hud.druggy, global_hud.vimpaired, global_hud.darkMask, global_hud.nvg, global_hud.thermal, global_hud.meson, global_hud.science)
	update_sight()

	if(stat == DEAD)
		return

/*	if(eye_blind)
		blind.alpha = 255
	else
		blind.alpha = 0
		if (disabilities & NEARSIGHTED)
			client.screen += global_hud.vimpaired
		if (eye_blurry)
			client.screen += global_hud.blurry
		if (druggy)
			client.screen += global_hud.druggy*/
	if(machine)
		var/viewflags = machine.check_eye(src)
		if(viewflags < 0)
			reset_view(null, 0)
		else if(viewflags)
			sight |= viewflags
	else if(eyeobj)
		if(eyeobj.owner != src)
			reset_view(null)
	else if(!client.adminobs)
		reset_view(null)

/mob/living/proc/update_sight()
	if(stat == DEAD || eyeobj)
		update_dead_sight()
	else
		sight &= ~(SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = initial(see_in_dark)
		see_invisible = initial(see_invisible)

/mob/living/proc/update_dead_sight()
	sight |= SEE_TURFS
	sight |= SEE_MOBS
	sight |= SEE_OBJS
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_LEVEL_TWO
