/* Glass stack types
 * Contains:
 *		Glass sheets
 *		Reinforced glass sheets
 *		plasma Glass Sheets
 *		Reinforced plasma Glass Sheets (AKA Holy fuck strong windows)
 *		Glass shards - TODO: Move this into code/game/object/item/weapons
 */

/*
 * Glass sheets
 */
/obj/item/stack/material/glass
	name = "glass"
	singular_name = "glass sheet"
	icon_state = "sheet-glass"
	var/created_window = /obj/structure/window/basic
	var/is_reinforced = 0
	var/list/construction_options = list("One Direction", "Full Window")
	default_type = "glass"

/obj/item/stack/material/glass/attack_self(mob/user as mob)
	construct_window(user)

/obj/item/stack/material/glass/attackby(obj/item/W, mob/user)
	..()
	if(!is_reinforced)
		if(istype(W,/obj/item/stack/cable_coil))
			var/obj/item/stack/cable_coil/CC = W
			if (get_amount() < 1 || CC.get_amount() < 5)
				user << "<span class='warning'>You need five lengths of coil and one sheet of glass to make wired glass.</span>"
				return

			CC.use(5)
			use(1)
			user << "<span class='notice'>You attach wire to the [name].</span>"
	//		new /obj/item/stack/light_w(user.loc)
		else if(istype(W, /obj/item/stack/rods))
			var/obj/item/stack/rods/V  = W
			if (V.get_amount() < 1 || get_amount() < 1)
				user << "<span class='warning'>You need one rod and one sheet of glass to make reinforced glass.</span>"
				return

			var/obj/item/stack/material/glass/reinforced/RG = new (user.loc)
			RG.add_fingerprint(user)
			RG.add_to_stacks(user)
			var/obj/item/stack/material/glass/G = src
			src = null
			var/replace = (user.get_inactive_hand()==G)
			V.use(1)
			G.use(1)
			if (!G && replace)
				user.put_in_hands(RG)

/obj/item/stack/material/glass/proc/construct_window(mob/user as mob)
	if(!user || !src)	return FALSE
	if(!istype(user.loc,/turf)) return FALSE
	if(!user.IsAdvancedToolUser())
		return FALSE
	var/title = "Sheet-[name]"
	title += " ([src.get_amount()] sheet\s left)"
	switch(input(title, "What would you like to construct?") as null|anything in construction_options)
		if("One Direction")
			if(!src)	return TRUE
			if(src.loc != user)	return TRUE

			var/list/directions = new/list(cardinal)
			var/i = 0
			for (var/obj/structure/window/win in user.loc)
				i++
				if(i >= 4)
					user << "<span class='warning'>There are too many windows in this location.</span>"
					return TRUE
				directions-=win.dir
				if(!(win.dir in cardinal))
					user << "<span class='warning'>Can't let you do that.</span>"
					return TRUE

			//Determine the direction. It will first check in the direction the person making the window is facing, if it finds an already made window it will try looking at the next cardinal direction, etc.
			var/dir_to_set = 2
			for(var/direction in list( user.dir, turn(user.dir,90), turn(user.dir,180), turn(user.dir,270) ))
				var/found = 0
				for(var/obj/structure/window/WT in user.loc)
					if(WT.dir == direction)
						found = 1
				if(!found)
					dir_to_set = direction
					break
			new created_window( user.loc, dir_to_set, 1 )
			src.use(1)
		if("Full Window")
			if(!src)	return TRUE
			if(src.loc != user)	return TRUE
			if(src.get_amount() < 4)
				user << "<span class='warning'>You need more glass to do that.</span>"
				return TRUE
			if(locate(/obj/structure/window) in user.loc)
				user << "<span class='warning'>There is a window in the way.</span>"
				return TRUE
			new created_window( user.loc, SOUTHWEST, 1 )
			src.use(4)
		if("Windoor")
			if(!is_reinforced) return TRUE


			if(!src || src.loc != user) return TRUE

			if(isturf(user.loc) && locate(/obj/structure/windoor_assembly/, user.loc))
				user << "<span class='warning'>There is already a windoor assembly in that location.</span>"
				return TRUE

			if(isturf(user.loc) && locate(/obj/machinery/door/window/, user.loc))
				user << "<span class='warning'>There is already a windoor in that location.</span>"
				return TRUE

			if(src.get_amount() < 5)
				user << "<span class='warning'>You need more glass to do that.</span>"
				return TRUE

			new /obj/structure/windoor_assembly(user.loc, user.dir, 1)
			src.use(5)

	return FALSE


/*
 * Reinforced glass sheets
 */
/obj/item/stack/material/glass/reinforced
	name = "reinforced glass"
	singular_name = "reinforced glass sheet"
	icon_state = "sheet-rglass"
	default_type = "reinforced glass"
	created_window = /obj/structure/window/reinforced
	is_reinforced = 1
	construction_options = list("One Direction", "Full Window", "Windoor")

/*
 * plasma Glass sheets
 */
/obj/item/stack/material/glass/plasmaglass
	name = "plasma glass"
	singular_name = "plasma glass sheet"
	icon_state = "sheet-plasmaglass"
	created_window = /obj/structure/window/plasmabasic
	default_type = "plasma glass"

/obj/item/stack/material/glass/plasmaglass/attackby(obj/item/W, mob/user)
	..()
	if( istype(W, /obj/item/stack/rods) )
		var/obj/item/stack/rods/V  = W
		var/obj/item/stack/material/glass/plasmarglass/RG = new (user.loc)
		RG.add_fingerprint(user)
		RG.add_to_stacks(user)
		V.use(1)
		var/obj/item/stack/material/glass/G = src
		src = null
		var/replace = (user.get_inactive_hand()==G)
		G.use(1)
		if (!G && !RG && replace)
			user.put_in_hands(RG)
	else
		return ..()

/*
 * Reinforced plasma glass sheets
 */
/obj/item/stack/material/glass/plasmarglass
	name = "reinforced plasma glass"
	singular_name = "reinforced plasma glass sheet"
	icon_state = "sheet-plasmarglass"
	default_type = "reinforced plasma glass"
	created_window = /obj/structure/window/plasmareinforced
	is_reinforced = 1
