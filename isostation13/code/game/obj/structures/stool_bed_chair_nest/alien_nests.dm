//Alium nests. Essentially beds with an unbuckle delay that only aliums can buckle mobs to.
#define NEST_RESIST_TIME 500

/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/alien_new.dmi'
	icon_state = "nest"
	var/health = 100


/obj/structure/bed/nest/New()
	..()
	icon = 'icons/mob/alien_new.dmi'
	icon_state = "nest"
	overlays = null
	processing_objects += src

/obj/structure/bed/nest/Destroy()
	processing_objects -= src
	..()

/obj/structure/bed/nest/process()
	if (buckled_mob && isalien(buckled_mob) && prob(5))
		if (!ishumanoidalien(buckled_mob) && istype(buckled_mob, /mob/living/carbon/alien/larva))
			var/mob/living/carbon/alien/larva/larva = buckled_mob
			larva.adjustBruteLoss(-10)
			larva.adjustOxyLoss(-10)
			larva.adjustToxLoss(-10)
			larva.adjustFireLoss(-10)
			larva.adjustCloneLoss(-10)
		else if (istype(buckled_mob, /mob/living/carbon/human))
			var/mob/living/carbon/human/xeno = buckled_mob
			xeno.adjustBruteLoss(-5)
			xeno.adjustOxyLoss(-5)
			xeno.adjustToxLoss(-5)
			xeno.adjustFireLoss(-5)
			xeno.adjustCloneLoss(-5)
			var/datum/species/xenos/new_xeno/species = xeno.species
			species.heal_once(xeno)



/obj/structure/bed/nest/user_unbuckle_mob(mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user || isalien(user))
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the sticky nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
					"<span class='notice'>You hear squelching...</span>")
				buckled_mob.pixel_y = 0
				buckled_mob.old_y = 0
				unbuckle_mob()
			else
				if(world.time <= buckled_mob.last_special+NEST_RESIST_TIME)
					return
				buckled_mob.last_special = world.time
				buckled_mob.visible_message(\
					"<span class='warning'>[buckled_mob.name] struggles to break free of the gelatinous resin...</span>",\
					"<span class='warning'>You struggle to break free from the gelatinous resin...</span>",\
					"<span class='notice'>You hear squelching...</span>")
				spawn(NEST_RESIST_TIME)
					if(user && buckled_mob && user.buckled == src)
						buckled_mob.last_special = world.time
						buckled_mob.pixel_y = 0
						buckled_mob.old_y = 0
						unbuckle_mob()
			src.add_fingerprint(user)
	return

/obj/structure/bed/nest/user_buckle_mob(mob/M as mob, mob/user as mob)

	if (M != user) //allow the user to strap themselves in
		if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
			return

		if (!M.lying && istype(M, /mob/living/carbon))
			return

	else
		if (user.restrained() || user.stat || user.buckled)
			return

	unbuckle_mob()

	var/mob/living/carbon/xenos = user

	//removed is-victim-a-xeno check so xenos can buckle themselves in

	if(istype(xenos) && !(locate(/obj/item/organ/xenos/hivenode) in xenos.internal_organs))
		return


	if (M != user)
		M.visible_message(\
			"<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
			"<span class='warning'>[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!</span>",\
			"<span class='notice'>You hear squelching...</span>")
	else
		M.visible_message("<span class='alium'>[M.name] tucks themselves into the nest.</span>")

	M.buckled = src
	M.loc = src.loc
	M.set_dir(src.dir)
	M.update_canmove()
	M.pixel_y = 6
	M.old_y = 6
	src.buckled_mob = M
	src.add_fingerprint(user)
	return

/obj/structure/bed/nest/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/bed/nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return
