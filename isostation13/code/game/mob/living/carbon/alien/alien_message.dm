/proc/alien_message(t)
	for (var/mob/m in alien_list)
		if (m.client)
			m << "<span class = \"alium\">[t]</span>"
