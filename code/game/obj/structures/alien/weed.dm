var/list/weed_pool = list()


proc/generate_weeds()
	for (var/area/security/area in world)
		if (area.z == 1)
			for (var/turf/simulated/floor/floor in area)
				if (prob(7))
					new/obj/structure/alien/weed(floor, "")

	for (var/area/medical/area in world)
		if (area.z == 1)
			for (var/turf/simulated/floor/floor in area)
				if (prob(7))
					new/obj/structure/alien/weed(floor, "")

	for (var/area/engineering/area in world)
		if (area.z == 1)
			for (var/turf/simulated/floor/floor in area)
				if (prob(7))
					new/obj/structure/alien/weed(floor, "")


proc/depool_weed(nloc, state)
	var/obj/structure/alien/weed = pick(weed_pool)
	weed_pool -= weed

	weed.loc = nloc
	weed.icon_state = state
//	set_light(3,3, rgb(100,50,100))

	for (var/obj/structure/alien/weed/w in weed.loc)
		if (w != weed)
			qdel(w)

	if (weed_pool.len <= 100)
		for (var/v in 1 to 5)
			weed_pool += new/obj/structure/alien/weed

	return weed

/obj/structure/alien/weed
	name = "weeds"
	desc = "Some kind of strange, black weeds."
	icon = 'icons/mob/alien_new.dmi'
	icon_state = ""
	health = 100
	anchored = 1
	layer = 3.1


	New(nloc, state)
		..()
		loc = nloc
		icon_state = state
	//	set_light(3,3, rgb(100,50,100))

		for (var/obj/structure/alien/weed/w in loc)
			if (w != src)
				qdel(w)


	Del()
		..()


/obj/structure/alien/weed/fire_act()
	if (prob(80))
		src.visible_message("\red [src] melts!")
		qdel(src)


/obj/structure/alien/weed/ex_act(severity)
	switch(severity)
		if(1.0 to 2.0)
			qdel(src)
			return
		if (3.0)
			health-=pick(25,50)
	healthcheck()
	return