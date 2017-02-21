/*/mob/living/carbon/alien/larva/confirm_evolution()

	src << "\blue <b>You are growing into a beautiful alien! It is time to choose a caste.</b>"
	src << "\blue There are three to choose from:"
	src << "<B>Hunters</B> \blue are strong and agile, able to hunt away from the hive and rapidly move through ventilation shafts. Hunters generate plasma slowly and have low reserves."
	src << "<B>Sentinels</B> \blue are tasked with protecting the hive and are deadly up close and at a range. They are not as physically imposing nor fast as the hunters."
	src << "<B>Drones</B> \blue are the working class, offering the largest plasma storage and generation. They are the only caste which may evolve again, turning into the dreaded alien queen."
	var/alien_caste = alert(src, "Please choose which alien caste you shall belong to.",,"Hunter","Sentinel","Drone")
	return alien_caste ? "Xenomorph [alien_caste]" : null*/

/mob/living/carbon/alien/larva/confirm_evolution()
	return "Xenomorph"

/mob/living/carbon/alien/larva/show_evolution_blurb()
	return

/mob/living/carbon/alien/larva/proc/get_prefix()
	if (amount_grown < (MAX_GROWN_STATE_1_MULT * max_grown))
		return "Bloody"
	return null

/mob/living/carbon/alien/larva/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	else
		if (!got_evolution_message)
			got_evolution_message = TRUE
			src << "<span class = 'alium'>You feel ready to evolve.</span>"
	return
