
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)
	if(!damage || (blocked >= 2))	return FALSE
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage/(blocked+1))
		if(BURN)
			if(COLD_RESISTANCE in mutations)	damage = 0
			adjustFireLoss(damage/(blocked+1))
		if(TOX)
			adjustToxLoss(damage/(blocked+1))
		if(OXY)
			adjustOxyLoss(damage/(blocked+1))
		if(CLONE)
			adjustCloneLoss(damage/(blocked+1))
		if(HALLOSS)
			adjustHalLoss(damage/(blocked+1))
	flash_weak_pain()
	updatehealth()
	return TRUE


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0)
	if(blocked >= 2)	return FALSE
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, HALLOSS, def_zone, blocked)
	return TRUE

