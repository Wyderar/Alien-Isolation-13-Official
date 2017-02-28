var/global/list/aspects = list()

/datum/aspect

	proc/begin() //happens at roundstart or later
		return

/datum/aspect/xeno/donors_always_get_WJ()

	begin()
		//change the settings of the WJ antag-tag?

/datum/aspect/xeno/anyone_can_be_WJ()

	begin()
		//change the settings of the WJ antag-tag?

/datum/aspect/xeno/WJs_are_always_rogue()
	var/loyalty = "Command"

	New(new_loyalty)
		..()
		loyalty = new_loyalty

	begin()
		return
