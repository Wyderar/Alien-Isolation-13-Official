/datum/admins/proc/Game()
	if(!check_rights(FALSE))	return

	var/dat = ""

	if (!config.no_changing_game_mode || check_rights(R_HOST))
		dat = {"
			<center><B>Game Panel</B></center><hr>\n
			<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>
			"}
	else
		dat = {"
			<center><B><i>Changing the game mode is currently disabled.</i></B></center>
			"}
	if(master_mode == "secret")
		dat += "<A href='?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='?src=\ref[src];create_object=1'>Create Object</A><br>
		<A href='?src=\ref[src];quick_create_object=1'>Quick Create Object</A><br>
		<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>
		<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>
		<br><A href='?src=\ref[src];vsc=airflow'>Edit Airflow Settings</A><br>
		<A href='?src=\ref[src];vsc=plasma'>Edit plasma Settings</A><br>
		<A href='?src=\ref[src];vsc=default'>Choose a default ZAS setting</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return
