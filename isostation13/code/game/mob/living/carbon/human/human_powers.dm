// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."


	if(last_special > world.time)
		return

	if(incapacitated_any())
		src << "\red You cannot tackle someone in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M) && !isalien(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("\red <B>[] [failed ? "tried to tackle" : "has tackled"] down []!</B>", src, T), 1)


/mob/living/carbon/human/proc/impale()
	set category = "Abilities"
	set name = "Tail Impale"
	set desc = "Impale a target with your tail."

	if(last_special > world.time)
		return

	if(incapacitated_any())
		src << "\red You cannot impale anyone in your current state."
		return

	var/mob/living/T = locate(/mob/living) in get_step(src, src.dir)

	if (!T)
		T = locate(/mob/living) in loc

	if(!T || T == src || !istype(T) || isalien(T)) return

	var/obj/item/weapon/shield/shield = null
	if (istype(T.r_hand, /obj/item/weapon/shield))
		shield = T.r_hand
	else
		shield = T.l_hand
	//tail impale is harder to block than leaping because it's an alpha skill, but there's still a 40-50% chance
	if (shield)
		if (istype(shield, /obj/item/weapon/shield/energy))
			var/obj/item/weapon/shield/energy/energy = shield
			if (energy.active)
				if (prob(50))
					src.visible_message("<span class='dainger'>\The [src]'s tail is blocked by [T]'s sheild!</span>")
					return FALSE
		else if (istype(shield))
			if (prob(40))
				src.visible_message("<span class='dainger'>\The [src]'s tail is blocked by [T]'s sheild!</span>")
				return FALSE


	last_special = world.time + pick(50,60)

	src.visible_message("<span class='danger'>[src] impales [T] with their sharp tail!</span>")
	playsound(src.loc, 'sound/weapons/slash.ogg', 100, 1)

	T.Weaken(10)

	T.apply_damage(rand(25,30), BRUTE, "chest")

	T.emote("scream")

/mob/living/carbon/human/proc/leap()
	set category = "Abilities"
	set name = "Leap"
	set desc = "Leap at a target and grab them aggressively."

	if(last_special > world.time)
		return

	if(incapacitated_any())
		src << "\red You cannot leap in your current state."
		return
/*
	var/list/choices = list()
	for(var/mob/living/M in view(6,src))
		if(!istype(M,/mob/living/silicon))
			choices += M
	choices -= src*/

	var/mob/living/T = find_living_target()

	var/rechecks = 0
	while (isalien(T) && isalien(src))
		T = find_living_target()
		++rechecks
		if (rechecks > 5)
			return

	if (!istype(T)) return

	if(!T || !src || src.stat) return

	if(get_dist(get_turf(T), get_turf(src)) > 4) return

	if(last_special > world.time)
		return

	last_special = world.time + 35
	status_flags |= LEAPING

	src.visible_message("<span class='danger'>\The [src] leaps at [T]!</span>")
	src.throw_at(get_step(get_turf(T),get_turf(src)), 4, 1, src)
	playsound(src.loc, 'sound/voice/shriek1.ogg', 50, 1)

	sleep(pick(1,2))

	if(status_flags & LEAPING) status_flags &= ~LEAPING

	if(!src.Adjacent(T))
		src << "<span class='warning'>You miss!</span>"
		return
	else
		var/obj/item/weapon/shield/shield = null
		if (istype(T.r_hand, /obj/item/weapon/shield))
			shield = T.r_hand
		else
			shield = T.l_hand

		if (shield)
			if (istype(shield, /obj/item/weapon/shield/energy))
				var/obj/item/weapon/shield/energy/energy = shield
				if (energy.active)
					if (prob(65))
						src.visible_message("<span class='dainger'>\The [src] is blocked by [T]'s sheild!</span>")
						return FALSE
			else if (istype(shield))
				if (prob(55))
					src.visible_message("<span class='dainger'>\The [src] is blocked by [T]'s sheild!</span>")
					return FALSE

		T.Weaken(rand(7,9))

		return TRUE

	// Pariahs are not good at leaping. This is snowflakey, pls fix.
	if(species.name == "Vox Pariah")
		src.Weaken(5)
		return
/* grabbing was too buggy, removed it for now - Cherkir
	var/use_hand = "left"
	if(l_hand)
		if(r_hand)
			src << "<span class='danger'>You need to have one hand free to grab someone.</span>"
			return
		else
			use_hand = "right"

	src.visible_message("<span class='warning'><b>\The [src]</b> seizes [T] aggressively!</span>")

	var/obj/item/weapon/grab/G = new(src,T)
	if(use_hand == "left")
		l_hand = G
	else
		r_hand = G

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()
*/

/mob/living/carbon/human/proc/headbite()
	set category = "Abilities"
	set name = "Headbite"
	set desc = "While grabbing someone aggressively, bite them in the head, instantly killing them 80% of the time or otherwise severely wounding them."

	if(last_special > world.time)
		return

	if(incapacitated_any())
		src << "\red You cannot do that in your current state."
		return

	var/mob/target = null

	for (var/mob/m in get_step(src, src.dir)) //let's allow instant headbiting of nested hosts
		if (m.buckled)
			target = m
			goto _skippedgrab_

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "\red You are not grabbing anyone."
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "\red You must have an aggressive grab to gut your prey!"
		return

	target = G.affecting

	_skippedgrab_

	if (isalien(src) && isalien(target))
		return

	last_special = world.time + 100

	visible_message("<span class='danger'>[src] extends their inner mouth...</span>", "<span class='alium'><i>You must stand still...</i></alium>")

	if (do_after(src, 100, target))
		if (!src.incapacitated_any())
			visible_message("<span class='danger'><b>\The [src]</b> sends its inner mouth straight through [target]'s [pick("skull", "brain")]!</span>")

			if(istype(target,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = target
				H.apply_damage(10000,BRUTE,"head")
			else
				var/mob/living/M = target
				if(!istype(M)) return //what the fuck
				M.apply_damage(10000,BRUTE)


/mob/living/carbon/human/proc/gut()
	set category = "Abilities"
	set name = "Gut"
	set desc = "While grabbing someone aggressively, rip their guts out or tear them apart."

	if(last_special > world.time)
		return

	if(incapacitated_any())
		src << "\red You cannot do that in your current state."
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "\red You are not grabbing anyone."
		return

	if (isalien(src) && isalien(G.affecting))
		return

	if(G.state < GRAB_AGGRESSIVE)
		src << "\red You must have an aggressive grab to gut your prey!"
		return

	last_special = world.time + 50

	visible_message("<span class='warning'><b>\The [src]</b> rips viciously at \the [G.affecting]'s body with its claws!</span>")

	if(istype(G.affecting,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = G.affecting
		H.apply_damage(50,BRUTE)
		if(H.stat == 2)
			H.gib()
	else
		var/mob/living/M = G.affecting
		if(!istype(M)) return //wut
		M.apply_damage(50,BRUTE)
		if(M.stat == 2)
			M.gib()

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(isghost(M) || M.stat == DEAD)
		src << "Not even a [src.species.name] can speak to the dead."
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	M << "\blue Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]"
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "\red Your nose begins to bleed..."
		H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message("\red <B>[src] hurls out the contents of their stomach!</B>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		M << "\green You hear a strange, alien voice in your head... \italic [msg]"
		src << "\green You said: \"[msg]\" to [M]"
	return
