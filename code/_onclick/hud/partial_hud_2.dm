
var/datum/partial_hud_2/partial_hud_2 = new()

var/list/partial_hud_2s = list(
		partial_hud_2.infrared)

/datum/partial_hud_2
	var/obj/screen/infrared

/datum/partial_hud_2/proc/setup_overlay(var/icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/obj/hud_partial_screen_2.dmi'
	screen.icon_state = icon_state
	screen.layer = SCREEN_LAYER
	screen.mouse_opacity = 0

	return screen


/datum/partial_hud_2/New()
	infrared = setup_overlay("infrared")