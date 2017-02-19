
var/datum/partial_hud_1/partial_hud_1 = new()

var/list/partial_hud_1s = list(
		partial_hud_1.darkness)

/datum/partial_hud_1
	var/obj/screen/darkness

/datum/partial_hud_1/proc/setup_overlay(var/icon_state)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/obj/hud_partial_screen_1.dmi'
	screen.icon_state = icon_state
	screen.layer = SCREEN_LAYER
	screen.mouse_opacity = 0

	return screen


/datum/partial_hud_1/New()
	darkness = setup_overlay("darkness")