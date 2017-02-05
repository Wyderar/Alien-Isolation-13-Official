/proc/alien_message(t)
	for (var/mob/m in alien_list)
		m << "<span class = \"alium\">[t]</span>"
