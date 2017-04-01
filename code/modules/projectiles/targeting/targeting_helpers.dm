/mob/proc/find_mob_target()
	for (var/mob/m in view(10, src))
		if (can_target(m))
			return m
	return null

/mob/proc/find_living_target()
	for (var/mob/living/m in view(10, src))
		if (can_target(m))
			return m
	return null


/mob/proc/can_target(var/atom/a)
	if (istype(src) && istype(a))
		if (z == a.z)
			if (x == a.x && y == a.y)
				return FALSE
			else if (x > a.x)
				if (dir == WEST)
					return TRUE
			else if (x < a.x)
				if (dir == EAST)
					return TRUE
			else if (y > a.y)
				if (dir == SOUTH)
					return TRUE
			else if (y < a.y)
				if (dir == NORTH)
					return TRUE
	return FALSE