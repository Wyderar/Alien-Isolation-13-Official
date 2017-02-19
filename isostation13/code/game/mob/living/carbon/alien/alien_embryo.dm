/mob/living/carbon/proc/alien_infected()
	var/x = new/obj/item/organ/alien_embryo(src)
	alien_embryo = x
	if (ishuman(src))
		var/mob/living/carbon/human/H = src
		H.internal_organs_by_name["alien_embryo"] = x


/obj/item/organ/alien_embryo/New()
	..()
	processing_objects += src

/obj/item/organ/alien_embryo/Destroy()
	processing_objects -= src
	..()

/obj/item/organ/alien_embryo
	var/mob/living/carbon/holder = null
	var/ticks = 0//should be about equivalent to seconds

	New(var/mob/h)
		..()
		holder = h

	process()
		if (!holder)
			qdel(src)
			return
		if (ishuman(holder))
			var/mob/living/carbon/human/H = holder
			if (H.internal_organs_by_name["alien_embryo"] != src)
				qdel(src)
				return

		++ticks

		if (prob(5 + (ticks/50) ) )
			holder.emote(pick("shiver", "twitch", "cry", "sigh"), forced = 1)

		if (prob(5) && ticks > 100)
			holder.emote("gasp", forced = 1)

		switch (ticks)
			if (1 to 30)
				if (prob(ticks) && prob(ticks))
					holder << "<span style = \"warning\">Your stomach hurts.</span>"

			if (31)
				holder << "<span style = \"warning\">Your stomach hurts.</span>"

			if (32 to 60)
				if (prob(ticks) && prob(ticks) && prob(ticks))
					holder.adjustToxLoss(1)
					holder << "<span style = \"warning\">There's a burning sensation in your stomach.</span>"

					if (prob(20))
						holder.SetWeakened(5)
						holder.emote("faint", forced = 1)

			if (61 to 120)
				if (prob(2))
					holder.emote("scream", forced = 1)
					holder.SetWeakened(5)
					holder << "<span style = \"danger\">Your insides hurt like [pick("HELL", "FUCK")]!</span>"

			if (121 to 180)
				if (holder.stat == 2)//we can burst while dead at later stages though
					qdel(src)
					return

				if (prob(1))
					holder.emote("scream", forced = 1)
					holder.SetWeakened(5)
					holder << "<span style = \"danger\">Your insides hurt like [pick("HELL", "FUCK")]!</span>"
				if (prob(2))
					if (holder.make_ghost_larva())
						qdel(src)
						return
					else
						if (prob(10))
							qdel(src)
							return
						else if (prob(5))
							holder.gib()
							qdel(src)
							return

			if (181 to 500)
				if (prob(3))
					if (holder.make_ghost_larva())
						qdel(src)
						return
					else
						if (prob(10))
							qdel(src)
							return
						else if (prob(5))
							holder.gib()
							qdel(src)
							return

			if (501 to INFINITY)
				if (prob(30))
					if (holder.make_ghost_larva())
						qdel(src)
						return
					else
						if (prob(10))
							qdel(src)
							return
						else if (prob(5))
							holder.gib()
							qdel(src)
							return