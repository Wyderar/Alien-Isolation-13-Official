
/turf/simulated/wall/goon/r_wall
	name = "r wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "r_wall"
	opacity = 1
	density = 1
	var/d_state = 0
	explosion_resistance = 7

/turf/simulated/wall/goon/supernorn
	icon = 'icons/turf/walls_goon.dmi'
	var/mod = "" // this is probably a stupid way to do this but i am real fuckin sleepy
	var/list/connect_images = list()
	var/connected_dirs = 0

	New()
		update_icon()
		for (var/turf/simulated/wall/goon/supernorn/T in orange(1))
			T.update_icon()
	//	for (var/obj/machinery/door/supernorn/O in orange(1))
	//		O.update_icon()
		..()

	update_icon()
		var/dirs = 0
		var/list/connect_dirs = list()
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (istype(T, /turf/simulated/wall/goon/supernorn))
				dirs |= dir
				// they are reinforced, we are not
				if (istype(T, /turf/simulated/wall/goon/supernorn/reinforced) && !istype(src, /turf/simulated/wall/goon/supernorn/reinforced))
					connect_dirs |= dir
				// they are not reinforced, we are
				else if (!istype(T, /turf/simulated/wall/goon/supernorn/reinforced) && istype(src, /turf/simulated/wall/goon/supernorn/reinforced))
					connect_dirs |= dir
			else if ((locate(/obj/machinery/door) in T) || (locate(/obj/structure/window/auto) in T)) // TODO: needs to check window dirs, which isnt possible atm
				dirs |= dir
				connect_dirs |= dir
		icon_state = "[mod][num2text(dirs)]"
		connected_dirs = dirs
		//overlays = null
		for (var/dir in cardinal) // we don't need to remove every overlay, just the relevant ones
			src.UpdateOverlays(null, "connect-[dir]")
		for (var/dir in connect_dirs)
			if (!src.connect_images["connect-[dir]"])
				src.connect_images["connect-[dir]"] = image(src.icon, "connect-[dir]")
			src.UpdateOverlays(src.connect_images["connect-[dir]"], "connect-[dir]")

/turf/simulated/wall/goon/supernorn/reinforced
	name = "reinforced wall"
	mod = "R"
	icon_state = "mapwall_r"