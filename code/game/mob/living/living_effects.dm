/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(!effect || (blocked >= 2))	return FALSE
	switch(effecttype)
		if(STUN)
			Stun(effect/(blocked+1))
		if(WEAKEN)
			Weaken(effect/(blocked+1))
		if(PARALYZE)
			Paralyse(effect/(blocked+1))
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(IRRADIATE)
			var/rad_protection = check_protection ? getarmor(null, "rad")/100 : 0
			radiation += max((1-rad_protection)*effect/(blocked+1),0)//Rads auto check armor
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering,(effect/(blocked+1)))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect/(blocked+1)))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect/(blocked+1)))
	updatehealth()
	return TRUE


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0)

	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		var/datum/species/s = H.species
		stun *= s.stun_mod
		weaken *= s.stun_mod
		paralyze *= s.stun_mod
		stutter *= s.stun_mod
		agony *= s.agony_mod

	if(blocked >= 2)	return FALSE
	if(stun)		apply_effect(stun, STUN, blocked)
	if(weaken)		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy, DROWSY, blocked)
	if(agony)		apply_effect(agony, AGONY, blocked)
	return TRUE
