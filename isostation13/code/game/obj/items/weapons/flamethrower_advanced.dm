/obj/item/weapon/flamethrower/advanced
	throw_speed = 2
	throw_range = 8
	w_class = 3.0
	throw_amount = 200
	force = WEAPON_FORCE_PAINFULL * 1.33


/obj/item/weapon/flamethrower/advanced/full/New(var/loc)
	..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	ptank = new /obj/item/weapon/tank/plasma/big
	status = 1
	update_icon()

	return
