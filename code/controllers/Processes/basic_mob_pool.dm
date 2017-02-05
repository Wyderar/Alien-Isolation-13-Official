/datum/basic_mob_pool
	var/list/humans = list()
	var/list/alien_larvae = list()

	New()
		..()
		world << "<b><span style = \"color:red\">Generating pooled mobs...</span></b>"
		var/init_time = world.time
		for (var/i in 1 to 100)
			humans += new/mob/living/carbon/human()
			alien_larvae += new/mob/living/carbon/alien/larva()

		var/finish_time = world.time
		var/total_time = (finish_time - init_time)/10
		world << "<b><span style = \"color:red\">Finished generating pooled mobs. Took [total_time] seconds.</span></b>"

	proc/culled_mobs()
		var/list/l = list()

		for (var/mob/m in mob_list)
			if (!humans.Find(m) && !alien_larvae.Find(m))
				l += m

		return l

	proc/find(mob)
		if (humans.Find(mob) || alien_larvae.Find(mob))
			return TRUE
		return FALSE

	proc/get(t)
		switch (t)
			if ("human")
				var/x = pick(humans)
				humans -= x
				if (x == null)
					x = new/mob/living/carbon/human()
				spawn (50)
					humans += new/mob/living/carbon/human()
				return x
			if ("alien_larva", "larva", "alien")
				var/x = pick(alien_larvae)
				if (x == null)
					x = new/mob/living/carbon/alien/larva()
				alien_larvae -= x
				spawn (50)
					alien_larvae += new/mob/living/carbon/alien/larva()
				return x