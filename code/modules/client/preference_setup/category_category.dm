

/**************************
* Category Category Setup *
**************************/

/datum/category_group/player_setup_category
	var/sort_order = 0

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	// Load all data, then sanitize it.
	// Need due to, for example, the 01_basic module relying on species having been loaded to sanitize correctly but that isn't loaded until module 03_body.
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.load_character(S)
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_character()

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_character()
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.load_preferences(S)
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_preferences()

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/pi in items)
		pi.save_preferences(S)

/datum/category_group/player_setup_category/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_item/player_setup_item/pi in items)
		. = . && pi.update_setup(preferences, character)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/halfway = items.len / 2
	for(var/datum/category_item/player_setup_item/pi in items)
		if(halfway && current++ >= halfway)
			halfway = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[pi.content(user)]<br>"
	. += "</td></tr></table>"

/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/pi in items)
		. += "[pi.content(user)]<br>"
