#define STAGE_SOURCES  1
#define STAGE_CORNERS  2
#define STAGE_OVERLAYS 3

/datum/controller/process/lighting
	var/list/currentrun_lights
	var/list/currentrun_corners
	var/list/currentrun_overlays
	var/resuming_stage = 0

/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = 10 // every second
	start_delay = 12
	create_all_lighting_overlays()


/datum/controller/process/lighting/doWork()

	if (resuming_stage == 0/* || !resumed*/)
		currentrun_lights   = lighting_update_lights
		lighting_update_lights   = list()

		resuming_stage = STAGE_SOURCES

	while (currentrun_lights.len)
		var/datum/light_source/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if (L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if (!L.destroyed)
				L.apply_lum()

		else if (L.vis_update) //We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

	//	if (MC_TICK_CHECK)
		//	return

	if (resuming_stage == STAGE_SOURCES /*|| !resumed*/)
	//	if (currentrun_corners && currentrun_corners.len)

		currentrun_corners  = lighting_update_corners
		lighting_update_corners  = list()

		resuming_stage = STAGE_CORNERS

	while (currentrun_corners.len)
		var/datum/lighting_corner/C = currentrun_corners[currentrun_corners.len]
		currentrun_corners.len--

		C.update_overlays()
		C.needs_update = FALSE

		//if (MC_TICK_CHECK)
		//	return

	if (resuming_stage == STAGE_CORNERS /*|| !resumed*/)
		currentrun_overlays = lighting_update_overlays
		lighting_update_overlays = list()

		resuming_stage = STAGE_OVERLAYS

	while (currentrun_overlays.len)
		var/atom/movable/lighting_overlay/O = currentrun_overlays[currentrun_overlays.len]
		currentrun_overlays.len--

		O.update_overlay()
		O.needs_update = FALSE
	//	if (MC_TICK_CHECK)
		//	return

	resuming_stage = 0

/datum/controller/process/lighting/statProcess()
	..()
