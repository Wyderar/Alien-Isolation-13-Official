var/datum/antagonist/ih_raider/ih_raider

/datum/antagonist/ih_raider
	id = MODE_DEATHSQUAD
	role_text = "Ironhammer Special Operative"
	role_text_plural = "Ironhammer Special Operatives"
	welcome_text = "You are here to liberate the CEV Eris from an infestation of xenomorphic lifeforms."
	landmark_id = "Commando"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_NUKE | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	default_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	antaghud_indicator = "huddeathsquad"

	hard_cap = 4
	hard_cap_round = 8
	initial_spawn_req = 4
	initial_spawn_target = 6

	faction = "ih_operative"

	var/deployed = 0

/datum/antagonist/ih_raider/New(var/no_reference)
	..()
	if(!no_reference)
		ih_raider = src

/datum/antagonist/ih_raider/attempt_spawn()
	if(..())
		deployed = 1

/datum/antagonist/ih_raider/equip(var/mob/living/carbon/human/player)
	if(!..())
		return

	if (player.mind == leader)
		//player.equip_to_slot_or_del(new /obj/item/clothing/under/rank/centcom_officer(player), slot_w_uniform)
	else
		player.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(player), slot_w_uniform)

	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), slot_wear_mask)
	if (player.mind == leader)
		player.equip_to_slot_or_del(new /obj/item/weapon/pinpointer(player), slot_l_store)
		player.equip_to_slot_or_del(new /obj/item/weapon/disk/nuclear(player), slot_r_store)
	else
		player.equip_to_slot_or_del(new /obj/item/weapon/plastique(player), slot_l_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/revolver/mateba(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/weapon/gun/energy/pulse_rifle(player), slot_r_hand)
	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_s_store)
	player.implant_loyalty(player)

	var/obj/item/weapon/card/id/id = create_id("Asset Protection", player)
	if(id)
		id.access |= get_all_station_access()
		id.icon_state = "centcom"
	create_radio(DTH_FREQ, player)

/datum/antagonist/ih_raider/update_antag_mob(var/datum/mind/player)

	..()

	var/syndicate_commando_rank
	if(leader && player == leader)
		syndicate_commando_rank = pick("Corporal", "Sergeant", "Staff Sergeant", "Sergeant 1st Class", "Master Sergeant", "Sergeant Major")
	else
		syndicate_commando_rank = pick("Lieutenant", "Captain", "Major")

	var/syndicate_commando_name = pick(last_names)

	var/datum/preferences/A = new() //Randomize appearance for the commando.
	A.randomize_appearance_for(player.current)

	player.name = "[syndicate_commando_rank] [syndicate_commando_name]"
	player.current.name = player.name
	player.current.real_name = player.current.name

	var/mob/living/carbon/human/H = player.current
	if(istype(H))
		H.gender = pick(MALE, FEMALE)
		H.age = rand(25,45)
		H.dna.ready_dna(H)

	return

/datum/antagonist/ih_raider/create_antagonist()
	if(..() && !deployed)
		deployed = 1
