/mob/living/carbon/proc/Sense_Hive()

	set category = "Abilities"

	src << "<span class = \"alium\">You begin to sense the Hivemind..</span>"
	spawn(10)
		var/n = 0
		for (var/mob/m in alien_list)
			if (m == src)
				continue
			if (!m.client)
				continue
			++n
			switch (m.stat)
				if (DEAD)
					spawn (n * rand(4,5))
						src << "<span class = \"alium\">You sense [m]. They have been slain.</span>"
						alien_list -= m //no need for them anymore
				if (UNCONSCIOUS)
					spawn (n * rand(4,5))
						src << "<span class = \"alium\">You sense [m]. They're unconscious at [get_area(m)]!</span>"
				if (CONSCIOUS)
					spawn (n * rand(4,5))
						src << "<span class = \"alium\">You sense [m]. They're alive and well at [get_area(m)]!</span>"

/proc/alien_message(t)
	for (var/mob/m in alien_list)
		if (m.client)
			if (m.stat == CONSCIOUS)
				m << "<span class = 'alium'>[t]</span>"
			else if (m.stat == UNCONSCIOUS)
				if (prob(50))
					m << "<span class = 'alium'>[t]</span>"
				else
					m << "<span class = 'alium'>You almost hear something over the hivemind...</span>"