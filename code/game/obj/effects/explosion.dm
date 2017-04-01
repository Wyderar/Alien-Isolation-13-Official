
/obj/effect/explosion
	name = "explosive particles"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "explosion"
	opacity = 1
	anchored = 1
	mouse_opacity = 0
	pixel_x = -32
	pixel_y = -32

/obj/effect/explosion/New()
	..()
	spawn (10)
		qdel(src)
	return

/datum/effect/system/explosion
	var/turf/location

/datum/effect/system/explosion/proc/set_up(loca)
	if(istype(loca, /turf/)) location = loca
	else location = get_turf(loca)

/datum/effect/system/explosion/proc/start()
	new/obj/effect/explosion( location )
	var/datum/effect/system/expl_particles/P = new/datum/effect/system/expl_particles()
	P.set_up(10,location)
	P.start()
	spawn(5)
		var/datum/effect/effect/system/smoke_spread/S = new/datum/effect/effect/system/smoke_spread()
		S.set_up(5,0,location,null)
		S.start()