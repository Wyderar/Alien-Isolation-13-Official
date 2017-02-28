/obj/item/weapon/flamethrower/advanced
	throw_speed = 2
	throw_range = 7
	w_class = 3.0
	throw_amount = 500


/obj/item/weapon/flamethrower/advanced/full/New(var/loc)
	..()
	weldtool = new /obj/item/weapon/weldingtool(src)
	weldtool.status = 0
	igniter = new /obj/item/device/assembly/igniter(src)
	igniter.secured = 0
	status = 1
	update_icon()
	return
