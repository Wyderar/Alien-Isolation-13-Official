#define Clamp(x, y, z) 	(x <= y ? y : (x >= z ? z : x))
#define CLAMP01(x) 		(Clamp(x, 0, 1))


//MOB LEVEL

#define isatom(A) istype(A, /atom)

#define ismob(A) istype(A, /mob)

#define isobj(A) istype(A, /obj)

#define isitem(A) istype(A, /obj/item)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define isobserver(A) istype(A, /mob/observer)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isEye(A) istype(A, /mob/observer/eye)

#define isnewplayer(A) istype(A, /mob/new_player)

#define hasnoloc(A) (!isatom(A) || A:loc == null)
//++++++++++++++++++++++++++++++++++++++++++++++

#define isliving(A) istype(A, /mob/living)
//---------------------------------------------------

#define iscarbon(A) istype(A, /mob/living/carbon)

#define ishumanoidalien(A) (istype(A, /mob/living/carbon/human) && (istype(A:species, /datum/species/xenos) || (A:species.get_bodytype() == "Xenomorph")))

#define isnonhumanoidalien(A) istype(A, /mob/living/carbon/alien)

#define isalien(A) (ishumanoidalien(A) || isnonhumanoidalien(A))

#define isalienfather(A) (iscarbon(A) && A:alien_embryo != null)

#define isalien_oralienfather(A) (isalien(A) || isalienfather(A))


#define isslime(A) istype(A, /mob/living/carbon/slime)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isworkingjoe(A) (ishuman(A) && istype(A:species, /datum/species/working_joe))

#define issynthetic(A) (ishuman(A) && A:synthetic)
//---------------------------------------------------

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)
//---------------------------------------------------

#define issilicon(A) istype(A, /mob/living/silicon)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)


//---------------------------------------------------


//OBJECT LEVEL
#define isobj(A) istype(A, /obj)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isorgan(A) istype(A, /obj/item/organ/external)




#define islist(A) istype(A, /list)

#define ismovable(A) istype(A, /atom/movable)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

