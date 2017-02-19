var/datum/antagonist/xenos/xenomorphs
var/list/xenomorph_occupied_vents = list()

/datum/antagonist/xenos
	id = MODE_XENOMORPH
	role_text = "Xenomorph"
	role_text_plural = "Xenomorphs"
	mob_path = /mob/living/carbon/alien/larva
	special_path = /datum/species/xenos
	bantype = "Xenomorph"
	flags = ANTAG_OVERRIDE_MOB | ANTAG_RANDSPAWN | ANTAG_OVERRIDE_JOB | ANTAG_VOTABLE
	welcome_text = "Hiss! You are a larval alien. Hide and bide your time until you are ready to evolve."
	antaghud_indicator = "hudalien"

	faction_role_text = "Xenomorph Thrall"
	faction_descriptor = "Hive"
	faction_welcome = "Your will is ripped away as your humanity merges with the xenomorph overmind. You are now \
		a thrall to the queen and her brood. Obey their instructions without question. Serve the hive."
	faction = "xenomorph"

	hard_cap = 5
	hard_cap_round = 8
	initial_spawn_req = 1
	initial_spawn_target = 3

	spawn_announcement = "Unidentified lifesigns detected coming aboard the station. Secure any exterior access, including ducting and ventilation."
	spawn_announcement_title = "Lifesign Alert"
	spawn_announcement_sound = 'sound/AI/aliens.ogg'
	spawn_announcement_delay = 5000


/datum/antagonist/xenos/New(var/no_reference)
	..()

	if(!no_reference)
		xenomorphs = src

/datum/antagonist/xenos/attempt_spawn(var/spawn_target = null)
	..()
	if (config.debug_mode_on)
		world << "Spawning xenos for the gamemode."

/datum/antagonist/xenos/attempt_auto_spawn()
	..()

/datum/antagonist/xenos/attempt_random_spawn()
	if(config.aliens_allowed) return ..()

/datum/antagonist/xenos/attempt_random_spawn_one()
	if(config.aliens_allowed) return ..()

/datum/antagonist/xenos/antags_are_dead()

	var/to_return = TRUE


	var/alive_humans = config.debug_mode_on ? 1 : 0
	for (var/mob/living/carbon/human/h in player_list)
		if (h.client && !ishumanoidalien(h) && h.stat != DEAD)
			++alive_humans

	if (alive_humans == 0)
		return TRUE


	for (var/datum/mind/antag in current_antagonists)
		if (!antag.current)
			continue
		if(!antag.current.client)
			continue
		if (!isalien(antag.current))
			continue
		if(antag.current.stat==2)
			continue

		to_return = FALSE

	for (var/mob/living/carbon/c in mob_list)
		if (isalienfather(c))//also checks if they're carbon
			to_return = FALSE
			break

	return to_return

/datum/antagonist/xenos/proc/get_vents()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in machines)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent
	return vents

/datum/antagonist/xenos/place_mob(var/mob/living/player)
	var/vent = pick(get_vents())
	while (vent in working_joe_occupied_vents)
		vent = pick(get_vents())

	xenomorph_occupied_vents += vent
	player.forceMove(get_turf(vent))

/datum/antagonist/xenos/create_objectives(var/datum/mind/xeno)
	if(!..())
		return FALSE

	var/datum/objective/xeno/survive/s = new/datum/objective/xeno/survive
	s.owner = xeno
	xeno.objectives += s

	var/datum/objective/xeno/expand/e = new/datum/objective/xeno/expand
	e.owner = xeno
	xeno.objectives += e

	return TRUE