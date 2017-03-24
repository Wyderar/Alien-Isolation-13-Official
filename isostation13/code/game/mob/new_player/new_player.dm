//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = 2
	canmove = 0

	anchored = 1	//  don't get pushed around

/mob/new_player/New()
	mob_list += src

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <b>Ready</b> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <b>Not Ready</b> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			// TODO: reimplement database interaction
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	src << browse(output,"window=playersetup;size=210x280;can_close=0")
	return

/mob/new_player/Stat()
	..()

	if(statpanel("Lobby") && ticker)
		if(ticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(ticker.hide_mode == 0)
				stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

		if(ticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in player_list)
				stat("[player.key]", (player.ready)?("(Playing)"):(null))
				totalPlayers++
				if(player.ready)totalPlayersReady++

/mob/new_player/Topic(href, href_list[])
	if(!client)	return FALSE

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["observe"])

		if(alert(src,"Are you sure you wish to observe? You will have to wait 30 minutes before being able to respawn!","Player Setup","Yes","No") == "Yes")
			if(!client)	return TRUE
			var/mob/observer/ghost/observer = new()

			spawning = 1
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			if(istype(O))
				src << "<span class='notice'>Now teleporting.</span>"
				observer.loc = O.loc
			else
				src << "<span class='danger'>Could not locate an observer spawn point. Use the Teleport verb to jump to the station map.</span>"
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			announce_ghost_joinleave(src)
			client.prefs.update_preview_icon()
			observer.icon = client.prefs.preview_icon
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !config.antag_hud_allowed)           // For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/observer/ghost/verb/toggle_antagHUD        // Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return TRUE

	if(href_list["late_join"])

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			usr << "\red The round is either not ready, or has already finished..."
			return

		if(!check_rights(R_ADMIN, 0))
			var/datum/species/S = all_species[client.prefs.species]
			if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return FALSE

			if(!(S.spawn_flags & CAN_JOIN))
				src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
				return FALSE

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])

		if(!config.enter_allowed)
			usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
			return
		else if(ticker && ticker.mode && ticker.mode.explosion_in_progress)
			usr << "<span class='danger'>The station is currently exploding. Joining would go poorly.</span>"
			return

		var/datum/species/S = all_species[client.prefs.species]
		if((S.spawn_flags & IS_WHITELISTED) && !is_alien_whitelisted(src, client.prefs.species))
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return FALSE

		if(!(S.spawn_flags & CAN_JOIN))
			src << alert("Your current species, [client.prefs.species], is not available for play on the station.")
			return FALSE

		AttemptLateSpawn(href_list["SelectedJob"],client.prefs.spawnpoint)
		return

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])

		handle_player_polling()
		return

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = job_master.GetJob(rank)
	if(!job)	return FALSE
	if(!job.is_position_available()) return FALSE
	if(jobban_isbanned(src,rank))	return FALSE
	if(!job.player_old_enough(src.client))	return FALSE
	return TRUE

/mob/new_player/proc/IsSpawnSafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return is_safe_atmosphere(air, 1)

/mob/new_player/proc/AttemptLateSpawn(rank,var/spawning_at)
	if(src != usr)
		return FALSE
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		usr << "\red The round is either not ready, or has already finished..."
		return FALSE
	if(!config.enter_allowed)
		usr << "<span class='notice'>There is an administrative lock on entering the game!</span>"
		return FALSE
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return FALSE

	var/turf/T = job_master.LateSpawn(client, rank, 1)
	var/airstatus = IsSpawnSafe(T)
	if(airstatus)
		var/reply = alert(usr, "Warning. Your selected spawn location seems to have unfavorable atmospheric conditions. \
		You may die shortly after spawning. It is possible to select different spawn point via character preferences. \
		Spawn anyway? More information: [airstatus]", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [src] spawned at spawn point with dangerous atmosphere.")

		// Just in case someone stole our position while we were waiting for input from alert() proc
		if(!IsJobAvailable(rank))
			src << alert("[rank] is not available. Please try another.")
			return FALSE

	spawning = 1
	close_spawn_windows()

	job_master.AssignRole(src, rank, 1)

	var/mob/living/character = create_character()	//creates the human and transfers vars and mind
	character = job_master.EquipRank(character, rank, 1)					//equips the human
	UpdateFactionList(character)
	equip_custom_items(character)

	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

			// IsJobAvailable for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.loc = C.loc

		AnnounceCyborg(character, rank, "has been downloaded to the empty core in \the [character.loc.loc]")
		ticker.mode.handle_latejoin(character)

		qdel(C)
		qdel(src)
		return

	else if (character.mind.assigned_role == "Ironhammer Special Operative")

		character.loc = pick(ih_raider_spawn)
		ticker.mode.handle_latejoin(character)
		qdel(src)
		return

	//Find our spawning point.
	var/join_message = job_master.LateSpawn(character.client, rank)

	character.lastarea = get_area(loc)
	// Moving wheelchair if they have one
	if(character.buckled && istype(character.buckled, /obj/structure/bed/chair/wheelchair))
		character.buckled.loc = character.loc
		character.buckled.set_dir(character.dir)

	ticker.mode.handle_latejoin(character)

	if(character.mind.assigned_role != "Cyborg")
		data_core.manifest_inject(character)
		ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn

		//Grab some data from the character prefs for use in random news procs.

		if (!MODE_IH_RAIDER in ticker.mode.antag_tags)
			AnnounceArrival(character, rank, join_message)
	else
		if (!MODE_IH_RAIDER in ticker.mode.antag_tags)
			AnnounceCyborg(character, rank, join_message)

	qdel(src)

/mob/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (ticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has completed cryogenic revival"].", "Arrivals Announcement Computer")

/mob/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/dat = "<html><body><center>"
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"

	if(emergency_shuttle) //In case Nanotrasen decides reposess CentComm's shuttles.
		if(emergency_shuttle.going_to_centcom()) //Shuttle is going to centcomm, not recalled
			dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
		if(emergency_shuttle.online())
			if (emergency_shuttle.evac)	// Emergency shuttle is past the point of no recall
				dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"
			else						// Crew transfer initiated
				dat += "<font color='red'>The station is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	for(var/datum/job/job in job_master.occupations)

		if (ticker && MODE_IH_RAIDER in ticker.mode.antag_tags)
			if (!istype(job, /datum/job/ih_raider))
				continue
		else
			if (istype(job, /datum/job/ih_raider))
				continue

		if(job && IsJobAvailable(job.title))
			if(job.minimum_character_age && (client.prefs.age < job.minimum_character_age))
				continue
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in player_list) if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
				active++
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=300x640;can_close=1")


/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/use_species_name
	var/datum/species/chosen_species

	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
		use_species_name = chosen_species.get_station_variant() //Only used by pariahs atm.

	if(chosen_species && use_species_name)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(loc, use_species_name)

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			if(!(chosen_language.flags & WHITELISTED) || is_alien_whitelisted(src, lang) || has_admin_rights() \
				|| (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
				new_character.add_language(lang)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()
	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Show Crew Manifest</h4>"
	dat += data_core.get_manifest(OOC = 1)
	src << browse(dat, "window=manifest;size=370x420;can_close=1")

/mob/new_player/Move()
	return FALSE

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return TRUE
	return is_alien_whitelisted(src, S.name) || !(S.spawn_flags & IS_WHITELISTED)

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species)
		return "Human"

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

mob/new_player/MayRespawn()
	return TRUE
