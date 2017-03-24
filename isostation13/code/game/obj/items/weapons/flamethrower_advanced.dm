/obj/item/weapon/flamethrower/advanced
	throw_speed = 2
	throw_range = 10
	w_class = 3.0
	throw_amount = 200
	force = WEAPON_FORCE_PAINFULL * 1.33


/obj/item/weapon/flamethrower/advanced/full/New(var/loc)
	..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	ptank = new /obj/item/weapon/tank/plasma/big
	status = 1
	update_icon()

	return

/obj/item/weapon/flamethrower/advanced/flame_turf(turflist)
	var/mob/owner = loc
	if (owner)
		if(!lit || operating)	return
		operating = 1
		for(var/turf/T in turflist)
			if (!T.beyond_mob(owner))
				continue
			if(T.density || istype(T, /turf/space))
				break
			if(!previousturf && length(turflist)>1)
				previousturf = get_turf(src)
				continue	//so we don't burn the tile we be standin on
			if(previousturf && LinkBlocked(previousturf, T))
				break
			ignite_turf(T)
			sleep(1)
		previousturf = null
		operating = 0
		for(var/mob/M in viewers(1, loc))
			if((M.client && M.machine == src))
				attack_self(M)
		return
