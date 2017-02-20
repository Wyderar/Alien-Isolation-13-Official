/mob/living/carbon/alien

	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = PASSTABLE
	health = 100
	maxHealth = 100
	mob_size = 4

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 1300
	var/time_of_birth
	var/language
	var/death_msg = "lets out a waning guttural screech, green blood bubbling from its maw."

	var/did_evolve = FALSE

	var/got_evolution_message = FALSE

/mob/living/carbon/alien/New()

	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	name = "[initial(name)] ([rand(1, 1000)])"
	real_name = name
	regenerate_icons()

	max_grown = pick(1000,1100,1200,1300,1400,1500)

	if(language)
		add_language(language)

	gender = NEUTER

	alien_list += src

	..()

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/alien/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return FALSE

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return //Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/carbon/alien/cannot_use_vents()
	return FALSE