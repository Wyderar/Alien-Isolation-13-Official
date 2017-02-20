/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25


/mob/living/carbon/alien/larva/New()
	..()
	add_language("Xenomorph") //Bonus language.
	internal_organs |= new /obj/item/organ/xenos/hivenode(src)
	create_reagents(100)
	alien_message("[src] has been born at [get_area(src)]!")

/mob/living/carbon/alien/larva/verb/Doorcrawl()
	set name = "Door Crawl"
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot doorcrawl in your current state."
		return

	var/obj/machinery/door/airlock/door = null

	for (var/obj/machinery/door/airlock/al in get_step(src, src.dir))
		if (istype(al))
			door = al
			break

	if (istype(door, /obj/machinery/door/airlock))
		src << "\red You start to squeeze through the door."
		if (do_after(src, rand(15,25), door))
			loc = get_step(src, src.dir)
			src << "\red You squeeze through the door."

