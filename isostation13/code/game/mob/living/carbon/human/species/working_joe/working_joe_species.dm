/datum/species/working_joe
	name = "Working Joe"
	name_plural = "Working Joes"

	icobase = 'icons/mob/human_races/r_working_joe.dmi'
	deform = 'icons/mob/human_races/r_working_joe.dmi'

	//special icons until we have better parts icons for these guys
	icon_template = 'icons/mob/human_races/r_working_joe_old.dmi'

	forced_stand_icon_state = "base_s"
	forced_rest_icon_state = "base_l"
	forced_dead_icon_state = "base_d"
	uses_no_overlays = 1

	has_organ = list()

	//damage
	virus_immune = TRUE
	blood_volume = 5000//about 9x humans
	brute_mod =     0.3                    // Physical damage multiplier.
	burn_mod =      3                    // Burn damage multiplier.
	oxy_mod =       0                    // Oxyloss modifier
	toxins_mod =    0                    // Toxloss modifier
	radiation_mod = 0                    // Radiation modifier
	flash_mod =     3                    // Stun from blindness modifier.
	stun_mod =      3					 // Stun from guns, etc
	agony_mod =     0					 // Agony damage taken
	//end damage
	language = "Sol Common" //todo?

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/working_joe_punch)
	flags = NO_BREATHE | NO_PAIN | NO_BLOOD | NO_SCAN | NO_POISON | NO_MINOR_CUT
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 0

	breath_type = null
	poison_type = null

	no_harm_intent = TRUE

	blood_color = "#C0C0C0"
	flesh_color = "#C0C0C0"

	death_message = "becomes completely motionless..."

/datum/species/working_joe/proc/corrupted()
	no_harm_intent = FALSE

/datum/species/working_joe/proc/uncorrupted()
	no_harm_intent = TRUE

/datum/species/working_joe/handle_post_spawn(var/mob/living/carbon/human/H)
	H.real_name = "Working Joe ([rand(1, 1000)])"
	H.name = H.real_name
	H.equip_to_slot(new/obj/item/clothing/under/rank/engineer, slot_w_uniform)
	H.equip_to_slot(new/obj/item/weapon/storage/belt/utility/full, slot_belt)
	H.equip_to_slot(new/obj/item/clothing/shoes/workboots, slot_shoes)
	H.equip_to_slot(new/obj/item/device/radio/headset/headset_eng, slot_l_ear)
	H.equip_to_slot(handle_id_card(H), slot_wear_id)
	make_synthetic(H)
	handle_id_card(H)
	..()

/datum/species/working_joe/proc/handle_id_card(var/mob/living/carbon/human/H)

	var/obj/item/weapon/card/id/engie/id = new/obj/item/weapon/card/id/engie()
	id.registered_name = H.name
	id.access = ENGINEER|ATMOSTECH
	id.rank = "Working Joe"
	id.assignment = "Working Joe"

	return id
/*

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already
*/