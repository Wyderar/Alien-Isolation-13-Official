/atom
	layer = 2
	appearance_flags = TILE_BOUND
	var/level = 2
	var/flags = 0
	var/list/fingerprints
	var/list/fingerprintshidden
	var/fingerprintslast = null
	var/list/blood_DNA
	var/was_bloodied
	var/blood_color
	var/last_bumped = 0
	var/pass_flags = 0
	var/throwpass = 0
	var/germ_level = GERM_LEVEL_AMBIENT // The higher the germ level, the more germ on the atom.
	var/simulated = 1 //filter for actions - used by lighting overlays
	var/fluorescent // Shows up under a UV light.
	var/allow_spin = 1

	///Chemistry.
	var/datum/reagents/reagents = null

	//var/chem_is_open_container = 0
	// replaced by OPENCONTAINER flags and atom/proc/is_open_container()
	///Chemistry.

	//Detective Work, used for the duplicate data points kept in the scanners
	var/list/original_atom

/atom/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	. = ..()

/atom/proc/find_nearest_vent()
	for (var/obj/somevent in vent_list)//search for any vent in the range of 7,7
		if (square_dist(somevent, src) <= 7)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 10,10
		if (square_dist(somevent, src) <= 10)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 15,15
		if (square_dist(somevent, src) <= 15)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 20,20
		if (square_dist(somevent, src) <= 20)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 27,27 - beyond this is too much
		if (square_dist(somevent, src) <= 30)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 27,27 - beyond this is too much
		if (square_dist(somevent, src) <= 50)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 27,27 - beyond this is too much
		if (square_dist(somevent, src) <= 100)
			return somevent

	for (var/obj/somevent in vent_list)//search for any vent in the range of 27,27 - beyond this is too much
		if (square_dist(somevent, src) <= 1000)
			return somevent

	return pick(vent_list) //give them a random vent kek

/atom/proc/make_sound(severity)
	if (!severity)
		severity = SOUND_SMALL
	var/zs_to_search = list()
	var/rx = INFINITY
	var/ry = INFINITY

	switch (severity)
		if (SOUND_SMALL)//maybe a bit to quite a bit dangerous, possibly harmless
			zs_to_search = list(0)
			rx = rand(1,50)
			ry = rand(1,50)
		if (SOUND_MEDIUM)//quite dangerous unless you're really high up
			zs_to_search = pick(list(0), list(-1,0,1))
			rx = rand(51,100)
			ry = rand(51,100)
		if (SOUND_LOUD)//very, very dangerous unless you're really far away
			zs_to_search = list(-1,0,1)

	if (rx != INFINITY && ry != INFINITY)
		for (var/mob/living/carbon/human/H in alien_list)
			if (istype(H) && H.client)
				if (get_area(src) == "Ironhammer Special Operatives Base")
					if (get_area(H) != "Ironhammer Special Operatives Base")
						continue
				for (var/z2 in zs_to_search)
					if ((H.z+z2) == z)
						if (abs(H.x - x) <= rx)
							if (abs(H.y - y) <= ry)
								var/datum/species/xenos/x = H.species
								if (x && istype(x)) x.alerted(src, H)

	else
		for (var/mob/living/carbon/human/H in alien_list)
			if (istype(H) && H.client)
				if (get_area(src) == "Ironhammer Special Operatives Base")
					if (get_area(H) != "Ironhammer Special Operatives Base")
						continue
				for (var/z2 in zs_to_search)
					if ((H.z+z2) == z)
						var/datum/species/xenos/x = H.species
						if (x && istype(x)) x.alerted(src, H)

	return TRUE

/atom/proc/reveal_blood()
	return

/atom/proc/assume_air(datum/gas_mixture/giver)
	return null

/atom/proc/remove_air(amount)
	return null

/atom/proc/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

//return flags that should be added to the viewer's sight var.
//Otherwise return a negative number to indicate that the view should be cancelled.
/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai)) // WHYYYY
		return 0
	return -1

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

// Convenience proc to see if a container is open for chemistry handling
// returns true if open
// false if closed
/atom/proc/is_open_container()
	return flags & OPENCONTAINER

/*//Convenience proc to see whether a container can be accessed in a certain way.

	proc/can_subract_container()
		return flags & EXTRACT_CONTAINER

	proc/can_add_container()
		return flags & INSERT_CONTAINER
*/

/atom/proc/CheckExit()
	return 1

// If you want to use this, the atom must have the PROXMOVE flag, and the moving
// atom must also have the PROXMOVE flag currently to help with lag. ~ ComicIronic
/atom/proc/HasProximity(atom/movable/AM as mob|obj)
	return

/atom/proc/emp_act(var/severity)
	return


/atom/proc/bullet_act(obj/item/projectile/P, def_zone)
	P.on_hit(src, 0, def_zone)
	. = 0

/atom/proc/in_contents_of(container)//can take class or object instance as argument
	if(ispath(container))
		if(istype(src.loc, container))
			return 1
	else if(src in container)
		return 1
	return

/*
 *	atom/proc/search_contents_for(path,list/filter_path=null)
 * Recursevly searches all atom contens (including contents contents and so on).
 *
 * ARGS: path - search atom contents for atoms of this type
 *	   list/filter_path - if set, contents of atoms not of types in this list are excluded from search.
 *
 * RETURNS: list of found atoms
 */

/atom/proc/search_contents_for(path,list/filter_path=null)
	var/list/found = list()
	for(var/atom/A in src)
		if(istype(A, path))
			found += A
		if(filter_path)
			var/pass = 0
			for(var/type in filter_path)
				pass |= istype(A, type)
			if(!pass)
				continue
		if(A.contents.len)
			found += A.search_contents_for(path,filter_path)
	return found




/*
Beam code by Gunbuddy

Beam() proc will only allow one beam to come from a source at a time.  Attempting to call it more than
once at a time per source will cause graphical errors.
Also, the icon used for the beam will have to be vertical and 32x32.
The math involved assumes that the icon is vertical to begin with so unless you want to adjust the math,
its easier to just keep the beam vertical.
*/
/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=50, maxdistance=10)
	//BeamTarget represents the target for the beam, basically just means the other end.
	//Time is the duration to draw the beam
	//Icon is obviously which icon to use for the beam, default is beam.dmi
	//Icon_state is what icon state is used. Default is b_beam which is a blue beam.
	//Maxdistance is the longest range the beam will persist before it gives up.
	var/EndTime=world.time+time
	while(BeamTarget&&world.time<EndTime&&get_dist(src,BeamTarget)<maxdistance&&z==BeamTarget.z)
	//If the BeamTarget gets deleted, the time expires, or the BeamTarget gets out
	//of range or to another z-level, then the beam will stop.  Otherwise it will
	//continue to draw.

		set_dir(get_dir(src,BeamTarget))	//Causes the source of the beam to rotate to continuosly face the BeamTarget.

		for(var/obj/effect/overlay/beam/O in orange(10,src))	//This section erases the previously drawn beam because I found it was easier to
			if(O.BeamSource==src)				//just draw another instance of the beam instead of trying to manipulate all the
				qdel(O)							//pieces to a new orientation.
		var/Angle=round(Get_Angle(src,BeamTarget))
		var/icon/I=new(icon,icon_state)
		I.Turn(Angle)
		var/DX=(32*BeamTarget.x+BeamTarget.pixel_x)-(32*x+pixel_x)
		var/DY=(32*BeamTarget.y+BeamTarget.pixel_y)-(32*y+pixel_y)
		var/N=0
		var/length=round(sqrt((DX)**2+(DY)**2))
		for(N,N<length,N+=32)
			var/obj/effect/overlay/beam/X=new(loc)
			X.BeamSource=src
			if(N+32>length)
				var/icon/II=new(icon,icon_state)
				II.DrawBox(null,1,(length-N),32,32)
				II.Turn(Angle)
				X.icon=II
			else X.icon=I
			var/Pixel_x=round(sin(Angle)+32*sin(Angle)*(N+16)/32)
			var/Pixel_y=round(cos(Angle)+32*cos(Angle)*(N+16)/32)
			if(DX==0) Pixel_x=0
			if(DY==0) Pixel_y=0
			if(Pixel_x>32)
				for(var/a=0, a<=Pixel_x,a+=32)
					X.x++
					Pixel_x-=32
			if(Pixel_x<-32)
				for(var/a=0, a>=Pixel_x,a-=32)
					X.x--
					Pixel_x+=32
			if(Pixel_y>32)
				for(var/a=0, a<=Pixel_y,a+=32)
					X.y++
					Pixel_y-=32
			if(Pixel_y<-32)
				for(var/a=0, a>=Pixel_y,a-=32)
					X.y--
					Pixel_y+=32
			X.pixel_x=Pixel_x
			X.pixel_y=Pixel_y
		sleep(3)	//Changing this to a lower value will cause the beam to follow more smoothly with movement, but it will also be more laggy.
					//I've found that 3 ticks provided a nice balance for my use.
	for(var/obj/effect/overlay/beam/O in orange(10,src)) if(O.BeamSource==src) qdel(O)


//All atoms
/atom/proc/examine(mob/user, var/distance = -1, var/infix = "", var/suffix = "")
	//This reformat names to get a/an properly working on item descriptions when they are bloody
	var/f_name = "\a [src][infix]."
	if(src.blood_DNA && !istype(src, /obj/effect/decal))
		if(gender == PLURAL)
			f_name = "some "
		else
			f_name = "a "
		if(blood_color != "#030303")
			f_name += "<span class='danger'>blood-stained</span> [name][infix]!"
		else
			f_name += "oil-stained [name][infix]."

	user.visible_message("<font size=1>[user.name] looks at [src].</font>")
	user << "\icon[src] That's [f_name] [suffix]"
	user << desc

	return distance == -1 || (get_dist(src, user) <= distance)

// called by mobs when e.g. having the atom as their machine, pulledby, loc (AKA mob being inside the atom) or buckled var set.
// see code/modules/mob/mob_movement.dm for more.
/atom/proc/relaymove()
	return

//called to set the atom's dir and used to add behaviour to dir-changes
/atom/proc/set_dir(new_dir)
	var/old_dir = dir
	if(new_dir == old_dir)
		return FALSE

	dir = new_dir
	dir_set_event.raise_event(src, old_dir, new_dir)
	return TRUE

/atom/proc/ex_act()
	return

/atom/proc/emag_act(var/remaining_charges, var/mob/user, var/emag_source)
	return NO_EMAG_ACT

/atom/proc/fire_act()
	return

/atom/proc/melt()
	return

/atom/proc/hitby(atom/movable/AM as mob|obj)
	if (density)
		AM.throwing = 0
	return

/atom/proc/add_hiddenprint(mob/living/M as mob)
	if(isnull(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna))
			return 0
		if (H.gloves)
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] (Wearing gloves). Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 0
		if (!( src.fingerprints ))
			if(src.fingerprintslast != H.key)
				src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",H.real_name, H.key)
				src.fingerprintslast = H.key
			return 1
	else
		if(src.fingerprintslast != M.key)
			src.fingerprintshidden += text("\[[time_stamp()]\] Real name: [], Key: []",M.real_name, M.key)
			src.fingerprintslast = M.key
	return

/atom/proc/add_fingerprint(mob/living/M as mob, ignoregloves = 0)
	if(isnull(M)) return
	if(isAI(M)) return
	if(isnull(M.key)) return
	if (ishuman(M))
		//Add the list if it does not exist.
		if(!fingerprintshidden)
			fingerprintshidden = list()

		//Fibers~
		add_fibers(M)

		//He has no prints!
		if (mFingerprints in M.mutations)
			if(fingerprintslast != M.key)
				fingerprintshidden += "(Has no fingerprints) Real name: [M.real_name], Key: [M.key]"
				fingerprintslast = M.key
			return 0		//Now, lets get to the dirty work.
		//First, make sure their DNA makes sense.
		var/mob/living/carbon/human/H = M
		if (!istype(H.dna, /datum/dna) || !H.dna.uni_identity || (length(H.dna.uni_identity) != 32))
			if(!istype(H.dna, /datum/dna))
				H.dna = new /datum/dna(null)
				H.dna.real_name = H.real_name
		H.check_dna()

		//Now, deal with gloves.
		if (H.gloves && H.gloves != src)
			if(fingerprintslast != H.key)
				fingerprintshidden += text("\[[]\](Wearing gloves). Real name: [], Key: []",time_stamp(), H.real_name, H.key)
				fingerprintslast = H.key
			H.gloves.add_fingerprint(M)

		//Deal with gloves the pass finger/palm prints.
		if(!ignoregloves)
			if(H.gloves != src)
				if(prob(75) && istype(H.gloves, /obj/item/clothing/gloves/latex))
					return 0
				else if(H.gloves && !istype(H.gloves, /obj/item/clothing/gloves/latex))
					return 0

		//More adminstuffz
		if(fingerprintslast != H.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), H.real_name, H.key)
			fingerprintslast = H.key

		//Make the list if it does not exist.
		if(!fingerprints)
			fingerprints = list()

		//Hash this shit.
		var/full_print = H.get_full_print()

		// Add the fingerprints
		//
		if(fingerprints[full_print])
			switch(stringpercent(fingerprints[full_print]))		//tells us how many stars are in the current prints.

				if(28 to 32)
					if(prob(1))
						fingerprints[full_print] = full_print 		// You rolled a one buddy.
					else
						fingerprints[full_print] = stars(full_print, rand(0,40)) // 24 to 32

				if(24 to 27)
					if(prob(3))
						fingerprints[full_print] = full_print     	//Sucks to be you.
					else
						fingerprints[full_print] = stars(full_print, rand(15, 55)) // 20 to 29

				if(20 to 23)
					if(prob(5))
						fingerprints[full_print] = full_print		//Had a good run didn't ya.
					else
						fingerprints[full_print] = stars(full_print, rand(30, 70)) // 15 to 25

				if(16 to 19)
					if(prob(5))
						fingerprints[full_print] = full_print		//Welp.
					else
						fingerprints[full_print]  = stars(full_print, rand(40, 100))  // 0 to 21

				if(0 to 15)
					if(prob(5))
						fingerprints[full_print] = stars(full_print, rand(0,50)) 	// small chance you can smudge.
					else
						fingerprints[full_print] = full_print

		else
			fingerprints[full_print] = stars(full_print, rand(0, 20))	//Initial touch, not leaving much evidence the first time.


		return 1
	else
		//Smudge up dem prints some
		if(fingerprintslast != M.key)
			fingerprintshidden += text("\[[]\]Real name: [], Key: []",time_stamp(), M.real_name, M.key)
			fingerprintslast = M.key

	//Cleaning up shit.
	if(fingerprints && !fingerprints.len)
		qdel(fingerprints)
	return


/atom/proc/transfer_fingerprints_to(var/atom/A)

	if(!istype(A.fingerprints,/list))
		A.fingerprints = list()

	if(!istype(A.fingerprintshidden,/list))
		A.fingerprintshidden = list()

	if(!istype(fingerprintshidden, /list))
		fingerprintshidden = list()

	//skytodo
	//A.fingerprints |= fingerprints            //detective
	//A.fingerprintshidden |= fingerprintshidden    //admin
	if(A.fingerprints && fingerprints)
		A.fingerprints |= fingerprints.Copy()            //detective
	if(A.fingerprintshidden && fingerprintshidden)
		A.fingerprintshidden |= fingerprintshidden.Copy()    //admin	A.fingerprintslast = fingerprintslast


//returns 1 if made bloody, returns 0 otherwise
/atom/proc/add_blood(mob/living/carbon/human/M as mob)

	if(flags & NOBLOODY)
		return 0

	if(!blood_DNA || !istype(blood_DNA, /list))	//if our list of DNA doesn't exist yet (or isn't a list) initialise it.
		blood_DNA = list()

	was_bloodied = 1
	blood_color = "#A10808"
	if(istype(M))
		if (!istype(M.dna, /datum/dna))
			M.dna = new /datum/dna(null)
			M.dna.real_name = M.real_name
		M.check_dna()
		if (M.species)
			blood_color = M.species.blood_color
	. = 1
	return 1

/atom/proc/add_vomit_floor(mob/living/carbon/M as mob, var/toxvomit = 0)
	if( istype(src, /turf/simulated) )
		var/obj/effect/decal/cleanable/vomit/this = new /obj/effect/decal/cleanable/vomit(src)

		// Make toxins vomit look different
		if(toxvomit)
			this.icon_state = "vomittox_[pick(1,4)]"

/atom/proc/clean_blood()
	if(!simulated)
		return
	fluorescent = 0
	src.germ_level = 0
	if(istype(blood_DNA, /list))
		blood_DNA = null
		return 1

/atom/proc/get_global_map_pos()
	if(!islist(global_map) || isemptylist(global_map)) return
	var/cur_x = null
	var/cur_y = null
	var/list/y_arr = null
	for(cur_x=1,cur_x<=global_map.len,cur_x++)
		y_arr = global_map[cur_x]
		cur_y = y_arr.Find(src.z)
		if(cur_y)
			break
//	world << "X = [cur_x]; Y = [cur_y]"
	if(cur_x && cur_y)
		return list("x"=cur_x,"y"=cur_y)
	else
		return 0

/atom/proc/checkpass(passflag)
	return pass_flags&passflag

/atom/proc/isinspace()
	if(istype(get_turf(src), /turf/space))
		return 1
	else
		return 0

// Show a message to all mobs and objects in sight of this atom
// Use for objects performing visible actions
// message is output to anyone who can see, e.g. "The [src] does something!"
// blind_message (optional) is what blind people will hear e.g. "You hear something!"
/atom/proc/visible_message(var/message, var/blind_message)

	var/list/see = get_mobs_or_objects_in_view(world.view,src) | viewers(get_turf(src), null)

	for(var/I in see)
		if(isobj(I))
			spawn(0)
				if(I) //It's possible that it could be deleted in the meantime.
					var/obj/O = I
					O.show_message( message, 1, blind_message, 2)
		else if(ismob(I))
			var/mob/M = I
			if(M.see_invisible >= invisibility) // Cannot view the invisible
				M.show_message( message, 1, blind_message, 2)
			else if (blind_message)
				M.show_message(blind_message, 2)

// Show a message to all mobs and objects in earshot of this atom
// Use for objects performing audible actions
// message is the message output to anyone who can hear.
// deaf_message (optional) is what deaf people will see.
// hearing_distance (optional) is the range, how many tiles away the message can be heard.
/atom/proc/audible_message(var/message, var/deaf_message, var/hearing_distance)

	var/range = world.view
	if(hearing_distance)
		range = hearing_distance
	var/list/hear = get_mobs_or_objects_in_view(range,src)

	for(var/I in hear)
		if(isobj(I))
			spawn(0)
				if(I) //It's possible that it could be deleted in the meantime.
					var/obj/O = I
					O.show_message( message, 2, deaf_message, 1)
		else if(ismob(I))
			var/mob/M = I
			M.show_message( message, 2, deaf_message, 1)

/atom/Entered(var/atom/movable/AM, var/atom/old_loc, var/special_event)
	if(loc && MOVED_DROP == special_event)
		AM.forceMove(loc, MOVED_DROP)
		return CANCEL_MOVE_EVENT
	return ..()

/turf/Entered(var/atom/movable/AM, var/atom/old_loc, var/special_event)
	return ..(AM, old_loc, 0)

/*

UpdateOverlays(), from goon, for goonwalls(walls_goon.dm)



*/






/*
!! IMPORTANT NOTE !!

If this is used to handle overlays on an atom then all overlay updates on that atom *MUST* be carried out through this proc.
Failure to do so will cause the list the proc uses to keep track of the overlays to desynchronize with the actual overlays, leading to runtime errors and strange behaviour.
(Ex. Removing the head of a human instead of the glasses they are wearing)

!! UNIMPORTANT NOTE !!

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Usage:	UpdateOverlays(var/image/I, var/key, var/force=0, var/retain_cache = 0)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Handles updating existing overlays, removing existing overlays and adding new overlays

I				=	image that you want to add to the atom's overlays (null to clear)
key				=	which "slot" do you want the image to go in
force			=	Don't care if there is an existing image with the same details, update anyway. Can be useful if the image to be added is a composite with several overlays of its own.
retain_cache	=	Does not clear the overlay entry at the same time as clearing the overlay - this retains the image in a retrievable form

Returns 1 on updating an overlay, 0 otherwise

------------------------------------------------------
//Ex.

var/atom/A = new
var/image/ass = image('butt.dmi', "posterior")

A.UpdateOverlays(ass, "hat") 		//Puts the 'ass' image in the slot defined as "hat"
A.UpdateOverlays(ass, "hat") 		//This will check the existing overlay in the "hat" slot and reject the update
ass.icon_state = "hindquarters" 	//Icon state change
A.UpdateOverlays(ass, "hat") 		//This will detect the change and update the overlay accordingly

A.UpdateOverlays(null, "hat")		 //Removes the overlay assigned to the "hat" slot, along with the cached image
//Alt.
A.UpdateOverlays(null, "hat",0,1) 	//Removes the overlay in the "hat" slot, but retains the cached image for retrieval with GetOverlayImage

-------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Usage:	ClearAllOverlays(var/retain_cache=0)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes all overlays on an atom

retain_cache	=	Does not clear the overlay entry at the same time as clearing the overlay - this retains the image in a retrievable form

Returns 1 if overlays were cleared, null otherwise
------------------------------------------------------
//Ex.

var/atom/A = new
A.ClearOverlays() 	//Removes all overlays on A
A.ClearOverlays(1) //Removes all overlays on A but retains the cached images
------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Usage:	GetOverlayImage(var/key)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gets the image stored in cache for the specified overlay slot

key		=	The slot in which the desired image is stored

Returns the specified image, if one exists, null otherwise
------------------------------------------------------
//Ex.
//We have an atom A, having an overlay named "hat"
var/image/I = A.GetOverlayImage("hat") 	//Retrieve the cached image in the hat slot
if(!I) I = image('file', "chapeau") 	//Not in-scope, but as GetOverlayImage can return null it's good practice to ensure you got an image before doing things to the returned value
I.icon_state = "chapeau"				//Change the icon state of it
A.UpdateOverlays(I, "hat")				//Update the overlay with the changes
------------------------------------------------------


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Usage:	SafeGetOverlayImage(var/key, var/image_file as file, var/icon_state as text, var/layer as num|null)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Gets the image stored in cache for the specified overlay slot and sets it's icon_state to the desired one, or creates a new one from the image_file and icon_state

key			=	The slot in which the desired image is stored
image_file	=	The file to create the new image
icon_state	=	The desired icon_state
layer		=	The layer the image should be in

Returns the specified image with modifications according to the input, if one exists, otherwise it creates a new one and returns that
------------------------------------------------------
//Ex.
//We have an atom A, that may or may not have an overlay named "hat"
var/image/I = A.GetOverlayImage("hat", 'obj/item/hats.dmi', "ushanka")
//Retrieve the cached image in the hat slot and sets the icon_state to ushanka or creates a new one using image('obj/item/hats.dmi', "ushanka")
------------------------------------------------------

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Usage:	ClearSpecificOverlays(var/retain_cache=0)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Takes a parameter list of overlay keys, then clears the target overlays. If the first parameter is a number it is used to set the cache.

retain_cache	=	Does not clear the overlay entry at the same time as clearing the overlay - this retains the image in a retrievable form (optional)

Returns a tally of the cleared overlays

------------------------------------------------------
//Ex.

ClearSpecificOverlays("key0", "key1", "key2") 		//Clears the overlays in slots key0, key1 and key2. Does not retain cached images.
ClearSpecificOverlays(0, "key0", "key1", "key2") 	//Same as above
ClearSpecificOverlays(1, "key0", "key1", "key2") 	//Same as above but retains cached images

------------------------------------------------------

*/

#define P_INDEX 1
#define P_IMAGE 2
#define P_ISTATE 3

/atom/var/list/overlay_refs = list()

/atom/proc/UpdateOverlays(var/image/I, var/key, var/force=0, var/retain_cache = 0)
	if(!key)
		CRASH("UpdateOverlays called without a key.")

	var/list/prev_data
	//List to store info about the last state of the icon
	prev_data = overlay_refs[key]
	if(!prev_data && I) //Ok, we don't have previous data, but we will add an overlay
		prev_data = list()
		prev_data.len = 3
	else if(!prev_data) //We don't have data and we won't add an overlay
		return 0

	var/hash = hash_image(I)
	var/image/prev_overlay = prev_data[P_IMAGE] //overlay_refs[key]
	if(!force && (prev_overlay == I) && hash == prev_data[P_ISTATE] ) //If it's the same image as the other one and the hashes match then do not update
		return 0

	var/index = prev_data[P_INDEX]
	if(index > 0) //There is an existing overlay in place in this slot, remove it
		src.overlays.Cut(index, index+1) //Fuck yoooou byond (this gotta be by index or it'll fail if the same thing's in overlays several times)
		prev_data[P_INDEX] = 0
		for(var/ikey in overlay_refs) //Because we're storing the position of each overlay in the list we need to shift our indices down to stay synched
			var/list/L = overlay_refs[ikey]
			if(!isnull(L) && L.len > 0 && L[P_INDEX] >= index) L[P_INDEX]--

	if(I)
		src.overlays += I
		index = src.overlays.len
		prev_data[P_INDEX] = index

		prev_data[P_IMAGE] = I
		prev_data[P_ISTATE] = hash//I.icon_state

		overlay_refs[key] = prev_data
	else
		if(retain_cache) //Keep the cached image available?
			prev_data[P_INDEX] = 0	//Clear the index
			prev_data[P_ISTATE] = 0	//Clear the hash

			//overlay_refs[key] = prev_data //Update our list <- Pointers, dumbass /Spy
		else
			overlay_refs -= key
	return 1

/atom/proc/ClearAllOverlays(var/retain_cache=0) //Some men just want to watch the world burn
	if(src.overlays.len)
		src.overlays.Cut()
		if(retain_cache)
			for(var/key in src.overlay_refs)
				var/list/pd = overlay_refs[key]
				pd[P_INDEX] = 0
				pd[P_ISTATE] = 0
				overlay_refs[key] = pd
		else
			src.overlay_refs.Cut()
		return 1

/atom/proc/ClearSpecificOverlays(var/retain_cache=0)
	var/tally = 0
	var/keep_cache = isnum(retain_cache) && retain_cache //Maybe someone forgets to include this argument and goes straight for the list, let's handle that case
	for(var/key in args)
		if(istext(key)) //The retain_cache value will be here as well, so skip it
			tally += src.UpdateOverlays(null, key, 0, keep_cache)
	return tally


/atom/proc/GetOverlayImage(var/key)
	//Never rely on this proc returning an image.
	var/list/ov_data = overlay_refs[key]

	if(ov_data)
		. = ov_data[P_IMAGE]
	else
		. = null

/atom/proc/SafeGetOverlayImage(var/key, var/image_file as file, var/icon_state as text, var/layer as num|null)
	var/image/I = GetOverlayImage(key)
	if(!I)
		I = image(image_file, icon_state, layer)
	else
		//Ok, apparently modifying anything pertaining to the image appearance causes a hubbub, thanks byand
		if(I.icon != image_file)
			I.icon = image_file

		if(icon_state != I.icon_state)
			I.icon_state = icon_state

		if(layer && layer != I.layer)
			I.layer = layer
	return I

/////////////////////////////////////////////
//helper procs
/////////////////////////////////////////////
/proc/hash_image(var/image/I)
	if(I)
		. = md5("\ref[I][I.icon_state][I.overlays ? I.overlays.len : 0][I.color][I.alpha]")
	else
		. = null


#undef P_INDEX
#undef P_IMAGE
#undef P_ISTATE