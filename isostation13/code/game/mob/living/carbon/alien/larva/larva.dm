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

	verbs += /mob/living/carbon/proc/Sense_Hive

/mob/living/carbon/alien/larva/handle_vision()

	..()

	sight = SEE_MOBS|SEE_TURFS|SEE_OBJS|SEE_SELF
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	if (client)

		client.screen |= global_hud.xeno_vision_thermal
		client.screen |= global_hud.xeno_vision_cover


/mob/living/carbon/alien/larva/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

