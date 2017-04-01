/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!stat && canClick())
		setClickCooldown(20)
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/weapon/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()
		return TRUE

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/obj/structure/closet/C = loc
		spawn() C.mob_breakout(src)
		return TRUE

/mob/living/proc/escape_inventory(obj/item/weapon/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		M << "<span class='warning'>\The [H] wriggles out of your grip!</span>"
		src << "<span class='warning'>You wriggle out of \the [M]'s grip!</span>"

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/weapon/holder))
				return
		M.status_flags &= ~PASSEMOTES

	else if(istype(H.loc,/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = H.loc
		if(holster.holstered == H)
			holster.clear_holster()
		src << "<span class='warning'>You extricate yourself from \the [holster].</span>"
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj/item))
		src << "<span class='warning'>You struggle free of \the [H.loc].</span>"
		H.forceMove(get_turf(H))

/mob/living/proc/escape_buckle()
	if(buckled)
		buckled.user_unbuckle_mob(src)

/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/O in requests)
		requests.Remove(O)
		qdel(O)
		resisting++
	for(var/obj/item/weapon/grab/G in grabbed_by)

		var/hard_to_resist = FALSE
		if (isalien(G.assailant) || isworkingjoe(G.assailant))
			if (!isalien(G.affecting) && !isworkingjoe(G.affecting))
				hard_to_resist = TRUE

		var/easy_to_resist = FALSE
		if (!isalien(G.assailant) && !isworkingjoe(G.assailant))
			if (isalien(G.affecting) || isworkingjoe(G.affecting))
				easy_to_resist = TRUE

		resisting++
		switch(G.state)
			if(GRAB_PASSIVE)
				if (hard_to_resist && prob(80))
					goto _skipbody_
				qdel(G)
			if(GRAB_AGGRESSIVE)
				if(prob(60 + (easy_to_resist ? 30 : 0))) //same chance of breaking the grab as disarm
					if (hard_to_resist && prob(80))
						goto _skipbody_
					visible_message("<span class='warning'>[src] has broken free of [G.assailant]'s grip!</span>")
					qdel(G)
			if(GRAB_NECK)
				//If the you move when grabbing someone then it's easier for them to break free. Same if the affected mob is immune to stun.
				if (((world.time - G.assailant.l_move_time < 30 || !stunned) && prob(15 + (easy_to_resist ? 35 : 0))) || prob(3 + (easy_to_resist ? 10 : 0)))
					if (hard_to_resist && prob(80))
						goto _skipbody_
					visible_message("<span class='warning'>[src] has broken free of [G.assailant]'s headlock!</span>")
					qdel(G)
	_skipbody_
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

