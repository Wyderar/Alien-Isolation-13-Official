/obj/structure/alien/node
//	name = "alien weed node"
	name = ""//now you can't click it
	desc = "Some kind of strange, pulsating structure."
	icon = 'icons/mob/alien_new.dmi'
	icon_state = ""
	health = 100
	layer = 3.1
	anchored = 1
	var/weeds = list()

/obj/structure/alien/node/New()
	..()
	processing_objects += src
	created()

/obj/structure/alien/node/Destroy()
	processing_objects -= src
	..()

/obj/structure/alien/node/process()
	if (prob(1))//lag prevention.
		for (var/obj/structure/alien/weed/weeds in weeds)
			for (var/obj/item/organ/organ in get_turf(weeds))
				if (prob(33))
					visible_message("<span style = \"alium\">[organ.name] decays into a pile of gorey goop.</span>")


///obj/structure/alien/node/New()
//	..()
//	processing_objects += src

///obj/structure/alien/node/Destroy()
//	processing_objects -= src
//	..()

/obj/structure/alien/node/proc/created()
//	if(locate(/obj/effect/plant) in loc)
//		return

	//new /obj/effect/plant(get_turf(src), plant_controller.seeds["xenomorph"])
	var/list/draw_list = list()
	var/icon/i = new(icon)
	var/list/icon_list = i.IconStates()
	for (var/txtval in icon_list)
		if(findtext(txtval, "creep") && !findtext(txtval, "center"))
			draw_list += txtval

	var/obj/w = new/obj/structure/alien/weed(locate(x, y, z), "creep_center")
	var/turf/w_turf = get_turf(w)
	w.layer = w_turf.layer + 0.001

	var/obj/c = locate(/obj/structure/catwalk) in w_turf

	if (c)
		w.layer = c.layer + 0.001

	weeds += w

	var/count = 0

	for (var/d in draw_list)
		var/old_d = d
		count++
		spawn(count * rand(10,100))
			var/x_offset = 0
			var/y_offset = 0

			while (findtext(d, "north"))
				d = replacetext(d, "north", "")
				y_offset++

			while (findtext(d, "south"))
				d = replacetext(d, "south", "")
				y_offset--

			while (findtext(d, "east"))
				d = replacetext(d, "east", "")
				x_offset++


			while (findtext(d, "west"))
				d = replacetext(d, "west", "")
				x_offset--

			var/turf/the_turf = locate(x+x_offset, y+y_offset, z)
			if (isturf(the_turf) && !the_turf.density && !the_turf.opacity && !locate(/obj/structure/alien/weed) in the_turf)
				var/no_dense_atoms = 1
				for (var/atom/a in the_turf)
					if (a.density)
						no_dense_atoms = 0

				if (no_dense_atoms)
					var/obj/o = depool_weed(the_turf, old_d)

					o.layer = the_turf.layer + 0.001//just above the floor

					c = locate(/obj/structure/catwalk) in the_turf

					if (c)
						o.layer = c.layer + 0.001

					weeds += o