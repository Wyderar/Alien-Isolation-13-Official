/mob/living/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED

	..()


	if (transformed && !mind)
		lying = FALSE
		regenerate_icons()
		return FALSE
	else if (transformed)
		transformed = FALSE
		regenerate_icons()

	if (transforming)
		return
	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()

	if(stat != DEAD)
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Blood
		handle_blood()

		//Random events (vomiting etc)
		handle_random_events()

		. = 1

	//Handle temperature/pressure differences between body and environment
	if(environment)
		handle_environment(environment)

	//Check if we're on fire
	handle_fire()

	//stuff in the stomach
	handle_stomach()

	update_pulling()

	for(var/obj/item/weapon/grab/G in src)
		G.process()

	blinded = 0 // Placing this here just show how out of place it is.
	// human/handle_regular_status_updates() needs a cleanup, as blindness should be handled in handle_disabilities()
	if(handle_regular_status_updates()) // Status & health update, are we dead or alive etc.
		handle_disabilities() // eye, ear, brain damages
		handle_status_effects() //all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc

	handle_actions()

	update_canmove()

	handle_regular_hud_updates()

	return TRUE

/mob/living/proc/handle_breathing()
	return

/mob/living/proc/handle_mutations_and_radiation()
	return

/mob/living/proc/handle_chemicals_in_body()
	return

/mob/living/proc/handle_blood()
	return

/mob/living/proc/handle_random_events()
	return

/mob/living/proc/handle_environment(var/datum/gas_mixture/environment)
	return

/mob/living/proc/handle_stomach()
	return

/mob/living/proc/update_pulling()
	if(pulling)
		if(incapacitated())
			stop_pulling()

//This updates the health and status of the mob (conscious, unconscious, dead)
/mob/living/proc/handle_regular_status_updates()
	updatehealth()
	if(stat != DEAD)
		if(paralysis)
			stat = UNCONSCIOUS
		else if (status_flags & FAKEDEATH)
			stat = UNCONSCIOUS
		else
			stat = CONSCIOUS
		return TRUE

//this updates all special effects: stunned, sleeping, weakened, druggy, stuttering, etc..
/mob/living/proc/handle_status_effects()
	if(paralysis)
		paralysis = max(paralysis-1,0)
	if(stunned)
		stunned = max(stunned-1,0)
		if(!stunned)
			update_icons()

	if(weakened)
		weakened = max(weakened-1,0)
		if(!weakened)
			update_icons()

/mob/living/proc/handle_disabilities()
	//Eyes
	if(sdisabilities & BLIND || stat)	//blindness from disability or unconsciousness doesn't get better on its own
		eye_blind = max(eye_blind, 1)
	else if(eye_blind)			//blindness, heals slowly over time
		eye_blind = max(eye_blind-1,0)
	else if(eye_blurry)			//blurry eyes heal slowly
		eye_blurry = max(eye_blurry-1, 0)

	//Ears
	if(sdisabilities & DEAF)		//disabled-deaf, doesn't get better on its own
		setEarDamage(-1, max(ear_deaf, 1))
	else
		// deafness heals slowly over time, unless ear_damage is over 100
		if(ear_damage < 100)
			adjustEarDamage(-0.05,-1)

//this handles hud updates. Calls update_vision() and handle_hud_icons()
/mob/living/proc/handle_regular_hud_updates()
	if(!client)	return FALSE

	handle_hud_icons()
	handle_vision()

	return TRUE


/mob/living/proc/handle_hud_icons()
	handle_hud_icons_health()
	handle_hud_glasses()

/mob/living/proc/handle_hud_icons_health()
	return

/*/mob/living/proc/HUD_create()
	if (!usr.client)
		return
	usr.client.screen.Cut()
	if(istype(usr, /mob/living/carbon/human) && (usr.client.prefs.UI_style != null))
		if (!global.HUDdatums.Find(usr.client.prefs.UI_style))
			log_debug("[usr] try update a HUD, but HUDdatums not have [usr.client.prefs.UI_style]!")
		else
			var/mob/living/carbon/human/H = usr
			var/datum/hud/human/HUDdatum = global.HUDdatums[usr.client.prefs.UI_style]
			if (!H.HUDneed.len)
				if (H.HUDprocess.len)
					log_debug("[usr] have object in HUDprocess list, but HUDneed is empty.")
					for(var/obj/screen/health/HUDobj in H.HUDprocess)
						H.HUDprocess -= HUDobj
						qdel(HUDobj)
				for(var/HUDname in HUDdatum.HUDneed)
					if(!H.species.hud.ProcessHUD.Find(HUDname))
						continue
					var/HUDtype = HUDdatum.HUDneed[HUDname]
					var/obj/screen/HUD = new HUDtype()
					world << "[HUD] added"
					H.HUDneed += HUD
					if (HUD.type in HUDdatum.HUDprocess)
						world << "[HUD] added in process"
						H.HUDprocess += HUD
					world << "[HUD] added in screen"
*/
