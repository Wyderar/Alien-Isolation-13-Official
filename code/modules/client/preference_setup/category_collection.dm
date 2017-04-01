/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(S)

/datum/category_collection/player_setup_collection/proc/save_character(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(S)

/datum/category_collection/player_setup_collection/proc/load_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(S)

/datum/category_collection/player_setup_collection/proc/save_preferences(var/savefile/S)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(S)

/datum/category_collection/player_setup_collection/proc/update_setup(var/savefile/preferences, var/savefile/character)
	for(var/datum/category_group/player_setup_category/PS in categories)
		. = . && PS.update_setup(preferences, character)

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && category in categories)
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.ShowChoices(user)
