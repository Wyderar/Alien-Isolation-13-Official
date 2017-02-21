var/global/list/aspects = list()

/datum/aspect
	var/datum/game_mode/assigned_mode = null


	New(mode)
		..()
		assigned_mode = mode
		global.aspects += src

	proc/begin()
		return

/datum/aspect/xeno/rogue_command

	New(mode)
		if (istype(mode, /datum/game_mode/xeno))
			..(mode)
		else
			qdel(src)

	begin()
		for (var/mob/living/carbon/human/H in player_list)
			if (H.client && H.stat == CONSCIOUS)
				if (H.mind.assigned_role in command_positions)
					return //to be continued
