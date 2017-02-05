/datum/math_pool
	var/list/plot_vectors = list()
	var/list/vector_locs = list()
	var/list/matrices = list()

	New()
		..()
		world << "<b><span style = \"color:red\">Generating pooled datums...</span></b>"
		var/init_time = world.time
		for (var/i in 1 to 100)
			plot_vectors += new/datum/plot_vector()
			vector_locs += new/datum/vector_loc()
			matrices += new/matrix()
		var/finish_time = world.time
		var/total_time = (finish_time - init_time)/10
		world << "<b><span style = \"color:red\">Finished generating pooled datums. Took [total_time] seconds.</span></b>"


	proc/get(t)
		switch (t)
			if ("plot_vector")
				var/x = pick(plot_vectors)
				plot_vectors -= x
				if (x == null)
					x = new/datum/plot_vector()
				spawn (50)
					plot_vectors += new/datum/plot_vector()
				return x
			if ("vector_locs")
				var/x = pick(vector_locs)
				if (x == null)
					x = new/datum/vector_loc()
				vector_locs -= x
				spawn (50)
					vector_locs += new/datum/vector_loc()
				return x
			if ("matrix")
				var/x = pick(matrices)
				matrices -= x
				if (x == null)
					x = new/matrix()
				spawn (50)
					matrices += new/matrix()
				return x