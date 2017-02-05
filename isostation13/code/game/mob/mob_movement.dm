/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return TRUE

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return


/mob/proc/movement_delay()
	return 0


/mob/proc/setMoveCooldown(var/timeout)//not used for basic movement
	if(client)
		client.move_delay = max(world.time + timeout, client.move_delay)

//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
/atom/movable/Move(newloc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/A = src.loc

		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()
		. = ..()
		if(direct != olddir)
			dir = olddir
			set_dir(direct)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		src.m_flag = 1
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)
	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return




/mob/proc/SelfMove(turf/n, direct)
	return Move(n, direct)


///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)

	switch(mob.incorporeal_move)
		if(1)
			var/turf/T = get_step(mob, direct)
			if(mob.check_holy(T))
				mob << "<span class='warning'>You cannot get past holy grounds while you are in this plane of existence!</span>"
				return
			else
				mob.forceMove(get_step(mob, direct))
				mob.dir = direct
		if(2)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				mob.forceMove(locate(locx,locy,mobloc.z))
				spawn(0)
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, mob.loc))
						spawn(0)
							anim(T,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
						limit--
						if(limit<=0)	break
			else
				spawn(0)
					anim(mobloc,mob,'icons/mob/mob.dmi',,"shadow",,mob.dir)
				mob.forceMove(get_step(mob, direct))
			mob.dir = direct
	// Crossed is always a bit iffy
	for(var/obj/S in mob.loc)
		if(istype(S,/obj/effect/step_trigger) || istype(S,/obj/effect/beam))
			S.Crossed(mob)

	var/area/A = get_area_master(mob)
	if(A)
		A.Entered(mob)
	if(isturf(mob.loc))
		var/turf/T = mob.loc
		T.Entered(mob)
	mob.Post_Incorpmove()
	return TRUE

/mob/proc/Post_Incorpmove()
	return

///Process_Spacemove
///Called by /client/Move()
///For moving in space
///return TRUE for movement 0 for none
/mob/proc/Process_Spacemove(var/check_drift = 0)

	if(!Check_Dense_Object()) //Nothing to push off of so end here
		update_floating(0)
		return FALSE

	update_floating(1)

	if(restrained()) //Check to see if we can do things
		return FALSE

	//Check to see if we slipped
	if(prob(slip_chance(5)) && !buckled)
		src << "<span class='warning'>You slipped!</span>"
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return FALSE
	//If not then we can reset inertia and move
	inertia_dir = 0
	return TRUE

/mob/proc/Check_Dense_Object() //checks for anything to push off in the vicinity. also handles magboots on gravity-less floors tiles

	var/shoegrip = Check_Shoegrip()

	for(var/turf/simulated/T in trange(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work
			return TRUE
		else
			var/area/A = T.loc
			if(A.has_gravity || shoegrip)
				return TRUE

	for(var/obj/O in orange(1, src))
		if(istype(O, /obj/structure/lattice))
			return TRUE
		if(O && O.density && O.anchored)
			return TRUE

	return FALSE

/mob/proc/Check_Shoegrip()
	return FALSE

/mob/proc/slip_chance(var/prob_slip = 5)
	if(stat)
		return FALSE
	if(Check_Shoegrip())
		return FALSE
	return prob_slip
