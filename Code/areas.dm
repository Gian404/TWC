/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
world
	//map_format=TILED_ICON_MAP


teleportNode
	var
		list/nodes
		list/areas
		name
		active = FALSE

	proc
		AdjacentNodes()
			return nodes
		Distance(teleportNode/t)
			return 1

		Entered(atom/movable/Obj)
			if(active) return

			active = TRUE
			for(var/area/newareas/a in areas)
				for(var/mob/NPC/Enemies/M in a)
					if(M.state == M.INACTIVE)
						M.ChangeState(M.WANDER)

		Exited(atom/movable/Obj)
			if(!active) return

			var/isempty = 1
			for(var/area/newareas/a in areas)
				for(var/mob/Player/M in a)
					if(M != Obj)
						isempty = 0
						break
				if(!isempty) break
			if(isempty)
				active = FALSE
				for(var/area/newareas/a in areas)
					for(var/mob/NPC/Enemies/M in a)
						M.ChangeState(M.INACTIVE)


area
	Entered(atom/movable/O, atom/oldloc)
		.=..()
		if(isplayer(O))
			var/area/a
			if(oldloc && isturf(oldloc)) a = oldloc.loc

			if(a && a != src &&  a.region)
				if(!(src in a.region.areas))
					if(region)
						region.Entered(O)
					a.region.Exited(O)
			else if(region)
				region.Entered(O)

proc
	AccessibleAreas(turf/t)
		var/ret[] = block(locate(max(t.x-1,1),max(t.y-1,1),t.z),locate(min(t.x+1,world.maxx),min(t.y+1,world.maxy),t.z)) - t
		for(var/turf/i in ret)
			if(i.density || istype(i, /turf/blankturf) || (locate(/obj/teleport) in i))
				ret -= i

			else
				var/area/a = i.loc
				if(a.name == "area" || a.name == "hogwarts")
					ret -= i
		return ret

teleportMap
	var/list/teleports

	proc/init()
		var/count = 0
		teleports = list()

		var/list/teleportPaths = list()

		for(var/obj/teleportPath/p in world)
			teleportPaths += p

		while(teleportPaths.len > 0)

			var/obj/teleportPath/path = teleportPaths[1]
			teleportPaths -= path

			var/teleportNode/node = new
			node.name = "[++count]"

			node.nodes = list()
			node.areas = list()

			var/Region/r = new(path.loc, /proc/AccessibleAreas)
			for(var/turf/t in r.contents)
				var/area/a = t.loc
				a.region = node

				if(!(a in node.areas)) node.areas += a

				var/obj/teleportPath/p = locate() in t
				if(p)
					teleportPaths -= p
					node.nodes += p

			teleports["[count]"] = node


		for(var/n in teleports)
			var/teleportNode/node = teleports[n]

			for(var/obj/teleportPath/p in node.nodes)
				node.nodes -= p

				var/turf/t = locate("[p.dest]_to_[p.name]:0")
				if(!t) continue
				var/area/a = t.loc
				if(a.region == node) continue
				node.nodes[a.region] = "[p.name]_to_[p.dest]:0"

var/teleportMap/TeleportMap

obj/teleportPath
	var
		tmp/dest
		axisY = FALSE
	New()
		..()
		var/area/a = loc.loc
		if(!a) return

		name = a.name

		for(var/turf/t in oview(2, src))
			if(t == loc)  continue
			if(t.density) continue
			if(t.opacity) continue

			var/area/nearby_area = t.loc
			if(nearby_area && nearby_area != a)
				dest = nearby_area.name

				var/obj/teleport/tele = new (t)

				var/offset = axisY ? y - t.y : x - t.x
				var/turf/tagTurf = axisY ? locate(x, tele.y, z) : locate(tele.x, y, z)

				tagTurf.tag = "[name]_to_[nearby_area.name]:[offset]"
				tele.dest   = "[nearby_area.name]_to_[name]:[offset]"

	Side
		axisY = TRUE

area/var/tmp/teleportNode/region

/*mob/verb/testMap()
	for(var/i in TeleportMap.teleports)
		world << i

		var/teleportNode/n = TeleportMap.teleports[i]
		var/nodes = ""
		for(var/node in n.nodes)
			nodes += "[node], "
		world << "Nodes: [nodes]"

		var/textareas = ""
		for(var/t in n.areas)
			textareas += "[t], "
		world << "Areas: [textareas]"*/



/************************************************
Common Room Areas
************************************************/
var/const
	GROUND_FLOOR = 1
	SEC_FLOOR_EAST = 2
	SEC_FLOOR_WEST = 3
	THIRD_FLOOR = 4
	FORTH_FLOOR = 5

proc/getFloor(destination)
	switch(destination)
		if("DADA")
			return GROUND_FLOOR
		if("Charms")
			return SEC_FLOOR_WEST
		if("COMC")
			return GROUND_FLOOR
		if("Transfiguration")
			return THIRD_FLOOR
		if("Muggle Studies")
			return GROUND_FLOOR
		if("Headmasters")
			return SEC_FLOOR_EAST
		if("GCOM")
			return THIRD_FLOOR
		if("Duel")
			return FORTH_FLOOR
	Players << "Error 3b07d"
var/curClass
area
	var/list/AI_directions
	var/location

	inside/ToWisps

	outsideHogwarts           // pathfinding related
		name = "Hogwarts"
	outside/insideHogwarts
		name = "Entrance Hall"
	outsideDEHQ
		name = "Hogwarts"
	outside/insideDEHQ
		name = "DEHQ"
	outside
		Forbidden_Forest
		Desert
			antiTeleport = TRUE
		Hogsmeade
		Hogwarts
		Quidditch
	DEHQ
	AurorHQ
	hogwarts
		TrophyRoom
		Entrance_Hall
		Great_Hall
		Defence_Against_the_Dark_Arts
		Charms
		Care_of_Magical_Creatures
		Transfiguration
		Bathroom
		Library
		Hufflepuff_Common_Room
		Ravenclaw_Common_Room
			SecondFloor
		Slytherin_Common_Room
		Gryffindor_Common_Room
		Dungeons
		Potions
		Hospital_Wing
		Muggle_Studdies
		Restricted_Section
		Detention
		Headmasters_Class_West
		Headmasters_Class_East
		East_Wing
		West_Wing
		Meeting_Room
		Third_Floor
		Study_Hall
		Forth_Floor
		Matchmaking/Duel_Class
		Duel_Arenas
			Gryffindor
			Hufflepuff
			Slytherin
			Ravenclaw
			Main_Arena_Lobby
			Matchmaking/Main_Arena_Top
			Main_Arena_Bottom

				Entered(atom/movable/Obj,atom/OldLoc)
					if(ismob(Obj))
						Obj << infomsg("This section has an old form of dueling enabled. Each projectile will last a full 2 seconds regardless of whether it hits a wall or other blockage.")
			Defence_Against_the_Dark_Arts
			Matchmaking/Duel_Class

		Entered(mob/M)
			..()
			if(isplayer(M))
				if(M.classpathfinding && classdest)
					if(classdest.loc.loc == src)
						M:removePath()
						M.classpathfinding = 0
						for(var/obj/O in M.client.screen)
							if(O.type == /obj/hud/class)
								M.client.screen.Remove(O)

var/mob/classdest = null
mob
	Player
		var/tmp/pathdest
		proc

			removePath()
				for(var/image/C in client.images)
					if(C.icon == 'arrows.dmi')
						client.images.Remove(C)
			pathTo(atom/target)
				if(!loc) return

				var/turf/t
				if(istype(target, /atom/movable))
					t = target.loc
				else
					t = target

				var/area/startarea = loc.loc
				var/area/destarea  = t.loc
				var/path[]

				if(!startarea.region || !destarea.region) return

				if(destarea in startarea.region.areas)
					path = AStar(loc, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)
				else
					var/teleport_path[]
					teleport_path = AStar(startarea.region, destarea.region, /teleportNode/proc/AdjacentNodes, /teleportNode/proc/Distance)

					if(teleport_path && teleport_path.len >= 2)
						var/teleportNode/nextNode = teleport_path[2]
						t = locate(startarea.region.nodes[nextNode]) //the teleport turf on your current floor
						path = AStar(loc, t, /turf/proc/AdjacentTurfs, /turf/proc/Distance)
				sleep()

				if(path && length(path))
					removePath()
					var/length = length(path)
					var/gap    = min(max(round(length / 7, 1), 2), 4)
					for(var/i=1, i < length, i++)
						if(i % gap == 0)
							var/turf/A = path[i]
							var/image/arrow = image('arrows.dmi', A)
							arrow.layer = 10
							usr << arrow
					return 1

	proc
		Class_Path_to()
			if(src:pathdest) src:pathdest = null

			. = src:pathTo(classdest)
			if(!.)
				src:removePath()
				usr << "A path cannot be mapped to the class from this area. Please go to a main area of Hogwarts and try again."
				var/obj/hud/class/C = null
				for(var/obj/O in usr.client.screen)
					if(O.type == /obj/hud/class)
						C = O
				usr.classpathfinding = 0
				if(!classdest)
					if(C) usr.client.screen.Remove(C)
				else
					if(C) C.icon_state = "0"


area
	arenas
		MapTwo
			Auror/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			DE/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
		MapThree
			WaitingArea
			PlayArea
		MapOne
			Gryff/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Raven/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Huffle/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
			Slyth/Exit(atom/movable/O)
				if(ismob(O))
					if(currentArena)
						if(currentArena.started)
							return ..()
						else
							O << "Round hasn't started yet."
					else
						return ..()
				else
					return ..()
area
	CommonRooms
		var/house
		var/dest
		layer = 6
		Entered(mob/Player/M)
			if(!isplayer(M)) return
			if(!house)
				M.Transfer(locate(dest))
			else if(M.House == house)
				M.Transfer(locate(dest))
				M << infomsg("<b>Welcome to your common room.</b>")
			else
				M.followplayer = 0
				var/dense = M.density
				M.density = 0
				step(M, turn(M.dir, 180))
				M.density = dense
				M << errormsg("<b>This isn't your common room.</b>")

		GryffindorCommon
			house = "Gryffindor"
			dest  = "gryfCR"
		GryffindorCommon_Back
			dest  = "gryfCRBack"
		RavenclawCommon
			house = "Ravenclaw"
			dest  = "ravenCR"
		RavenclawCommon_Back
			dest  = "ravenCRBack"
		HufflepuffCommon
			house = "Hufflepuff"
			dest  = "huffleCR"
		HufflepuffCommon_Back
			dest  = "huffleCRBack"
		SlytherinCommon
			house = "Slytherin"
			dest  = "slythCR"
		SlytherinCommon_Back
			dest  = "slythCRBack"

/************************************************
************************************************/

//AREAS

mob/var/DuelRespawn

area
	To_Fourth_Floor
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(45,89,23)

area
	From_Fourth_Floor
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(16,58,22)


area
	To_Owlery
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(42,11,23)

area
	From_Owlery
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(43,36,23)

area
	From_Santa
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(31,98,18)

area
	FredHouseTrap
	FredHouse
	tofred
		Entered(mob/Player/M)
			if(!isplayer(M))
				return

			if("On House Arrest" in M.questPointers)
				var/questPointer/pointer = M.questPointers["On House Arrest"]
				if(!pointer.stage)
					M.Transfer(locate("@Fred"))
					return
			M.Transfer(locate("@FredTrap"))
area
	fromauror
		Entered(mob/Player/M)
			if(!ismob(M))
				return
			if(!M.key)
				return
			else
				M.loc=locate(87,69,22)

area
	Desert
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.density = 0
				M.Move(locate(rand(4,97),rand(4,97),4))
				M.density = 1

area
	Ander_Back
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(93,91,21)
	HMG

	CoS_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(63,53,22)
				M<<"You climb back up the tunnel and into the Bathroom."
	DE_Enter
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(35,2,22)
	DE_Exit
		Entered(mob/Player/M)
			if(istype(M, /mob/Player))
				M.loc=locate(57,98,22)

mob
	var
		hogwarts


mob/var/tmp
	flying = 0


turf
	Arena

	aurortrap
		Entered(mob/Player/M)
			if(istype(M,/mob))
				for(var/mob/A in world)
					if(A.Auror) A << "<i><font color=white>One of the Auror HQ entrance traps has been set off.</font></i>"
				M.Move(locate(38,78,26))
	detrap
		Entered(mob/Player/M)
			if(istype(M,/mob))
				for(var/mob/A in world)
					if(A.DeathEater) A << "<i><font color=white>One of the DE HQ entrance traps has been set off.</font></i>"
				M.Move(locate(37,17,13))





////First you could jst lay this turf on everything that you dont wont people to go
////through (fly through)

/*
area
	nofly
		Entered(mob/Player/M)
			if(M.flying==1)
				M.flying=0
				M<<"Some invisible force knocks you off your broom."
				M.density=100
				M.icon_state=""
				return
*/

area
	blindness
		layer=3
		Enter(mob/Player/M)
			if(isplayer(M))
				M.sight |= BLIND
				M.sight &= ~SEE_SELF
				for(var/mob/Player/A in world)
					if(A.key)
						if(A.client.eye == M)
							A.client.eye = A
			else if(istype(M, /mob/NPC)) return 0
			return 1
		Exited(mob/Player/M)
			if(istype(M, /mob))
				if(M.key)
					M.sight |= SEE_SELF
					M.sight &= ~BLIND
			return

area
	Diagon_Alley
		HogsmeadeSafeZone
		Bank
	hogwarts
		DiagonAlley
		Azkaban
		DEHQ
		AurorHQ
		DuelArena
		Desert
		Pyramid
		CoS
		JulyMaze

		Class_Paths
			DADAClass

			COMCClass

			TransClass

			CharmsClass

			HMClass

			AnderClass

			DuelClass


	Enter(atom/movable/o, atom/oldloc)
		if(istype(o, /obj/projectile) && issafezone(src))
			o.Dispose()
		else return ..()

	Exit(atom/movable/o, atom/newloc)
		if(istype(o, /obj/projectile) && issafezone(newloc.loc))
			o.Dispose()
		else return ..()