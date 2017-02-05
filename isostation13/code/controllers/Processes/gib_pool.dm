/datum/gib_pool
	var/list/gibs = list()

	New()
		..()
		world << "<b><span style = \"color:red\">Generating pooled gibs...</span></b>"
		var/init_time = world.time
		for (var/i in 1 to 100)
			gibs += new/()

		var/finish_time = world.time
		var/total_time = (finish_time - init_time)/10
		world << "<b><span style = \"color:red\">Finished generating pooled gibs. Took [total_time] seconds.</span></b>"


	proc/get()

		var/x = pick(gibs)
		gibs -= x
		if (x == null)
			x = new/mob/livi()
		spawn (50)
			humans += new/mob/living/carbon/human()