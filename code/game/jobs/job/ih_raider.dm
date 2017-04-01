/datum/job/ih_raider
	title = "Ironhammer Special Operative"
	flag = ASSISTANT
	department = "Engineering"
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 500
	spawn_positions = 500
	supervisors = "Ironhammer CentComm"
	selection_color = "#ffeeaa"

/datum/job/ih_raider/equip(var/mob/living/carbon/human/H)
	ih_raider.equip(H)
	ih_raider.place_mob(H)
	ih_raider.current_antagonists += H.mind