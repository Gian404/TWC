/*
 * Copyright � 2014 Duncan Fairley
 * Distributed under the GNU Affero General Public License, version 3.
 * Your changes must be made public.
 * For the full license text, see LICENSE.txt.
 */
obj/items
	questbook
		name="Quest Book"
		icon='questbook.dmi'
		dropable = 0

		Click()
			..()
			var/mob/Player/p = usr
			p.buildQuestBook()

		verb
			Read_Quest_Book()
				var/mob/Player/p = usr
				p.buildQuestBook()

mob
	var
		palmer
		quests
		talktotom
		ratquest

mob/TalkNPC
	professor_palmer
		icon_state="palmer"
		name="Professor Palmer"
		Immortal=1
		Gm=1

		Talk()
			set src in oview(1)
			if(locate(/obj/items/questbook) in usr)
				usr << npcsay("Palmer: Have a good day.")
			else
				usr << "Hello there young student. I am a Former Professor at Hogwarts. My name is Professor Palmer."
				new/obj/items/questbook(usr)
				alert("Professor Palmer hands you a small black book")
				usr << "<br>This is your quest book, inside you keep track of all your accomplished quests."
				sleep(20)
				usr << "<br>I was asked by the Headmaster to teach you about quests and to present you with that quest book."
				sleep(50)
				usr << "<br>If you lose your quest book, you can come back here and get a new one."
				sleep(30)
				usr << "<br>How would you like to put something in that book?"
				sleep(30)
				usr << "<br>If you're interested, I have a friend who could use your help. Tom the Barman in Diagon Alley could use your help, go check it out."

mob/var/talkedtogirl
mob/var/babyquest
mob/var/babyfound
mob/var/foundlord
mob/var/talkedtofred

mob/TalkNPC/quest
	Fred
		icon_state="fred"
		density=1
		Immortal=1
		questPointers = "On House Arrest"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("On House Arrest" in p.questPointers)
				var/questPointer/pointer = p.questPointers["On House Arrest"]

				if(pointer.stage == 1)
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Quickly now, go get my wand from the deposit box in Gringott's bank."
					sleep(30)
					switch(input("Fred: Quickly now","Fred")in list("Where is Gringott's again?","I'm on my way"))
						if("Where is Gringott's again?")
							usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Gringott's Bank is found in Diagon Alley. You can find Diagon Alley near Azkaban Prison."
				else if(pointer.stage == 2)
					alert("You show Fred the wand")
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> YES! You got it!"
					sleep(30)
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Quickly! Use the wand to get me out of here!"
					sleep(20)
					alert("You point the wand at the barriers")
					usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> <b>Finte Incantum!</b>"
					usr.loc=locate(89,33,8)
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Finally! I'm free!!!"
					alert("Fred jumps up and down")
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Thank you so much. You can keep that wand if you'd like."
					p.checkQuestProgress("Fred")
				else
					usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Thanks again!"
			else
				alert("Fred waves his hands in the air")
				usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Help help!"
				switch(input("Fred: HELP HELP!","Fred")in list("What happened?","Shh keep it down","*Ignore Fred*"))
					if("What happened?")
						usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Some strange man did this to me!"
						sleep(30)
						switch(input("Your response","Fred")in list("Why?","What did he look like?","Which way did he go","Let's get you out of there"))
							if("Why?")
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Well he was walking past my house carrying this large sack."
								sleep(20)
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> It looked like there was a person inside. So I confronted him and asked him what was inside."
								sleep(30)
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> His only response was casting a spell and locking me in here."
								alert("Fred frowns")
								return
							if("What did he look like?")
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> I couldn't tell exactly."
								sleep(20)
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> He was wearing a pretty dark cloak."
							if("Which way did he go")
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> I'm not sure, he knocked me out and when I woke up, I was in here."
							if("Let's get you out of there")
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Oh thank you!"
								sleep(30)
								usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> Now how will we get you out..."
								sleep(30)
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> There is a wand of mine. It is in my deposit box at Gringotts. Here"
								alert("Fred tosses the key to you")
								new/obj/items/freds_key(usr)
								usr << "\n<font size=2><font color=red><b> <font color=red>Fred</font> </b>:<font color=white> Go get it from Gringotts, it can get me out of here."
								alert("You nod")

								p.startQuest("On House Arrest")
								p.Resort_Stacking_Inv()

mob/TalkNPC/quest
	Girl
		icon_state="girl"
		density=1
		Immortal=1
		questPointers = "Stolen by the Lord"
		verb
			Examine()
				set src in oview(3)
				usr << "A local townsgirl."

		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage)
					usr << "The girl looks up at you quickly"
					usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> Did you find him yet?!?"

					if(pointer.stage == 2)
						usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> Yep, I found him. Here you are."
						usr << "You hand the little baby boy to the girl"
						usr << "The girl throws her arms around you"
						usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> THANK YOU THANK YOU THANK YOU!"
						usr << "You find yourself smiling slightly"
						usr << "\n<font size=2><ont color=red><b> <font color=red>Girl</font> </b>:<font color=white> Here, this is my allowance that I saved up, you can have it."
						usr << "The girl hands you a hand full of gold."
						p.checkQuestProgress("Girl")
					else
						usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> Not yet, sorry."
						usr << "The girl frowns."
				else
					usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> Thanks again!!!"
					sleep(10)
					usr << "The girl smiles bigger than any you've ever seen."

			else
				usr << "\n\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> Help help!"
				alert("The girl waves her arms in distress")
				sleep(30)
				switch(input("Girl: Are you here to help me?","Help?")in list("Yes","No"))
					if("Yes")
						usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> Oh THANK YOU!"
						sleep(20)
						usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> My mom left to go to the store, and told me to watch my little brother."
						sleep(30)
						usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> I needed to get something from my room and when I came back, my little brother was gone."
						alert("The girl bursts into tears")
						usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> Well where did you see him last?"
						alert("The girl scratches her head")
						usr << "\n<font size=2><font color=red><b> <font color=red>Girl</font> </b>:<font color=white> Uhm, I'm not sure, I just came back and he was gone."
						sleep(30)
						usr << "\n<font size=2><font color=red><b> <font color=red>[usr]</font> </b>:<font color=white> Maybe I will ask some of the towns people around here."
						alert("The girl nods somberly")
						p.startQuest("Stolen by the Lord")
					if("No")
						alert("The girl frowns")





mob
	Baby
		icon = 'NPCs.dmi'
		icon_state="baby"
		density=1
		Immortal=1
		verb
			Examine()
				set src in oview(5)
				usr << "A widdle baby."

mob/TalkNPC
	Lord
		icon_state="lord"
		density=1
		Immortal=1

		verb
			Examine()
				set src in oview(3)
				usr << "He looks like a mix between Count Choculah and an elf."

		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			if("Stolen by the Lord" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Stolen by the Lord"]
				if(pointer.stage == 1)
					switch(input("Lord: How did you get here!","Lord")in list("Your maze was pretty lame","Give back the girls baby"))
						if("Your maze was pretty lame")
							switch(input("Lord: WHAT! NEVER!!! I will demolish you!","Lord")in list("Bring it on!","No! I'm sorry."))
								if("Bring it on!")
									usr << "\n<font size=2><font color=red><b> <font color=red>Lord</font> </b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
									p.checkQuestProgress("Lord")
								if("No! I'm sorry.")
									alert("The Lord squints his eyes at you and turns his back")
						if("Give back the girls baby")
							switch(input("Lord: Never! You'll have to take it!","Lord")in list("So it shall be."))
								if("So it shall be.")
									usr << "\n<font size=2><font color=red><b> <font color=red>Lord</font> </b>:<font color=white> You want to...fight me? Uh, no bodys ever taken the challenge before...HERE! You win."
									p.checkQuestProgress("Lord")
					return
				else if(pointer.stage == 2)
					usr << "You won, go back to the girl."
					return

			usr << "He looks like a mix between Count Choculah and an elf. You decide not to bother him."

turf
	lever
		icon='lever.dmi'
		density=1
		verb
			Examine()
				set src in oview(3)
				alert("You see that the lever is connected to a small trapdoor in the wall")
			Pull_Lever()
				set src in oview(1)
				switch(input("Pull the lever?","Pull the lever?")in list("Yes","No"))
					if("Yes")
						alert("You pull the lever")
						alert("The trapdoor in the wall slowly creeks shut")
						var/mob/Player/p = usr
						p.checkQuestProgress("Lever")
						for(var/turf/lever/L in oview())
							flick("pull",L)
					if("No")
						return

mob/var/talkedtobunny

mob/TalkNPC/quest
	easterbunny
		icon_state = "easter"
		name= "Easter Bunny"
		density=1
		Immortal=1
		questPointers = "Sweet Easter"
		verb
			Examine()
				set src in oview(3)
				usr << "The friendly Easter Bunny!!"

		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Sweet Easter"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Easter Bunny"))
						alert("You throw the bag of chocolates to the Easter Bunny.")
						sleep(20)
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> OH THANK YOU THANK YOU THANK YOU!!!"
						sleep(30)
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh! Now Easter can continue! THANK YOU!!!"
						sleep(30)
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> I don't have much to give you. Although I can give you this!"
						alert("The Easter Bunny hands you an Easter Wand")
						sleep(20)
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> ENJOY!"
					else
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Did you find the chocolate yet!!?!"
						sleep(30)
						usr << "\n<font size=2><font color=red><b> <font color=Red>[usr]</font> </b>:<font color=white> No, not yet. Sorry."
						sleep(20)
						alert("The Easter Bunny frowns")
						sleep(20)
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh...okay."
					return

			if(!pointer)
				alert("The Easter Bunny frowns")
				switch(input("Your response","Respond")in list("What's wrong","*Walk away slowly*"))
					if("What's wrong")
						usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> It's just that, I made these brand new chocolates, that are a MILLION! times better than ordinary chocolate. And they seem to have went missing."
						alert("The Easter Bunny frowns")
						switch(input("Your Response","Respond")in list("Do you have any idea who did this?","Well quit talking to me and get to finding them!"))
							if("Do you have any idea who did this?")
								usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> No...I have no idea at all. I mean, who would want to hurt Easter!"
								sleep(30)
								switch(input("Easter Bunny: It's sad","Easter Bunny")in list("Don't worry, i'll find them for you","Oh well, good luck!"))
									if("Don't worry, i'll find them for you")
										usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> Oh, Thank you so much! I will be here waiting. Oh please hurry!"
										p.startQuest("Sweet Easter")
									if("Oh well, good luck!")
										return

							if("Well quit talking to me and get to finding them!")
								alert("The Easter Bunny looks away")
								return

					if("*Walk away slowly*")
						alert("You back away slowly")
						step_away(usr, src)
			else
				usr << "\n<font size=2><font color=red><b> <font color=#FF3399>Easter Bunny</font> </b>:<font color=white> THANKS AGAIN!"

mob/var/talkedzombie=0

obj
	chocolatebar
		name="Chocolate Bar"
		icon='chocolate_bar.dmi'
		icon_state="1"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	tootsieroll
		name="Tootsie Roll"
		icon='tootsie_roll.dmi'
		icon_state="2"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	candycorn
		name="Candy Corn"
		icon='candy_corn.dmi'
		icon_state="3"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

	caramelapple
		name="Caramel Apple"
		icon='caramel_apple.dmi'
		icon_state="4"
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Drop()
				Move(usr.loc)
				usr:Resort_Stacking_Inv()
				hearers()<<"[usr] drops \his [src]."

obj
	Halloween_Bucket
		icon='halloween_bucket.dmi'
		icon_state="bag1"
		verb
			Take_Out_Candy()
				hearers() << "<font color=#FFA600><b>[usr] pulls some candy out of \his halloween bucket!</b></font>"
				var/rnd=rand(1,4)
				if(rnd==1)
					var/obj/chocolatebar/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==2)
					var/obj/tootsieroll/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==3)
					var/obj/candycorn/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"
				if(rnd==4)
					var/obj/caramelapple/p = new
					p:loc = locate(src.x,src.y-1,src.z)
					p:owner = "[usr.key]"


		verb
			Use()
				hearers() << "<font color=#FFA600><b>[usr] pulls out \his halloween bucket.</b></font>"
				usr.overlays+=image('halloween-bag.dmi')

		verb
			Take_Off()
				hearers() << "<font color=#FFA600><b>[usr] puts away \his halloween bucket.</b></font>"
				usr.overlays-=image('halloween-bag.dmi')
		verb
			Take()
				set src in oview(0)
				hearers()<<"[usr] takes \the [src]."
				Move(usr)
				usr:Resort_Stacking_Inv()
		verb
			Destroy()
				switch(input("Are you sure you want to destroy this?","Destroy?")in list("Yes","No"))
					if("Yes")
						del src
						usr.overlays-=image('halloween-bag.dmi')
					if("No")
						return

			Examine()
				set src in view(3)
				usr << "<font color=#FFA600>It's a Halloween Bucket from 2011!</font>"



obj
	ground_silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/silver_knife) in usr.contents)
					usr << "<b>You already have a Silver Knife!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Silver Knife.</b>"
					new/obj/Stupid/silver_knife(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_blessed_torch
		name="Blessed Torch"
		icon='halloween.dmi'
		icon_state="torch"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
					usr << "<b>You already have a Blessed Torch!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Blessed Torch.</b>"
					new/obj/Stupid/Blessed_Torch(usr)
					usr:Resort_Stacking_Inv()

obj
	ground_holy_grenade
		name="Holy Grenade"
		icon='halloween.dmi'
		icon_state="bomb"
		verb
			Take()
				set src in oview(2)
				if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
					usr << "<b>You already have a Holy Grenade!</b>"
				else if(locate(/obj/items/wearable/halloween_bucket) in usr.contents)
					usr << errormsg("You've already completed this quest!")
				else
					hearers() << "<b>[usr] picks up the Holy Grenade.</b>"
					new/obj/Stupid/Holy_Grenade(usr)
					usr:Resort_Stacking_Inv()

obj
	Stupid/silver_knife
		name="Silver Knife"
		icon='halloween.dmi'
		icon_state="silver knife"

obj
	Stupid/Blessed_Torch
		icon='halloween.dmi'
		icon_state="torch"

obj
	Stupid/Holy_Grenade
		icon='halloween.dmi'
		icon_state="bomb"


mob/TalkNPC
	Zombie
		NPC=1
		bumpable=0
		Immortal=1
		icon='MaleZombie.dmi'
		icon_state=""
		Gm=1

		Talk()
			set src in oview(3)
			if(usr.talkedzombie==2)
				usr << npcsay("Thanks for helping! Those innocent people will be slain soon!")
			else
				if(usr.talkedzombie==1)
					usr << npcsay("Did you find everything!?")
					if(locate(/obj/Stupid/silver_knife) in usr.contents)
						if(locate(/obj/Stupid/Blessed_Torch) in usr.contents)
							if(locate(/obj/Stupid/Holy_Grenade) in usr.contents)
								for(var/obj/O in usr.contents)
									if(istype(O,/obj/Stupid))
										del(O)
								usr << npcsay("You got everything! You've done enough, leave the rest to me. Thanks!")
								usr << npcsay("Here is your reward.")
								new/obj/items/wearable/halloween_bucket(usr)
								usr:Resort_Stacking_Inv()
								usr.talkedzombie=2
							else
								usr << npcsay("You don't have the Holy Grenade!")
						else
							usr << npcsay("You don't have the Blessed Torch!")
					else
						usr << npcsay("You don't have the Silver Knife!")
				else
					usr << npcsay("Hello. In a fit of rage I believe I have gone and infected 7 people last night with this curse I currently have bestowed upon me. If something is not done about this, you will be looking at a rather large problem.")
					switch(input("Your response?","Make a selection")in list("Why do you want to kill other zombies?","What can I do to help?"))
						if("Why do you want to kill other zombies?")
							usr << npcsay("Simple! I don't like competition, I'm a lazy zombie.")
							switch(input("Your response?","Make a selection")in list("What can I do to help?"))
								if("What can I do to help?")
									usr << npcsay("There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
									usr.talkedzombie=1
						if("What can I do to help?")
							usr << npcsay("There are other Zombie killers in the area, you'll need their tools. One in Diagon Alley, one in Hogwarts, and one in Hogsmeade. You will be looking for a silver knife, blessed torch, and a holy grenade. Hurry and return when you've found what we need!")
							usr.talkedzombie=1
		New()
			..()
			wander()
		proc/wander()

			while(src)
				walk_rand(src,rand(5,30))
				sleep(5)


mob/var/talkedtoalyssa


mob/TalkNPC/quest
	Alyssa
		icon_state="alyssa"
		Gm=1
		Immortal=1
		questPointers = "Make a Potion"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			if("Make a Potion" in p.questPointers)
				var/questPointer/pointer = p.questPointers["Make a Potion"]
				if(pointer.stage)
					usr << "<b><font color=blue>Alyssa: </font>Find my ingredients yet?!"
					switch(input("What is your response?","Make a selection")in list("Yes","No"))
						if("Yes")
							usr << "<b><font color=blue>Alyssa: </font>Well let's see them."
							if(pointer.stage == 2)
								usr << "<b><font color=blue>Alyssa: </font>You have it all! How wonderful!"
								sleep(25)
								usr << "<b><font color=blue>Alyssa: </font>Now we'll use these to brew the potion."
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>Hopefully I've mixed it right! I'm ready to be immortal."
								sleep(25)
								usr << "<i>Alyssa drinks the potion</i>"
								sleep(20)
								flick("transfigure",src)
								src.icon='Frog.dmi'
								sleep(40)
								flick("transfigure",src)
								icon='NPCs.dmi'
								icon_state="alyssa"
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>I guess it was too good to be true."
								sleep(20)
								usr << "<b><font color=blue>Alyssa: </font>Thanks for helping me anyways, you can have these as a token of my gratitude."

								for(var/obj/items/Alyssa/X in usr)
									X.loc = null
								var/obj/items/AlyssaScroll/scroll = locate() in usr
								if(scroll)
									scroll.loc = null
								p.checkQuestProgress("Alyssa")
							else
								usr << "<b><font color=blue>Alyssa: </font>You don't have all of the ingredients! Go back and look for them!"
						if("No")
							usr << "<b><font color=blue>Alyssa: </font>Better keep on looking!"
				else
					usr << "<b><font color=blue>Alyssa: </font>Thanks again for helping me."
			else
				usr << "<b><font color=blue>Alyssa: </font>Hey there! You look like someone with too much time on their hands."
				sleep(15)
				usr << "<b><font color=blue>Alyssa: </font>How would you like to help me out?"
				switch(input("What do you say?","Make a selection")in list("What do you need help with?","No thanks"))
					if("What do you need help with?")
						usr << "<b><font color=blue>Alyssa: </font>Well I've been reading this book I found! There's a recipe here for a potion that makes anyone immortal!"
						sleep(15)
						usr << "<b><font color=blue>Alyssa: </font>I just don't have all the ingredients I need, can you help me find some?!"
						switch(input("Will you help Alysaa find the potion ingredients?","Make a selection")in list("Certainly!","I've got better things to do"))
							if("Certainly!")
								usr << "<b><font color=blue>Alyssa: </font>Oh wonderful! I know people around here make potions. Maybe they have some ingredients stashed away in there houses."
								sleep(15)
								usr << "<b><font color=blue>Alyssa: </font>I'm not saying to steal them....Just borrow them. Indefinitely."
								sleep(15)
								usr << "<b><font color=blue>Alyssa: </font>There's probably some growing around too. Here's my list!"
								new/obj/items/AlyssaScroll(usr)
								alert("Alyssa hands you her list of potion ingredients")
								usr << "<b><font color=blue>Alyssa: </font>Thanks!"
								p.Resort_Stacking_Inv()
								p.startQuest("Make a Potion")
							if("I've got better things to do")
								return
					if("No thanks")
						return

mob/var/onionroot
mob/var/indigoseeds
mob/var/silverspiderlegs
mob/var/salamanderdrop

obj/items/Alyssa
	icon='ingred.dmi'
	dropable = 0

	Onion_Root
		icon_state="Onion Root"
		desc = "I found an onion root!"
	Salamander_Drop
		icon_state="Salamander Drop"
		desc = "What the heck is a Salamander Drop?!"
	Indigo_Seeds
		icon_state="Indigo Seeds"
		desc = "I found some Indigo Seeds!"
	Silver_Spider_Legs
		icon_state="Silver Spider Legs"
		desc = "I found some Silver Spider Legs!"



obj/AlyssaChest
	name="Chest"
	icon='turf.dmi'
	icon_state="chest"
	density=1
	mouse_over_pointer = MOUSE_HAND_POINTER

	var/r

	proc/open(mob/Player/p)
		alert(p, "You open the chest")
		if(usr.ror == r)
			return 1
		else
			alert("You find nothing.")

	verb
		Examine()
			set src in oview(3)
			usr<<"A chest! I wonder what's inside!"
	verb
		Open()
			set src in oview(1)
			open(usr)

	Click()
		..()
		if(src in oview(1))
			open(usr)
		else
			usr << errormsg("You need to be closer.")

	Onion_Root
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Onion Root"))
				alert("You find an Onion Root!")
				new/obj/items/Alyssa/Onion_Root(usr)
				p.Resort_Stacking_Inv()

	Indigo_Seeds
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Indigo Seeds"))
				alert("You find some Indigo Seeds!")
				new/obj/items/Alyssa/Indigo_Seeds(usr)
				p.Resort_Stacking_Inv()

	Silver_Spider
		Ror1
			r = 1
		Ror2
			r = 2
		Ror3
			r = 3
		open(mob/Player/p)
			.=..()
			if(. && p.checkQuestProgress("Silver Spider Legs"))
				alert("You find some Silver Spider Legs!")
				new/obj/items/Alyssa/Silver_Spider_Legs(usr)
				p.Resort_Stacking_Inv()

mob/var/talkedtosanta


image/questMarker
	icon    = 'QuestMarker.dmi'
	pixel_y = 32

area
	var/tmp/list/questMobs

	Entered(atom/movable/Obj, atom/OldLoc)
		if(isplayer(Obj))
			var/mob/Player/p = Obj
			p.updateQuestMarkers(src)
		.=..()

mob/Player
	var/tmp/list/images


	proc
		addImage(i_Name, image/i_Image)
			client.images += i_Image

			if(!images)	images = list()
			images[i_Name]     = i_Image

		removeImage(i_Name)
			client.images -= images[i_Name]
			images        -= i_Name

			if(!images.len) images = null

		removeAllImages()
			if(images)
				for(var/i in images)
					removeImage(i)

		questMarker(mob/TalkNPC/quest/i_Mob)
			if(!i_Mob.questPointers) return

			removeImage(i_Mob.name)

			var/state
			if(islist(i_Mob.questPointers))
				for(var/p in i_Mob.questPointers)
					var/questPointer/pointer = questPointers[p]
					if(!pointer)
						state = "nonactive"
						continue
					if(pointer.stage)
						var/quest/q = quest_list[p]
						if(pointer.stage == q.stages.len)
							state = "completed"
							break

						state = "active"
						break
			else
				var/questPointer/pointer = questPointers[i_Mob.questPointers]
				if(!pointer)
					state = "nonactive"
				else if(pointer.stage)

					var/quest/q = quest_list[i_Mob.questPointers]
					if(pointer.stage == q.stages.len)
						state = "completed"
					else state = "active"

			if(state)
				var/image/i = image('QuestMarker.dmi', i_Mob, state)
				i.pixel_y = 36
				addImage(i_Mob.name, i)

		updateQuestMarkers(area/i_Area)
			removeAllImages()
			if(i_Area.questMobs)
				for(var/mob/TalkNPC/quest/m in i_Area.questMobs)
					questMarker(m)

mob/TalkNPC/quest
	var/questPointers

	New()
		..()
		if(questPointers)
			var/area/a = loc.loc
			if(a.questMobs)
				a.questMobs += src
			else
				a.questMobs = list(src)

	Vengeful_Wisp
		icon = 'Mobs.dmi'
		icon_state="wisp"
		questPointers = "Will of the Wisp \[Daily]"
		New()
			..()
			alpha = rand(190,255)

			var/color1 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color2 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))
			var/color3 = rgb(rand(20, 255), rand(20, 255), rand(20, 255))

			animate(src, color = color1, time = 10, loop = -1)
			animate(color = color2, time = 10)
			animate(color = color3, time = 10)

		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Will of the Wisp \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Vengeful Wisp"))
						p << npcsay("Vengeful Wisp: I love the irony in sending you to kill dead creatures. May they rest in pea-- I will send you to kill them again tomorrow.")
					else
						p << npcsay("Vengeful Wisp: Don't waste time talking to me, actions speak louder than words!")
						return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("Vengeful Wisp: You, human! I want you to help me express my rage, kill every wisp you face, vengeance shall be mine! Mawhahahaha!!!")
				p.startQuest("Will of the Wisp \[Daily]")
			else
				p << npcsay("Vengeful Wisp: Pity the living!")

	Mysterious_Wizard
		icon_state="wizard"
		questPointers = "The Eyes in the Sand \[Daily]"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["The Eyes in the Sand \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Mysterious Wizard"))
						p << npcsay("Mysterious Wizard: Floating eyes, the gods of the desert can bleed after all, how amusing!")
					else
						p << npcsay("Mysterious Wizard: Not enough, go back there and check if they all bleed!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("Mysterious Wizard: Beyond this door lies the desert, oh so mysterious... There are strange creatures there called floating eyes, check if they bleed for me!")
				p.startQuest("The Eyes in the Sand \[Daily]")
			else
				p << npcsay("Mysterious Wizard: So even the gods of the desert can bleed... Interesting!")

	Saratri
		icon_state="lord"
		questPointers = "To kill a Boss \[Daily]"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["To kill a Boss \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Saratri"))
						p << npcsay("Saratri: Good job! I can't believe you pulled it off!")
					else
						p << npcsay("Saratri: Go kill the Basilisk!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("Saratri: Hey there... Did you know there's a terrible monster here called the Basilisk? I'll reward you if you kill it...")
				p.startQuest("To kill a Boss \[Daily]")
			else
				p << npcsay("Saratri: Wow! I can't believe you killed the Basilisk!")

	Malcolm
		icon_state="goblin1"
		questPointers = "Draw Me a Stick \[Daily]"
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Draw Me a Stick \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Malcolm"))
						p << npcsay("Malcolm: Good job! I can't believe you pulled it off!")
					else
						p << npcsay("Malcolm: Go kill the Stickman!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("Malcolm: Welcome to floor 2! Did you know Basilisk is not the strongest monster here?! There's a magical stickman in this floor, if you manage to defeat it I will reward you.")
				p.startQuest("Draw Me a Stick \[Daily]")
			else
				p << npcsay("Malcolm: Wow! I can't believe you killed the Stickman!")

	Hunter
		icon_state="lord"
		questPointers = list("Pest Extermination \[Daily]", "Pest Extermination: Rat", "Pest Extermination: Demon Rat", "Pest Extermination: Pixie", "Pest Extermination: Dog", "Pest Extermination: Snake", "Pest Extermination: Wolf", "Pest Extermination: Troll", "Pest Extermination: Fire Bat", "Pest Extermination: Fire Golem", "Pest Extermination: Archangel", "Pest Extermination: Water Elemental", "Pest Extermination: Fire Elemental", "Pest Extermination: Wyvern")
		Talk()
			set src in oview(3)
			..()
			var/mob/Player/p = usr
			var/list/tiers = list("Rat", "Demon Rat", "Pixie", "Dog", "Snake", "Wolf", "Troll", "Fire Bat", "Fire Golem", "Archangel", "Water Elemental", "Fire Elemental", "Wyvern")
			for(var/tier in tiers)
				var/questPointer/pointer = p.questPointers["Pest Extermination: [tier]"]
				if(pointer && !pointer.stage) continue

				if(!pointer)
					p << npcsay("Hunter: Hey there, maybe you can help me, I want to exterminate a few pests from our lives.")
					p.startQuest("Pest Extermination: [tier]")
				else
					p << npcsay("Hunter: Did you kill the monsters I requested yet?")
					if(p.checkQuestProgress("Hunter"))
						p << npcsay("Hunter: Good job!")
					else
						p << npcsay("Hunter: Go back out there and exterminate some pests!")
				return

			var/questPointer/pointer = p.questPointers["Pest Extermination \[Daily]"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Hunter"))
						p << npcsay("Hunter: Good job!")
					else
						p << npcsay("Hunter: Go back out there and exterminate some pests!")
					return
				else if(time2text(world.realtime, "DD") != time2text(pointer.time, "DD"))
					p.questPointers -= pointer
					pointer = null

			if(!pointer)
				p << npcsay("Hunter: Those monsters you've exterminated returned, go there and exterminate them again.")
				p.startQuest("Pest Extermination \[Daily]")
			else
				p << npcsay("Hunter: You've done a really good job exterminating all those monsters.")


	Zerf
		icon_state = "stat"
		questPointers = list("PvP Introduction", "Culling the Herd")
		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["PvP Introduction"]
			if(pointer)
				if(pointer.stage)
					if(p.checkQuestProgress("Zerf"))
						p << npcsay("Zerf: Good job but we're just getting started!")
					else
						p << npcsay("Zerf: You aren't going to get any better by not fighting!")
				else
					pointer = p.questPointers["Culling the Herd"]
					if(!pointer)
						p << npcsay("Zerf: Let's kill some people... A lot of people!")
						p.startQuest("Culling the Herd")
						return

					if(pointer.stage)
						if(p.checkQuestProgress("Zerf"))
							p << npcsay("Zerf: Mawhahahaha! THEY'RE ALL DEAD!")
						else
							p << npcsay("Zerf: Kill or be killed, my friend.")
					else
						if(p.level == lvlcap)
							p << npcsay("Zerf: Why not try some matchmaking in the ranked arena?")
						else
							p << npcsay("Zerf: When you reach level cap, why not try some matchmaking in the ranked arena?")

			else
				p << npcsay("Zerf: Your skin looks so young and fresh, you haven't done much fighting eh? Why don't you try to fight a bunch of players?")
				p.startQuest("PvP Introduction")
			..()

	Cassandra
		icon_state="alyssa"
		questPointers = list("Make a Potion", "Make a Fortune", "Make a Spell")
		Talk()
			set src in oview(3)
			var/mob/Player/p = usr
			var/questPointer/pointer = p.questPointers["Make a Potion"]
			if(pointer && !pointer.stage)

				if(level >= lvlcap)
					p << npcsay("Cassandra: Look at you, such a weakling can not possibly help me.")
					return

				pointer = p.questPointers["Make a Fortune"]
				if(!pointer)
					p << npcsay("Cassandra: Hey there, do you wish to make a fortune?! Well, you've come to the right place, I have a task for you, go out there to the world and collect a peice of the rarest monsters to be found, their fine essence will be sold for millions!")
					p.startQuest("Make a Fortune")
				else if(pointer.stage)
					if(p.checkQuestProgress("Cassandra"))
						p << npcsay("Cassandra: Hmmph! I could've done it myself but I'm a lady, here you can have this scarf, I don't need it anymore...")
						p << errormsg("Cassandra takes the monster essences you've collected, she's going to make a fortune while you can warm yourself up with her old scarf.")
					else
						p << npcsay("Cassandra: Maybe I was wrong about you, maybe you aren't capable of defeating such rare monsters.")
					return
				else
					pointer = p.questPointers["Make a Spell"]
					if(!pointer)
						p << npcsay("Cassandra: You who helped me once before, how about you help me again, thanks to you I'm rich but sadly gold can not buy me true love, however, I did manage to find a way to fulfil my desires.")
						p << npcsay("Cassandra: There is a spell capable of changing the laws of magic, this will help me find what I seek. You'll have to do what you did last time only this time I need you to collect more powerful elements.")
						p.startQuest("Make a Spell")
					else if(pointer.stage)
						if(p.checkQuestProgress("Cassandra"))
							p << npcsay("Cassandra: Hmmph! I could've done it myself but I'm a lady, here you can have this wand, I don't need it anymore...")
							p << errormsg("Cassandra takes the monster essences you've collected. She's going to be extremely powerful and get all her heart's desires while you are stuck with an old stick.")
						else
							p << npcsay("Cassandra: Maybe I was wrong about you, maybe you aren't capable of defeating such rare monsters.")
						return
					else
						p << npcsay("Cassandra: Come back later, I might have more tasks for the likes of you later \[To be continued in a later update].")
			else
				p << npcsay("Cassandra: You should try helping my twin sister Alyssa, she's sitting at Three Broom Sticks, I hear she seeks an immortality potion.")
			..()

obj/items/demonic_essence
	icon       = 'jokeitems.dmi'
	icon_state = "DarknessPowder"

	Take()
		set src in oview(1)
		var/mob/Player/p = usr
		if(p.checkQuestProgress("Demonic Essence"))
			p << infomsg("You touch the demonic essence and it fades, you feel as if you carry it inside your soul.")
			loc = null
		else
			p << errormsg("You don't need this item.")

	New()
		..()

		emit(loc    = src, ptype  = /obj/particle/magic,
						   amount = 5,
						   angle  = new /Random(1, 359),
						   speed  = 2,
						   life   = new /Random(20,25))

		animate(src, color = rgb(255, 0, 0), time = 10, loop = -1)
		animate(color = rgb(255, 0, 255), time = 10)

		spawn(100)
			loc = null


var/list/quest_list

proc
	init_quests()
		quest_list = list()
		for(var/t in typesof(/quest/) - /quest)
			if(findtext("[t]", "stage")) continue
			var/quest/q = new t(1)
			quest_list[q.name] = q


quest
	var/name
	var/list/stages
	var/desc
	var/list/reqs
	var/questReward/reward

	Ritual
		name   = "Demonic Ritual"
		desc   = "Tammie told you about a ritual capable of increasing your power."
		reward = /questReward/Ritual

		Essence
			desc = "Find demonic essences for the ritual."
			reqs = list("Demonic Essence" = 5)
		TrollingEssence
			desc = "It appears one of the essences you've collected disappeared, find another."
			reqs = list("Demonic Essence" = 1)
		Reward
			desc = "Go back to Tammie for your reward!"
			reqs = list("Tammie" = 1)

	Easter
		name   = "Sweet Easter"
		desc   = "The easter bunny wants you to help him find a new brand of chocolate he made but seem to have lost."
		reward = /questReward/Easter

		GetChocolate
			desc = "Find the chocolate, you heard a rumour a guy named Zonko has it."
			reqs = list("Zonko" = 1)
		Reward
			desc = "Go back to the Easter Bunny to get your reward!"
			reqs = list("Easter Bunny" = 1)

	PVP1
		name   = "PvP Introduction"
		desc   = "Zerf wants you to fight a few players... He probably just wants you to get dirt on your face so you look less shiny."
		reward = /questReward/PVP1

		Kill
			desc = "Kill 20 players."
			reqs = list("Kill Player" = 20)
		Reward
			desc = "Go back to Zerf to get your reward!"
			reqs = list("Zerf" = 1)

	PVP2
		name   = "Culling the Herd"
		desc   = "Zerf wants you to fight a massive amount of players... I wonder what he gets out of it."
		reward = /questReward/PVP2

		Kill
			desc = "Kill 1000 players."
			reqs = list("Kill Player" = 1000)
		Reward
			desc = "Go back to the Zerf to get your reward!"
			reqs = list("Zerf" = 1)

	Extermination
		name   = "Pest Extermination \[Daily]"
		desc   = "The hunter wants you to help him exterminate monsters."
		reward = /questReward/Artifact

		Kill
			desc = "Kill 50 of each monster."
			reqs = list("Kill Rat"             = 50,
			            "Kill Demon Rat"       = 50,
			            "Kill Pixie"           = 50,
			            "Kill Dog"             = 50,
			            "Kill Snake"           = 50,
			            "Kill Wolf"            = 50,
			            "Kill Troll"           = 50,
			            "Kill Fire Bat"        = 50,
			            "Kill Fire Golem"      = 50,
			            "Kill Archangel"       = 50,
			            "Kill Water Elemental" = 50,
			            "Kill Fire Elemental"  = 50,
			            "Kill Wyvern"          = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)

	Basilisk
		name   = "To kill a Boss \[Daily]"
		desc   = "The basilisk is found at the Chamber of Secrets, kill the Basilisk and any demon rat that gets in your way!"
		reward = /questReward/Artifact

		Kill
			desc = "Kill 1 basilisk and 50 demon rats."
			reqs = list("Kill Basilisk"        = 1,
			            "Kill Demon Rat"       = 50)
		Reward
			desc = "Go back to Saratri to get your reward!"
			reqs = list("Saratri" = 1)

	Stickman
		name   = "Draw Me a Stick \[Daily]"
		desc   = "The stickman is found at the Chamber of Secrets floor 2, kill the Stickman and any Troll that gets in your way!"
		reward = /questReward/Teleport

		Kill
			desc = "Kill 1 stickman and 50 trolls."
			reqs = list("Kill Stickman"        = 1,
			            "Kill Troll"       = 50)
		Reward
			desc = "Go back to Malcolm to get your reward!"
			reqs = list("Malcolm" = 1)


	Eyes
		name   = "The Eyes in the Sand \[Daily]"
		desc   = "The desert is a mysterious area filled with strange creatures called floating eyes, I wonder if they bleed..."
		reward = /questReward/Artifact

		Kill
			desc = "Kill 60 floating eyes."
			reqs = list("Kill Floating Eye" = 60)
		Reward
			desc = "Go back to the Mysterious Wizard to get your reward!"
			reqs = list("Mysterious Wizard" = 1)

	Wisps
		name   = "Will of the Wisp \[Daily]"
		desc   = "The vengeful wisp wants you to execute revenge, you must kill wisps!"
		reward = /questReward/Artifact

		Kill
			desc = "Kill 80 wisps."
			reqs = list("Kill Wisp" = 80)
		Reward
			desc = "Go back to the Vengeful Wisp to get your reward!"
			reqs = list("Vengeful Wisp" = 1)

	Rats
		name   = "Pest Extermination: Rat"
		desc   = "The hunter wants you to help him exterminate rats from the forest"
		reward = /questReward/Mon1

		Kill
			desc = "Kill 50 rats."
			reqs = list("Kill Rat" = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	DemonRats
		name   = "Pest Extermination: Demon Rat"
		desc   = "The hunter wants you to help him exterminate demon rats from the Chamber of Secrets"
		reward = /questReward/Mon2

		Kill
			desc = "Kill 100 demon rats."
			reqs = list("Kill Demon Rat" = 100)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Pixie
		name   = "Pest Extermination: Pixie"
		desc   = "The hunter wants you to help him exterminate pixies from the pixie pit"
		reward = /questReward/Mon3

		Kill
			desc = "Kill 150 pixies."
			reqs = list("Kill Pixie" = 150)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Dog
		name   = "Pest Extermination: Dog"
		desc   = "The hunter wants you to help him exterminate dogs from the forest"
		reward = /questReward/Mon4

		Kill
			desc = "Kill 200 dogs."
			reqs = list("Kill Dog" = 200)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Snake
		name   = "Pest Extermination: Snake"
		desc   = "The hunter wants you to help him exterminate snakes from the graveyard"
		reward = /questReward/Mon5

		Kill
			desc = "Kill 250 snakes."
			reqs = list("Kill Snake" = 250)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wolf
		name   = "Pest Extermination: Wolf"
		desc   = "The hunter wants you to help him exterminate wolves from the forest"
		reward = /questReward/Mon6

		Kill
			desc = "Kill 300 wolves."
			reqs = list("Kill Wolf" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Troll
		name   = "Pest Extermination: Troll"
		desc   = "The hunter wants you to help him exterminate trolls from the forest"
		reward = /questReward/Mon7

		Kill
			desc = "Kill 50 trolls."
			reqs = list("Kill Troll" = 50)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireBats
		name   = "Pest Extermination: Fire Bat"
		desc   = "The hunter wants you to help him exterminate fire bats from Silverblood Grounds"
		reward = /questReward/Mon8

		Kill
			desc = "Kill 300 fire bats."
			reqs = list("Kill Fire Bat" = 300)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireGolem
		name   = "Pest Extermination: Fire Golem"
		desc   = "The hunter wants you to help him exterminate fire golems from Silverblood Grounds"
		reward = /questReward/Mon9

		Kill
			desc = "Kill 350 fire golems."
			reqs = list("Kill Fire Golem" = 350)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Archangel
		name   = "Pest Extermination: Archangel"
		desc   = "The hunter wants you to help him exterminate Archangel from Silverblood Castle"
		reward = /questReward/Mon10

		Kill
			desc = "Kill 400 archangels."
			reqs = list("Kill Archangel" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	WaterElemental
		name   = "Pest Extermination: Water Elemental"
		desc   = "The hunter wants you to help him exterminate fire water elementals from Silverblood Castle"
		reward = /questReward/Mon11

		Kill
			desc = "Kill 400 water elementals."
			reqs = list("Kill Water Elemental" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	FireElemental
		name   = "Pest Extermination: Fire Elemental"
		desc   = "The hunter wants you to help him exterminate fire golems from Silverblood Castle"
		reward = /questReward/Mon12

		Kill
			desc = "Kill 400 fire elementals."
			reqs = list("Kill Fire Elemental" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)
	Wyvern
		name   = "Pest Extermination: Wyvern"
		desc   = "The hunter wants you to help him exterminate wyverns from Silverblood Castle"
		reward = /questReward/Mon13

		Kill
			desc = "Kill 400 wyverns."
			reqs = list("Kill Wyvern" = 400)
		Reward
			desc = "Go back to the hunter to get your reward!"
			reqs = list("Hunter" = 1)


	Tom
		name   = "Rats in the Cellar"
		reward = /questReward/Gold

		Clear
			desc = "Tom wants you to clear his cellar of rats, kill 35 rats and pull the lever at the end of the cellar."
			reqs = list("Lever" = 1, "Kill Rat" = 35)
		Reward
			desc = "Go back to Tom to get your reward!"
			reqs = list("Tom" = 1)

	Lord
		name = "Stolen by the Lord"
		reward = /questReward/Gold

		FindLord
			desc = "Girl wants you to find and rescue her baby from Lord, you heard a rumour he's at a place called Silverblood, maybe you can get there from the forest."
			reqs = list("Lord" = 1)
		Reward
			desc = "Return the baby back to Girl and get your reward!"
			reqs = list("Girl" = 1)

	Alyssa
		name = "Make a Potion"
		reward = /questReward/RoyaleShoes

		FindHerbs
			desc = "Alyssa wants you to help her procure an immortality potions, go find Onion Root, Indigo Seeds, Silver Spider Legs and Salamander Drop."
			reqs = list("Onion Root" = 1, "Indigo Seeds" = 1, "Silver Spider Legs" = 1, "Salamander Drop" = 1)
		Reward
			desc = "You have all the ingredients, go back to Alyssa for your reward."
			reqs = list("Alyssa" = 1)


	MakeAFortune
		name = "Make a Fortune"
		reward = /questReward/RoyaleScarf

		Kill
			desc = "Cassandra wants you to help her procure a peice of the rarest monsters in the land, of course that requires you to kill some nasty beasts."
			reqs = list("Kill Wyvern"           = 50,
			            "Kill Floating Eye"     = 50,
			            "Kill Wisp"             = 50,
			            "Kill Basilisk"         = 1,
			            "Kill Willy the Whisp"  = 1,
			            "Kill The Evil Snowman" = 1,
			            "Kill Tamed Dog"        = 1,
			            "Kill Player"           = 30)
		Reward
			desc = "You have all the monster essences, go back to Cassandra for your reward."
			reqs = list("Cassandra" = 1)

	MakeASpell
		name = "Make a Spell"
		reward = /questReward/RoyaleWand

		Kill
			desc = "Cassandra wants you to help her procure a new spell capable of changing the laws of magic."
			reqs = list("Demonic Essence"        = 5,
						"Kill Demon Rat"         = 50,
			            "Kill Floating Eye"      = 200,
			            "Kill Wisp"              = 50,
			            "Kill Basilisk"          = 1,
			            "Kill Stickman"          = 1,
			            "Kill Eye of The Fallen" = 1,
			            "Kill Tamed Dog"         = 1,
			            "Kill Player"            = 60)
		Reward
			desc = "You have all the monster essences, go back to Cassandra for your reward."
			reqs = list("Cassandra" = 1)

	Fred
		name = "On House Arrest"
		reward = /questReward/Gold

		GetWand
			desc = "Fred wants you to go withdraw a special wand from his vault at Gringotts, one of the bank goblins will help you."
			reqs = list("Fred's Wand" = 1)
		Reward
			desc = "Use the wand to free Fred."
			reqs = list("Fred" = 1)

	New(var/isQuest = 0)
		..(isQuest)

		if(isQuest)
			stages = list()
			for(var/t in typesof(type) - type)
				stages += new t

			if(reward) reward = new reward

questReward
	var/gold
	var/exp
	var/items

	Gold
		exp  = 1000
		gold = 10000
	Mon1
		gold = 1000
		exp  = 10000
	Mon2
		gold = 2000
		exp  = 20000
		items = /obj/items/lamps/double_exp_lamp
	Mon3
		gold = 3000
		exp  = 30000
	Mon4
		gold  = 4000
		exp   = 40000
		items = list(/obj/items/wearable/title/Hunter,
				     /obj/items/lamps/triple_exp_lamp)
	Mon5
		gold = 5000
		exp  = 50000
	Mon6
		gold = 6000
		exp  = 60000
		items = /obj/items/lamps/triple_exp_lamp
	Mon7
		gold = 7000
		exp  = 70000
	Mon8
		gold = 8000
		exp  = 80000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon9
		gold  = 9000
		exp   = 90000
		items = list(/obj/items/wearable/title/Pest,
					 /obj/items/lamps/penta_exp_lamp)
	Mon10
		gold = 10000
		exp  = 100000
	Mon11
		gold = 11000
		exp  = 110000
		items = /obj/items/lamps/quadaple_exp_lamp
	Mon12
		gold = 12000
		exp  = 120000
		items = /obj/items/lamps/triple_exp_lamp
	Mon13
		gold  = 13000
		exp   = 130000
		items = list(/obj/items/wearable/title/Exterminator,
					 /obj/items/lamps/sextuple_exp_lamp)
	Artifact
		gold  = 14000
		exp   = 140000
		items = /obj/items/artifact
	Teleport
		gold  = 16000
		exp   = 160000
		items = list(/obj/items/magic_stone/teleport,
		             /obj/items/magic_stone/teleport)
	RoyaleShoes
		gold  = 5000
		exp   = 10000
		items = /obj/items/wearable/shoes/royale_shoes
	RoyaleScarf
		gold  = 24000
		items = /obj/items/wearable/scarves/royale_scarf
	RoyaleWand
		gold  = 32000
		items = /obj/items/wearable/wands/royale_wand
	PVP1
		gold  = 15000
		exp   = 15000
		items = list(/obj/items/bagofgoodies,
			         /obj/items/wearable/wands/salamander_wand)
	PVP2
		gold  = 60000
		exp   = 60000
		items = list(/obj/items/bagofgoodies,
			         /obj/items/artifact,
			         /obj/items/artifact,
			         /obj/items/artifact,
			         /obj/items/magic_stone/teleport,
			         /obj/items/magic_stone/teleport,
			         /obj/items/magic_stone/teleport)
	Ritual
		gold  = 3000
		exp   = 30000
		items = list(/obj/items/bagofgoodies,
					 /obj/items/lamps/penta_exp_lamp)
	Easter
		exp   = 10000
		items = /obj/items/wearable/wands/maple_wand


	clanReward
		var/points

		get(mob/Player/p)
			..(p)

			if(points)
				p.addRep(points)
				p << infomsg("You gained [abs(points)] [points > 0 ? "good" : "evil"] reputation.")

	proc/get(mob/Player/p)
		if(gold)
			p.gold += gold
			p << infomsg("You receive [comma(gold)] gold.")
		if(exp && p.level < lvlcap)
			p << infomsg("You receive [comma(exp)] experience.")
			var/xp2give = exp
			while(p.Exp + xp2give > p.Mexp && p.level <= lvlcap)
				xp2give -= p.Mexp - p.Exp
				p.Exp = p.Mexp
				p.LvlCheck()

			p.Exp += xp2give
			p.LvlCheck()
		if(items)
			if(islist(items))
				for(var/t in items)
					var/obj/o = new t (p)
					p << infomsg("You receive [o.name].")
			else
				var/obj/o = new items (p)
				p << infomsg("You receive [o.name].")
			p.Resort_Stacking_Inv()

questPointer
	var/stage
	var/list/reqs
	var/time
	var/track = TRUE

	proc/setReqs(var/list/L)
		reqs = L.Copy()


mob/Player
	var/list/questPointers = list()
	var/tmp/showQuestType = 0 // 0 - active, 1 - complete, 2 - all

	verb
		showQuestType()
			set hidden = 1
			set name = ".showQuestType"

			switch(++showQuestType)
				if(1)
					winset(src, "Quests.buttonQuestDisplay", "text=\"Completed Quests\"")
				if(2)
					winset(src, "Quests.buttonQuestDisplay", "text=\"All Quests\"")
				if(3)
					showQuestType = 0
					winset(src, "Quests.buttonQuestDisplay", "text=\"Active Quests\"")
			buildQuestBook()

	proc
		buildQuestBook()
			src << output(null, "Quests.outputQuests")
			var/i = 0
			for(var/questName in questPointers)
				var/questPointer/pointer = questPointers[questName]

				if((showQuestType == 0 && pointer.stage) || (showQuestType == 1 && !pointer.stage) || showQuestType == 2)
					i++
					src << output("<a href=\"?src=\ref[src];action=selectQuest;questName=[questName]\">[questName]</a>", "Quests.gridQuests:1,[i]")
					if(pointer.stage) src << output("<a href=\"?src=\ref[src];action=trackQuest;questName=[questName]\">Toggle</a>", "Quests.gridQuests:2,[i]")
					else src << output(null, "Quests.gridQuests:2,[i]")
					if(i == 1)
						displayQuest(questName)
			winset(src, "Quests.gridQuests", "cells=2x[i]")

			winshow(src, "Quests", 1)

		displayQuest(var/questName)

			src << output(null, "Quests.outputQuests")

			var/questPointer/pointer = questPointers[questName]
			var/quest/q              = quest_list[questName]

			src << output("<b><u>[q.name]</u></b><br>", "Quests.outputQuests")
			src << output("[q.desc]<br>", "Quests.outputQuests")

			for(var/i = 1 to q.stages.len)
				if(pointer.stage && pointer.stage < i) break
				var/quest/stage = q.stages[i]
				src << output("[stage.desc]<br>", "Quests.outputQuests")

			if(pointer.time)
				src << output("Completed on: <b>[time2text(pointer.time, "DD Month")]</b><br>", "Quests.outputQuests")


		startQuest(questName)
			if(questName in quest_list)
				var/quest/q = quest_list[questName]
				var/quest/stage = q.stages[1]

				var/questPointer/pointer = new
				pointer.setReqs(stage.reqs)
				pointer.stage = 1

				questPointers[questName] = pointer

				Interface.Update()
				src << infomsg(q.desc)
				src << infomsg(stage.desc)

				updateQuestMarkers(loc.loc)

		trackQuest(var/questName)
			var/questPointer/pointer = questPointers[questName]

			if(pointer.track)
				src << infomsg("[questName] will no longer be tracked on screen.")
				pointer.track = FALSE
			else
				src << infomsg("[questName] will be tracked on screen.")
				pointer.track = TRUE

			Interface.Update()


		questProgress(questName, args, trackedOnly=TRUE)
			var/questPointer/pointer = questPointers[questName]
			if(!pointer.stage)                return
			if(!pointer.track && trackedOnly) return 2

			var/quest/q = quest_list[questName]

			if((args in pointer.reqs) && pointer.reqs[args] > 0)
				pointer.reqs[args]--
				. = 1

				if(pointer.reqs[args] <= 0)
					pointer.reqs -= args

			if(!pointer.reqs.len)
				pointer.stage++
				if(pointer.stage <= q.stages.len)
					var/quest/stage = q.stages[pointer.stage]
					src << infomsg(stage.desc)
					pointer.setReqs(stage.reqs)
				else // quest completed
					if(q.reward) q.reward.get(src)
					pointer.reqs  = null
					pointer.stage = null
					pointer.time = world.realtime
				updateQuestMarkers(loc.loc)


		checkQuestProgress(args)
			var/found = FALSE

			var/list/untracked = list()
			for(var/questName in questPointers)
				if(!(questName in quest_list)) continue

				found = questProgress(questName, args)
				if(found == 2)
					found = 0
					untracked += questName
				else if(found == 1) break

			if(!found && untracked.len)
				for(var/questName in untracked)
					found = questProgress(questName, args, FALSE)
					if(found) break
				untracked = null
			if(found) Interface.Update()

			return found



mob/Player/Topic(href, href_list[])
	if(href_list["action"] == "selectQuest")
		var/questName = href_list["questName"]
		displayQuest(questName)
	else if(href_list["action"] == "trackQuest")
		var/questName = href_list["questName"]
		trackQuest(questName)
	.=..()

mob/Player
	var/tmp/interface/Interface

client/New()
	..()

interface
	var/obj/hud/screentext/quest/quest
	var/mob/Player/parent

	New(mob/Player/p)
		..()
		parent = p

		Update()

	proc/Update()
		if(parent.HideQuestTracker && quest)
			parent.client.screen -= quest
			quest = null
		else if(!parent.HideQuestTracker && !quest)
			quest = new
			parent.client.screen += quest

		if(quest)
			quest.update(parent)

// turn off when obj is gone
//

obj/hud/screentext

	questPath
		mouse_over_pointer = MOUSE_HAND_POINTER
		mouse_opacity = 2
		maptext = "<b>\[Path]<b>"
		maptext_width  = 44
		maptext_height = 32

		Click()
			..()
			var/mob/Player/p = usr
			if(p.pathdest && p.pathdest:tag == name)
				p.pathdest = null
				p.removePath()
			else
				p.classpathfinding = 0

				p.pathdest = locate(name)
				p.pathTo(p.pathdest)

	quest
		screen_loc = "WEST+1,SOUTH+1"
		maptext_width  = 320
		maptext_height = 320

		proc/update(mob/Player/p)
			maptext = null
			var/count        = 4
			var/offset       = 0
			var/pixel_offset = 29

			for(var/obj/hud/screentext/questPath/path in p.client.screen)
				p.client.screen -= path
			var/removePath = p.pathdest ? TRUE : FALSE

			for(var/questName in p.questPointers)
				var/questPointer/pointer = p.questPointers[questName]
				if(!pointer.stage) continue
				if(!pointer.track) continue

				count--
				if(count < 0) break

				pixel_offset += (pointer.reqs.len) * 14 + 18
				if(pixel_offset >= 32)
					pixel_offset -= 32
					offset++

				if(pointer.reqs.len == 1 && locate(pointer.reqs[1]))
					var/obj/hud/screentext/questPath/path = new
					path.name = pointer.reqs[1]
					path.screen_loc = "WEST+7,SOUTH+[offset]:[pixel_offset]"
					path.maptext = "<font color=\"[p.mapTextColor]\">[path.maptext]</font>"
					p.client.screen += path

					if(removePath && path.name == p.pathdest:tag)
						removePath = FALSE

				var/reqsText = ""
				for(var/i in pointer.reqs)
					reqsText += "  - [i]: [pointer.reqs[i]]<br>"

				maptext = "<b>[questName]</b><br>[reqsText][maptext]"

			if(maptext)
				maptext = "<font color=[p.mapTextColor]>[maptext] </font>"

			if(removePath)
				p.pathdest = null
				p.removePath()

mob/Player
	var/mapTextColor = "#ffffff"
	verb
		setInterfaceColor(c as color)
			set hidden=1
			set name = ".setInterfaceColor"
			if(!c) return

			mapTextColor = "[c]"
			Interface.Update()
