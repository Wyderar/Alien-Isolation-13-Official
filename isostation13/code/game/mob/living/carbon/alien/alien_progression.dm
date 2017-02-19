/mob/living/carbon/alien/verb/evolve()

	set name = "Moult"
	set desc = "Moult your skin and become an adult."
	set category = "Abilities"

	do_evolve()


/mob/living/carbon/alien/proc/force_evolve()
	amount_grown = max_grown
	do_evolve()

/mob/living/carbon/alien/proc/do_evolve()

	if(stat != CONSCIOUS)
		return

	if(!adult_form)
		verbs -= /mob/living/carbon/alien/verb/evolve
		return

	if(handcuffed || legcuffed)
		src << "<span class='warning'>You cannot evolve when you are cuffed.</span>"
		return

	if(amount_grown < max_grown)
		src << "<span class='warning'>You are not fully grown.</span>"
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	did_evolve = TRUE

	var/mob/living/carbon/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)

	spawn (3)//this might fix the "larva ded" message, as it may or may not give time for the adult ayy to be created

		show_evolution_blurb()
		// TODO: drop a moulted skin. Ew.

		if(mind)
			mind.transfer_to(adult)
		else
			adult.key = src.key

		for (var/obj/item/W in src.contents)
			src.drop_from_inventory(W)

		for(var/datum/language/L in languages)
			adult.add_language(L.name)

		qdel(src)

/mob/living/carbon/alien/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	else
		if (!got_evolution_message)
			got_evolution_message = TRUE
			src << "<span class = 'alium'>You feel ready to evolve.</span>"
	return

/mob/living/carbon/alien/proc/confirm_evolution()
	return

/mob/living/carbon/alien/proc/show_evolution_blurb()
	return