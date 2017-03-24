/obj/structure/window/auto
	icon = 'icons/obj/window_pyro.dmi'
	icon_state = "mapwin"
	dir = 5
	//deconstruct_time = 20
	var/default_reinforcement = "glass"
	var/mod = null
	var/added_color = FALSE
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
		if (!src.anchored)
			icon_state = "[mod]0"
			return

		var/builtdir = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type in connects_to)
				builtdir |= dir
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						break
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
			color = rgb(110,141,162)
			added_color = TRUE
	//deconstruct_time = 30