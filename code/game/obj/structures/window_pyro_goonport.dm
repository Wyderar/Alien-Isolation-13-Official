/obj/structure/window/auto
	icon = 'icons/obj/window_pyro.dmi'
	icon_state = "mapwin"
	dir = 5
	//deconstruct_time = 20
	var/default_reinforcement = "glass"
	var/mod = null
	var/added_color = FALSE
	anchored = 1.0
	/*
	var/list/connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn,
	/turf/simulated/shuttle/wall, /turf/simulated/shuttle/wall/escape, /obj/machinery/door,
	/obj/structure/window)*/

	var/list/connects_to = list(/turf/simulated/wall, /obj/machinery/door,
	/obj/structure/window)

	New()
		..()

		spawn(0)
			update_icon()

	update_icon()
		var/changed_dir = FALSE

		if (!src.anchored)
			icon_state = "[mod]0"
			return

		var/builtdir = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type in connects_to)
				builtdir |= dir
				changed_dir = TRUE
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						changed_dir = TRUE
						break

		if (!changed_dir) //we couldn't find a wall, window, or door!
			if (istype(get_step(src, SOUTH), /turf/simulated/wall))
				src.icon_state = "[mod]from_south_wall"
			if (istype(get_step(src, EAST), /turf/simulated/wall))
				src.icon_state = "[mod]from_east_wall"
			if (istype(get_step(src, NORTH), /turf/simulated/wall))
				src.icon_state = "[mod]from_north_wall"
			if (istype(get_step(src, WEST), /turf/simulated/wall))
				src.icon_state = "[mod]from_west_wall"
		else
			src.icon_state = "[mod][builtdir]"

	attackby(obj/item/W as obj, mob/user as mob)
		if (..(W, user))
			update_icon()

/obj/structure/window/auto/reinforced
	icon_state = "mapwin_r"
	mod = "R"
	default_reinforcement = "steel"
	health = 50

	update_icon()
		..()

		if (!added_color)
		//	src.icon += rgb(110,141,162/*,141*/) //adding alpha seems to fuck things up icon-wise, no idea why
			color = rgb(110,141,162) //alpha fucks up here, too
			added_color = TRUE
	//deconstruct_time = 30