var/global/last_movement_loop = -1

/datum/controller/process/movement/setup()
	name = "movement"
	schedule_interval = 10//fucking flood the PS with pings so we get as many movements through as possible
	//w/o mob.movement_delay() fucking shit up - trying 30 movement attempts/second(vs 200) to improve cpu usage

	//1/3 = 30 seems to be the sweet spot for ghost movement, 5x faster than normal movement
	priority = TRUE

/datum/controller/process/movement/doWork()
	return

/proc/movement_loop()
	set background = 1
	while (TRUE == TRUE)
		last_movement_loop = world.realtime //this is here so that when restarting the loop, it happens immediately
		//and only once
		sleep(1)
		for (var/mob/m in player_list)
			if (m.client && m.client.pressing_move_key == TRUE)
				switch (m.dir)
					if (NORTH)
						m.client.North(1)
					if (SOUTH)
						m.client.South(1)
					if (EAST)
						m.client.East(1)
					if (WEST)
						m.client.West(1)
				m.client.pressing_move_key = FALSE
