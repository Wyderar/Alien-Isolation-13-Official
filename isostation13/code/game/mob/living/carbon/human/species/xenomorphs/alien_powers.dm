/proc/alien_queen_exists(var/ignore_self,var/mob/living/carbon/human/self)
	for(var/mob/living/carbon/human/Q in living_mob_list)
		if(self && ignore_self && self == Q)
			continue
		if(Q.species.name != "Xenomorph Queen")
			continue
		if(!Q.key || !Q.client || Q.stat)
			continue
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/gain_plasma(var/amount)

	var/obj/item/organ/xenos/plasmavessel/I = internal_organs_by_name["plasma vessel"]
	if(!istype(I)) return

	if(amount)
		I.stored_plasma += amount
	I.stored_plasma = max(0,min(I.stored_plasma,I.max_plasma))

/mob/living/carbon/human/proc/check_alien_ability(var/cost,var/needs_foundation,var/needs_organ)

	var/obj/item/organ/xenos/plasmavessel/P = internal_organs_by_name["plasma vessel"]
	if(!istype(P))
		src << "<span class='danger'>Your plasma vessel has been removed!</span>"
		return

	if(needs_organ)
		var/obj/item/organ/I = internal_organs_by_name[needs_organ]
		if(!I || !istype(I))
			src << "<span class='danger'>Your [needs_organ] has been removed!</span>"
			return
		else if((I.status & ORGAN_CUT_AWAY) || I.is_broken())
			src << "<span class='danger'>Your [needs_organ] is too damaged to function!</span>"
			return

	if(P.stored_plasma < cost)
		src << "\red You don't have enough plasma stored to do that."
		return FALSE

	if(needs_foundation)
		var/turf/T = get_turf(src)
		var/has_foundation
		if(T)
			//TODO: Work out the actual conditions this needs.
			if(!(istype(T,/turf/space)))
				has_foundation = 1
		if(!has_foundation)
			src << "\red You need a solid foundation to do that on."
			return FALSE

	P.stored_plasma -= cost
	return TRUE

/mob/living/carbon/human/proc/deweld()
	set name = "Deweld"
	set desc = "Unweld an airlock or vent."
	set category = "Abilities"

	var/obj/machinery/door/airlock/door = locate(/obj/machinery/door/airlock) in get_step(src, src.dir)
	var/obj/machinery/atmospherics/unary/vent_pump/vent = locate(/obj/machinery/atmospherics/unary/vent_pump) in get_step(src, src.dir)

	if (door && istype(door) || vent && istype(vent))

		visible_message("<span class = 'danger'>[src] starts to unweld the [door ? "door" : "vent"]</span>", "<span class = 'alium'>You start to unweld the [door ? "door" : "vent"].</span>")

		if (do_after(src, 30, door ? door : vent))
			if (door) //door takes priority
				door.welded = FALSE
			else if (vent)
				vent.welded = FALSE

			visible_message("<span class = 'danger'>[src] unwelds the [door ? "door" : "vent"]</span>", "<span class = 'alium'>You unweld the [door ? "door" : "vent"].</span>")

/mob/living/carbon/human/proc/tear_girder()
	set name = "Tear Girders"
	set desc = "Tear apart a wall or girder."
	set category = "Abilities"

	if (!ishumanoidalien(src)) return

	if (incapacitated_any())
		src << "\red You cannot tear a girder or wall in your current state."
		return

	if (species:delays["tear_girder"] && species:delays["tear_girder"] > world.time)
		return

	species:delays["tear_girder"] = world.time + rand(20,30)

	var/obj/structure/girder/girder = locate() in get_step(src, src.dir)
	var/turf/simulated/wall/wall = get_step(src, src.dir)

	if (girder && istype(girder) && girder.is_exterior(src))
		return

	if (wall && istype(wall) && wall.is_exterior(src))
		return

	if (wall && istype(wall))
		visible_message("<span class='danger'>[src] furiously scratches against the wall!</span>")
		if (prob(4))
			qdel(wall)

	else if (girder && istype(girder))
		visible_message("<span class='danger'>[src] furiously scratches against the girder!</span>")
		if (prob(7))
			qdel(girder)

// Free abilities.
/mob/living/carbon/human/proc/transfer_plasma(mob/living/carbon/human/M as mob in oview(1))
	set name = "Transfer Plasma"
	set desc = "Transfer Plasma to another alien"
	set category = "Abilities"

	if (get_dist(src,M) > 1)
		src << "<span class='alium'>You need to be closer.</span>"
		return

	var/obj/item/organ/xenos/plasmavessel/I = M.internal_organs_by_name["plasma vessel"]
	if(!istype(I))
		src << "<span class='alium'>Their plasma vessel is missing.</span>"
		return

	var/amount = input("Amount:", "Transfer Plasma to [M]") as num
	if (amount)
		amount = abs(round(amount))
		if(check_alien_ability(amount,0,"plasma vessel"))
			M.gain_plasma(amount)
			M << "<span class='alium'>[src] has transfered [amount] plasma to you.</span>"
			src << "<span class='alium'>You have transferred [amount] plasma to [M].</span>"
	return

// Queen verbs.
/mob/living/carbon/human/proc/lay_egg()

	set name = "Lay Egg (75)"
	set desc = "Lay an egg to produce huggers to impregnate prey with."
	set category = "Abilities"


	if (incapacitated_any())
		src << "\red You cannot lay eggs in your current state."
		return

	if(!config.aliens_allowed)
		src << "You begin to lay an egg, but hesitate. You suspect it isn't allowed."
		verbs -= /mob/living/carbon/human/proc/lay_egg
		return

	if(locate(/obj/structure/alien/egg) in get_turf(src))
		src << "There's already an egg here."
		return

	if(check_alien_ability(75,1,"egg sac"))
		visible_message("<span class='alium'><B>[src] has laid an egg!</B></span>")
		new /obj/structure/alien/egg(loc)

	return

// Drone verbs.
/mob/living/carbon/human/proc/evolve()
	set name = "Evolve (500)"
	set desc = "Produce an interal egg sac capable of spawning children. Only one queen can exist at a time."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot evolve in your current state."
		return


	if(alien_queen_exists())
		src << "<span class='notice'>We already have an active queen.</span>"
		return


	if(check_alien_ability(500))
		visible_message("<span class='alium'><B>[src] begins to twist and contort!</B></span>", "<span class='alium'>You begin to evolve!</span>")
		src.set_species("Xenomorph Queen")

	return

/mob/living/carbon/human/proc/plant()
	set name = "Plant Weeds (50)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot plant weeds in your current state."
		return

	if(check_alien_ability(50,1,"resin spinner"))
		visible_message("<span class='alium'><B>[src] has planted some alien weeds!</B></span>")
		new /obj/structure/alien/node(loc)
	return

/mob/living/carbon/human/proc/corrosive_acid(O as obj|turf in oview(1)) //If they right click to corrode, an error will flash if its an invalid target./N
	set name = "Corrosive Acid (200)"
	set desc = "Drench an object in acid, destroying it over time."
	set category = "Abilities"

	if (isobj(O))
		var/obj/obj = O
		if (obj.is_exterior(src))
			src << "\red You cannot corrode this."
			return FALSE
	else if (isturf(O))
		var/turf/turf = O
		if (turf.is_exterior(src))
			src << "\red You cannot corrode this."
			return FALSE

	if (incapacitated_any())
		src << "\red You cannot corrode something in your current state."
		return


	if(!O in oview(1))
		src << "<span class='alium'>[O] is too far away.</span>"
		return

	// OBJ CHECK
	var/cannot_melt
	if(isobj(O))
		var/obj/I = O
		if(I.unacidable)
			cannot_melt = 1
	else
		if(istype(O, /turf/simulated/wall))
			var/turf/simulated/wall/W = O
			if(W.material.flags & MATERIAL_UNMELTABLE)
				cannot_melt = 1
		else if(istype(O, /turf/simulated/floor))
			var/turf/simulated/floor/F = O
			if(F.flooring && (F.flooring.flags & TURF_ACID_IMMUNE))
				cannot_melt = 1
			if (F.z == 1)//no melting to space
				cannot_melt = 1

	if(cannot_melt)
		src << "<span class='alium'>You cannot dissolve this object.</span>"
		return

	if(check_alien_ability(200,0,"acid gland"))
		new /obj/effect/acid/powerful(get_turf(O), O)
		visible_message("<span class='alium'><B>[src] vomits globs of vile stuff all over [O]. It begins to sizzle and melt under the bubbling mess of acid!</B></span>")

	return

/mob/living/carbon/human/proc/prydoor()
	set name = "Pry Door"
	set desc = "Force a door open using your claws."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot pry doors in your current state."
		return

	var/d = null
	var/last_door_layer = -1

	for (var/obj/machinery/door/somedoor in get_step(src,src.dir))
		if (somedoor.Adjacent(src))
			if (!somedoor.p_open)
				if (somedoor.layer > last_door_layer)
					d = somedoor
					last_door_layer = somedoor.layer

	if(incapacitated_any())
		return

	if (!d)
		return

	if (d)

		handle_prydoor()


/mob/living/carbon/human/proc/neurotoxin()
	set name = "Spit Neurotoxin (50)"
	set desc = "Spits neurotoxin at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot use neurotoxin in your current state."
		return

	var/mob/target = find_living_target()

	if (target == null || isalien(target))
		return

	if(!check_alien_ability(50,0,"acid gland"))
		return


	visible_message("<span class='warning'>[src] spits neurotoxin at [target]!</span>", "<span class='alium'>You spit neurotoxin at [target].</span>")

	//I'm not motivated enough to revise this. Prjectile code in general needs update.
	// Maybe change this to use throw_at? ~ Z
	var/turf/T = loc
	var/turf/U = (istype(target, /atom/movable) ? target.loc : target)

	if(!U || !T)
		return
	while(U && !istype(U,/turf))
		U = U.loc
	if(!istype(T, /turf))
		return
	if (U == T)
		usr.bullet_act(new /obj/item/projectile/energy/neurotoxin(usr.loc), get_organ_target())
		return
	if(!istype(U, /turf))
		return

	var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(usr.loc)
	A.launch(target, "chest")
	A.current = U
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	A.process()
	return
/*
/mob/living/carbon/human/proc/resin() // -- TLE
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough, malleable resin."
	set category = "Abilities"


	if (incapacitated_any())
		src << "\red You cannot make resin structures in your current state."
		return

	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
	if(!choice)
		return

	if(!check_alien_ability(75,1,"resin spinner"))
		return

	visible_message("<span class='warning'><B>[src] vomits up a thick purple substance and begins to shape it!</B></span>", "<span class='alium'>You shape a [choice].</span>")
	switch(choice)
		if("resin door")
			new /obj/machinery/door/unpowered/simple/resin(loc)
		if("resin wall")
			new /obj/structure/alien/resin/wall(loc)
		if("resin membrane")
			new /obj/structure/alien/resin/membrane(loc)
		if("resin nest")
			new /obj/structure/bed/nest(loc)
	return

*/
/mob/living/carbon/human/proc/ceiling_hang()
	set name = "Hang From Ceiling"
	set desc = "Attach yourself to the ceiling, and jump down by clicking."
	set category = "Abilities"

	if (!ishumanoidalien(src))
		return

	if (incapacitated_any())
		src << "\red You cannot jump in your current state."
		return


	visible_message("<span class='danger'><b>[src] jumps to the ceiling!</b></span>")

/mob/living/carbon/human/proc/ceiling_fall()
	if (!ishumanoidalien(src))

		visible_message("<span class='danger'><b>[src] jumps down from the ceiling!</b></span>")
		invisibility = initial(invisibility)
		see_invisible =  initial(see_invisible)


/mob/living/carbon/human/proc/make_nest() // -- cherkir
	set name = "Make Nest (50)"
	set desc = "Secrete tough, malleable resin in the shape of a nest, used to restrain hosts."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot make a nest in your current state."
		return

	if(!check_alien_ability(50,1,"resin spinner"))
		return

	if (find_alien_obj(get_turf(src)))
		src << "\red There is already something here."
		return FALSE

	var/obj/machinery/atmospherics/unary/vent_pump/vent = locate(/obj/machinery/atmospherics/unary/vent_pump) in get_turf(src)

	if (vent && istype(vent))
		src << "\red It would be a real dick move to make that there."
		return FALSE

	visible_message("<span class='warning'><b>[src] vomits up a thick purple substance and begins to shape it!</b></span>", "<span class='alium'>You shape a nest.</span>")

	new /obj/structure/bed/nest(get_turf(src))

/mob/living/carbon/human/proc/make_cocoon() // -- cherkir
	set name = "Make Cocoon (50)"
	set desc = "Secrete tough, malleable resin in the shape of a cocoon, used to eggmorph hosts."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot make a nest in your current state."
		return FALSE

	var/can_continue = FALSE

	if (istype(get_step(src, src.dir), /turf/simulated/wall))
		if (src.dir == NORTH)
			can_continue = TRUE

	var/obj/structure/struct = locate(/obj/structure) in get_step(src, src.dir)
	if (struct && struct.density && !istype(struct, /obj/structure/table) && !istype(struct, /obj/structure/closet))
		if (src.dir == NORTH)
			can_continue = TRUE

	if (!can_continue)
		src << "\red The cocoon must be on a forward facing wall or structure."
		return FALSE

	if (find_alien_obj(get_turf(src)))
		src << "\red There is already something here."
		return FALSE

	if(!check_alien_ability(50,1,"resin spinner"))
		return FALSE

	visible_message("<span class='warning'><b>[src] vomits up a thick purple substance and begins to shape it!</b></span>", "<span class='alium'>You shape a cocoon.</span>")

	new /obj/structure/bed/cocoon(get_turf(src))

	return TRUE

mob/living/carbon/human/proc/xeno_infest(mob/living/carbon/human/M as mob in oview())
	set name = "Infest (500)"
	set desc = "Link a victim to the hivemind."
	set category = "Abilities"

	if (incapacitated_any())
		src << "\red You cannot infest someone in your current state."
		return


	if(!M.Adjacent(src))
		src << "<span class='warning'>They are too far away.</span>"
		return

	if(!M.mind)
		src << "<span class='warning'>This mindless flesh adds nothing to the hive.</span>"
		return

	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name["hive node"]))
		src << "<span class='warning'>They are already part of the hive.</span>"
		return

	var/obj/item/organ/affecting = M.get_organ("chest")
	if(!affecting || (affecting.status & ORGAN_ROBOT))
		src << "<span class='warning'>This form is not compatible with our physiology.</span>"
		return

	src.visible_message("<span class='danger'>\The [src] crouches over \the [M], extending a hideous protuberance from its head!</span>")

	if(!do_mob(src, M, 150))
		return

	if(!M || !M.Adjacent(src))
		src << "<span class='warning'>They are too far away.</span>"
		return

	if(M.species.get_bodytype() == "Xenomorph" || !isnull(M.internal_organs_by_name["hive node"]) || !affecting || (affecting.status & ORGAN_ROBOT))
		return

	if(!check_alien_ability(500,1,"egg sac"))
		return

	src.visible_message("<span class='danger'>\The [src] regurgitates something into \the [M]'s torso!</span>")
	M << "<span class='danger'>A hideous lump of alien mass strains your ribcage as it settles within!</span>"
	var/obj/item/organ/xenos/hivenode/node = new(affecting)
	node.replaced(M,affecting)