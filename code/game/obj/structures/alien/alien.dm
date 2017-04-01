/obj/structure/alien
	name = "alien thing"
	desc = "There's something alien about this."
	icon = 'icons/mob/alien_new.dmi'
	var/health = 50

/obj/structure/alien/fire_act()
	if (prob(20))
		src.visible_message("\red [src] melts!")
		qdel(src)

/proc/find_alien_obj(var/atom/a)
	var/t = isturf(a) ? a : get_turf(a)

	var/to_return = FALSE

	for (var/obj/structure/alien/alien_structure in t)
		if (!istype(alien_structure, /obj/structure/alien/weed) && !istype(alien_structure, /obj/structure/alien/node))
			to_return = TRUE

	if (locate(/obj/structure/bed) in t)
		to_return = TRUE

	return to_return

/obj/structure/alien/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/structure/alien/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/structure/alien/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			health-=50
		if(3.0)
			if (prob(50))
				health-=50
			else
				health-=25
	healthcheck()
	return

/obj/structure/alien/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>\The [src] was hit by \the [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()
	..()
	return

/obj/structure/alien/attack_generic()
	attack_hand(usr)

/obj/structure/alien/attackby(var/obj/item/weapon/W, var/mob/user)
	health = max(0, health - W.force)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/structure/alien/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return FALSE
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density