var/datum/antagonist/ih_raider/ih_raider

/datum/antagonist/ih_raider
	id = MODE_IH_RAIDER
	role_text = "Ironhammer Special Operative"
	role_text_plural = "Ironhammer Special Operatives"
	welcome_text = "You are here to liberate the CEV Eris from an infestation of xenomorphic lifeforms."
	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_HAS_LEADER | ANTAG_RANDOM_EXCEPTED
	default_access = list(access_cent_general, access_cent_specops, access_cent_living, access_cent_storage)
	antaghud_indicator = "huddeathsquad"

	hard_cap = 20
	hard_cap_round = 20
	initial_spawn_req = 1
	initial_spawn_target = 20

	faction = "ih_operative"

	var/deployed = 0

/datum/antagonist/ih_raider/New(var/no_reference)
	..()
	if(!no_reference)
		ih_raider = src

/datum/antagonist/ih_raider/attempt_spawn()
	if(..())
		deployed = 1


	for (var/datum/job/j in world)
		if (!istype(j, /datum/job/ih_raider))
			qdel(j)


/datum/antagonist/ih_raider/place_mob(var/mob/living/player)
	for (var/obj/effect/landmark/landmark in world)
		if (landmark.name == "ih_raider_spawn")
			player.forceMove(get_turf(landmark))

/datum/antagonist/ih_raider/equip(var/mob/living/carbon/human/player)
	if(!..())
		return


	player.equip_to_slot_or_del(new /obj/item/clothing/under/color/green(player), slot_w_uniform)
	player.equip_to_slot_or_del(new /obj/item/clothing/shoes/swat(player), slot_shoes)
	player.equip_to_slot_or_del(new /obj/item/clothing/gloves/thick/swat(player), slot_gloves)
	player.equip_to_slot_or_del(new /obj/item/clothing/glasses/thermal(player), slot_glasses)
	player.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/swat(player), slot_wear_mask)
	player.equip_to_slot_or_del(new /obj/item/device/flashlight/seclite(player), slot_belt)
	player.equip_to_slot_or_del(new /obj/item/weapon/melee/energy/sword(player), slot_s_store)
	player.equip_to_slot_or_del(new /obj/item/weapon/material/knife/butch(player), slot_s_store)


	player.implant_loyalty(player)

	var/obj/item/weapon/card/id/id = create_id("Ironhammer Special Operative", player)
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
