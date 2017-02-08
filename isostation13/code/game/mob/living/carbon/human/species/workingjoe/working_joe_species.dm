//Stand-in until this is made more lore-friendly.
/datum/species/working_joe
	name = "Xenomorph Base" //to distinguish from new /datum/species/xenos/new_xeno
	name_plural = "Xenomorphs"

	default_language = "Xenomorph"
	language = "Hivemind"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/strong)


//	hud_type = /datum/hud_data/working_joe //normal hud
	rarity_value = 3

	has_fine_manipulation = TRUE
	can_pick_up_stuff = TRUE
	siemens_coefficient = 0
	gluttonous = GLUT_ANYTHING

	eyes = "blank_eyes"

	brute_mod = 0.2 // Hardened carapace.
	burn_mod = 0.33 //worse against fire
	stun_mod = 0.05 //worst against stuns
	agony_mod = 0.05//very good against paindmg

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	flags =  NO_BREATHE | NO_SCAN | NO_PAIN | NO_SLIP | NO_POISON | NO_MINOR_CUT
	spawn_flags = IS_RESTRICTED

//	reagent_tag = IS_XENOS

	blood_color = "#FFFFFF"
	flesh_color = "#FFFFFF"

	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."

//	speech_sounds = list('sound/voice/hiss1.ogg','sound/voice/hiss2.ogg','sound/voice/hiss3.ogg','sound/voice/hiss4.ogg')
	speech_chance = 100

	breath_type = null
	poison_type = null

	vision_flags = SEE_SELF|SEE_MOBS

	has_organ = list()

	bump_flag = ALIEN
	swap_flags = ~HEAVY
	push_flags = (~HEAVY) ^ ROBOT