
/obj/structure/closet/secure_closet/ironhammer_raider
	name = "Ironhammer Special Operative locker"
	req_access = list(access_brig)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	New()
		..()

		for (var/i in 1 to 5)
			new/obj/item/weapon/tank/plasma/big(src)

		for (var/i in 1 to 2)
			new/obj/item/weapon/flamethrower/advanced/full(src)
