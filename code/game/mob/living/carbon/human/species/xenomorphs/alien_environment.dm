
/datum/species/xenos/handle_environment_special(var/mob/living/carbon/human/H)

	var/turf/T = get_turf(H)
	if(!T) return
	var/datum/gas_mixture/environment = T.return_air()
	if(!environment) return

	//var/obj/effect/plant/plant = locate() in T
	var/obj/structure/alien/weed = locate() in T
//	if((environment.gas["plasma"] > 0 && !regenerate(H) || weed/* (plant && plant.seed && plant.seed.name == "xenomorph")*/) && !regenerate(H))
	if (weed && !regenerate(H))//short circuiting - if there's no weeds, no healing
		var/obj/item/organ/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
		P.stored_plasma += weeds_plasma_rate/2
		P.stored_plasma = min(max(P.stored_plasma,0),P.max_plasma)
	else
		var/obj/item/organ/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
		P.stored_plasma += weeds_plasma_rate/10
		P.stored_plasma = min(max(P.stored_plasma,0),P.max_plasma)
	..()

/datum/species/xenos/proc/regenerate(var/mob/living/carbon/human/H)
	var/heal_rate = weeds_heal_rate
	var/mend_prob = 10

	if (!H.resting)
		heal_rate = weeds_heal_rate / 3
		mend_prob = 1

	//first heal damages
	if (H.getBruteLoss() || H.getFireLoss() || H.getOxyLoss() || H.getToxLoss())
		H.adjustBruteLoss(-heal_rate)
		H.adjustFireLoss(-heal_rate)
		H.adjustOxyLoss(-heal_rate)
		H.adjustToxLoss(-heal_rate)
		if (prob(5))
			H << "<span class='alium'>You feel a soothing sensation come over you...</span>"
		return TRUE

	//next internal organs
	for(var/obj/item/organ/I in H.internal_organs)
		if(I.damage > 0)
			I.damage = max(I.damage - heal_rate, 0)
			if (prob(5))
				H << "<span class='alium'>You feel a soothing sensation within your [I.parent_organ]...</span>"
			return TRUE

	//next mend broken bones, approx 10 ticks each
	for(var/obj/item/organ/external/E in H.bad_external_organs)
		if (E.status & ORGAN_BROKEN)
			if (prob(mend_prob))
				if (E.mend_fracture())
					H << "<span class='alium'>You feel something mend itself inside your [E.name].</span>"
			return TRUE

	return FALSE