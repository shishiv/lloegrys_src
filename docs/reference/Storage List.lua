--MagicEffects
1 - blood splat
2 - blue rings
3 - poof
4 - armor hit yellow spark
5 - red spark explosion
6 - yellow cloud explosion
7 - fire explosion
8 - yellow gas
9 - poison attack
10 - physical impact
11 - teleport blue magic
12 - blue energy
13 - blue sparks
14 - red sparks
15 - green sparks
16 - on fire
17 - poison hit
18 - mort area
19 - green sound
20 - red sound
21 - poison gas
22 - yellow sound
23 - purple sound
24 - blue sound
25 - white sound
26 - bubbles
27 - dice roll
28 - coloured sparks
29 - yellow firework
30 - red firework
31 - blue firework
32 - stun
33 - sleep
34 - sea serpent
35 - groundshaker
36 - hearts
37 - fire from above
38 - energy wave
39 - small cloud
40 - holy attack
41 - energy clouds
42 - falling ice
43 - tornado
44 - ice area
45 - falling stones
46 - small plants
47 - plant mouth
48 - purple energy
49 - yellow energy
50 - holy cross
51 - big plants
52 - cake
53 - frozen prison
54 - water splash
55 - big plants with scythe
56 - arrow marker
57 - square marker
58 - mirror looking down
59 - mirror loking east
60 - ghost face looking down
61 - ghost face looking east
62 - assassin bs
63 - dripping blood
64 - blood spots south
65 - blood spots east
66 - yalahari ghost
67 - bats
68 - smoke poof
69 - insect cloud
70 - moving dragon head
71 - orc shaman bs
72 - orc shaman bs
73 - shimmer of light
74 - ferumbras
75 - small confetti south
76 - small confetti east

--SHOOTEFFECTS
1 - spear
2 - bolt
3 - arrow
4 - fire
5 - energy
6 - poison arrow
7 - burst arrow
8 - throwing star
9 - throwing knife
10 - small stone
11 - death
12 - largerock
13 - snowball
14 - powerbolt
15 - poison
16 - infernal bolt
17 - hunting spear
18 - enchanted spear
19 - redstar
20 - greenstar
21 - royal spear
22 - sniper arrow
23 - onyx arrow
24 - piercing bolt
25 - whirlwind sword
26 - whirlwind axe
27 - whirlwind club
28 - ethereal spear
29 - ice
30 - earth
31 - holy
32 - sudden death
33 - flash arrow
34 - flaming arrow
35 - shiver arrow
36 - energy ball
37 - small ice
38 - small holy
39 - small earth
40 - eartharrow
41 - explosion
42 - cake
43 - tarsal arrow
44 - vortex bolt
45 - prismatic bolt
46 - crystalline arrow
47 - drill bolt
48 - envenomed arrow
49 - glooth spear
50 - simple arrow

MagicEffectNames magicEffectNames[] = {
    {"redspark",        CONST_ME_DRAWBLOOD},
    {"bluebubble",        CONST_ME_LOSEENERGY},
    {"poff",        CONST_ME_POFF},
    {"yellowspark",        CONST_ME_BLOCKHIT},
    {"explosionarea",    CONST_ME_EXPLOSIONAREA},
    {"explosion",        CONST_ME_EXPLOSIONHIT},
    {"firearea",        CONST_ME_FIREAREA},
    {"yellowbubble",    CONST_ME_YELLOW_RINGS},
    {"greenbubble",        CONST_ME_GREEN_RINGS},
    {"blackspark",        CONST_ME_HITAREA},
    {"teleport",        CONST_ME_TELEPORT},
    {"energy",        CONST_ME_ENERGYHIT},
    {"blueshimmer",        CONST_ME_MAGIC_BLUE},
    {"redshimmer",        CONST_ME_MAGIC_RED},
    {"greenshimmer",    CONST_ME_MAGIC_GREEN},
    {"fire",        CONST_ME_HITBYFIRE},
    {"greenspark",        CONST_ME_HITBYPOISON},
    {"mortarea",        CONST_ME_MORTAREA},
    {"greennote",        CONST_ME_SOUND_GREEN},
    {"rednote",        CONST_ME_SOUND_RED},
    {"poison",        CONST_ME_POISONAREA},
    {"yellownote",        CONST_ME_SOUND_YELLOW},
    {"purplenote",        CONST_ME_SOUND_PURPLE},
    {"bluenote",        CONST_ME_SOUND_BLUE},
    {"whitenote",        CONST_ME_SOUND_WHITE},
    {"bubbles",        CONST_ME_BUBBLES},
    {"dice",        CONST_ME_CRAPS},
    {"giftwraps",        CONST_ME_GIFT_WRAPS},
    {"yellowfirework",    CONST_ME_FIREWORK_YELLOW},
    {"redfirework",        CONST_ME_FIREWORK_RED},
    {"bluefirework",    CONST_ME_FIREWORK_BLUE},
    {"stun",        CONST_ME_STUN},
    {"sleep",        CONST_ME_SLEEP},
    {"watercreature",    CONST_ME_WATERCREATURE},
    {"groundshaker",    CONST_ME_GROUNDSHAKER},
    {"hearts",        CONST_ME_HEARTS},
    {"fireattack",        CONST_ME_FIREATTACK},
    {"energyarea",        CONST_ME_ENERGYAREA},
    {"smallclouds",        CONST_ME_SMALLCLOUDS},
    {"holydamage",        CONST_ME_HOLYDAMAGE},
    {"bigclouds",        CONST_ME_BIGCLOUDS},
    {"icearea",        CONST_ME_ICEAREA},
    {"icetornado",        CONST_ME_ICETORNADO},
    {"iceattack",        CONST_ME_ICEATTACK},
    {"stones",        CONST_ME_STONES},
    {"smallplants",        CONST_ME_SMALLPLANTS},
    {"carniphila",        CONST_ME_CARNIPHILA},
    {"purpleenergy",    CONST_ME_PURPLEENERGY},
    {"yellowenergy",    CONST_ME_YELLOWENERGY},
    {"holyarea",        CONST_ME_HOLYAREA},
    {"bigplants",        CONST_ME_BIGPLANTS},
    {"cake",        CONST_ME_CAKE},
    {"giantice",        CONST_ME_GIANTICE},
    {"watersplash",        CONST_ME_WATERSPLASH},
    {"plantattack",        CONST_ME_PLANTATTACK},
    {"tutorialarrow",    CONST_ME_TUTORIALARROW},
    {"tutorialsquare",    CONST_ME_TUTORIALSQUARE},
    {"mirrorhorizontal",    CONST_ME_MIRRORHORIZONTAL},
    {"mirrorvertical",    CONST_ME_MIRRORVERTICAL},
    {"skullhorizontal",    CONST_ME_SKULLHORIZONTAL},
    {"skullvertical",    CONST_ME_SKULLVERTICAL},
    {"assassin",        CONST_ME_ASSASSIN},
    {"stepshorizontal",    CONST_ME_STEPSHORIZONTAL},
    {"bloodysteps",        CONST_ME_BLOODYSTEPS},
    {"stepsvertical",    CONST_ME_STEPSVERTICAL},
    {"yalaharighost",    CONST_ME_YALAHARIGHOST},
    {"bats",        CONST_ME_BATS},
    {"smoke",        CONST_ME_SMOKE},
    {"insects",        CONST_ME_INSECTS},
    {"dragonhead",        CONST_ME_DRAGONHEAD},
    {"orcshaman",        CONST_ME_ORCSHAMAN},
    {"orcshamanfire",    CONST_ME_ORCSHAMAN_FIRE},
    {"thunder",        CONST_ME_THUNDER},
    {"ferumbras",        CONST_ME_FERUMBRAS},
    {"confettihorizontal",    CONST_ME_CONFETTI_HORIZONTAL},
    {"confettivertical",    CONST_ME_CONFETTI_VERTICAL},
    {"blacksmoke",        CONST_ME_BLACKSMOKE},
    {"redsmoke",        CONST_ME_REDSMOKE},
    {"yellowsmoke",        CONST_ME_YELLOWSMOKE},
    {"greensmoke",        CONST_ME_GREENSMOKE},
    {"purplesmoke",        CONST_ME_PURPLESMOKE},
};
 
ShootTypeNames shootTypeNames[] = {
    {"spear",        CONST_ANI_SPEAR},
    {"bolt",        CONST_ANI_BOLT},
    {"arrow",        CONST_ANI_ARROW},
    {"fire",        CONST_ANI_FIRE},
    {"energy",        CONST_ANI_ENERGY},
    {"poisonarrow",        CONST_ANI_POISONARROW},
    {"burstarrow",        CONST_ANI_BURSTARROW},
    {"throwingstar",    CONST_ANI_THROWINGSTAR},
    {"throwingknife",    CONST_ANI_THROWINGKNIFE},
    {"smallstone",        CONST_ANI_SMALLSTONE},
    {"death",        CONST_ANI_DEATH},
    {"largerock",        CONST_ANI_LARGEROCK},
    {"snowball",        CONST_ANI_SNOWBALL},
    {"powerbolt",        CONST_ANI_POWERBOLT},
    {"poison",        CONST_ANI_POISON},
    {"infernalbolt",    CONST_ANI_INFERNALBOLT},
    {"huntingspear",    CONST_ANI_HUNTINGSPEAR},
    {"enchantedspear",    CONST_ANI_ENCHANTEDSPEAR},
    {"redstar",        CONST_ANI_REDSTAR},
    {"greenstar",        CONST_ANI_GREENSTAR},
    {"royalspear",        CONST_ANI_ROYALSPEAR},
    {"sniperarrow",        CONST_ANI_SNIPERARROW},
    {"onyxarrow",        CONST_ANI_ONYXARROW},
    {"piercingbolt",    CONST_ANI_PIERCINGBOLT},
    {"whirlwindsword",    CONST_ANI_WHIRLWINDSWORD},
    {"whirlwindaxe",    CONST_ANI_WHIRLWINDAXE},
    {"whirlwindclub",    CONST_ANI_WHIRLWINDCLUB},
    {"etherealspear",    CONST_ANI_ETHEREALSPEAR},
    {"ice",            CONST_ANI_ICE},
    {"earth",        CONST_ANI_EARTH},
    {"holy",        CONST_ANI_HOLY},
    {"suddendeath",        CONST_ANI_SUDDENDEATH},
    {"flasharrow",        CONST_ANI_FLASHARROW},
    {"flammingarrow",    CONST_ANI_FLAMMINGARROW},
    {"shiverarrow",        CONST_ANI_SHIVERARROW},
    {"energyball",        CONST_ANI_ENERGYBALL},
    {"smallice",        CONST_ANI_SMALLICE},
    {"smallholy",        CONST_ANI_SMALLHOLY},
    {"smallearth",        CONST_ANI_SMALLEARTH},
    {"eartharrow",        CONST_ANI_EARTHARROW},
    {"explosion",        CONST_ANI_EXPLOSION},
    {"cake",        CONST_ANI_CAKE},
    {"tarsalarrow",        CONST_ANI_TARSALARROW},
    {"vortexbolt",        CONST_ANI_VORTEXBOLT},
    {"prismaticbolt",    CONST_ANI_PRISMATICBOLT},
    {"crystallinearrow",    CONST_ANI_CRYSTALLINEARROW},
    {"drillbolt",        CONST_ANI_DRILLBOLT},
    {"envenomedarrow",    CONST_ANI_ENVENOMEDARROW},
    {"gloothspear",        CONST_ANI_GLOOTHSPEAR},
    {"simplearrow",        CONST_ANI_SIMPLEARROW},
};

--Player Storage Values
Avaliable Primary Points - 39900
Avaliable Secondary Points - 39901
Lock pick cooldown - 39902
Fame points - 39903
First spellbook warning - 39904
Gems Consumed - 39905
Vitality Gems - 39906
Sorcery Gems - 39907
Fortitude Gems - 39908
Lethality Gems - 39909
The Arcane Gems - 39910
Total fame points acquired - 39911

--Attributes
Strenght - 40000
Dexterity - 40001
Intelligence - 40002
Luck - 40003
Constitution - 40004
Spirit - 40005
Wisdom - 40006

--Stage Selection
Catacombs - 49999
Sronghold - 49998

--Check current floor
6000 (1 for 1f, 2 for 2f, etc)

--Artifacts (50900 - 50999) // -1 = neutral, 0 = do you want to bound?, 1 = bound, 10 = active
Ancient Egg - 50900
Bloodstone - 50901
Pure Mana - 50902
Phoenix Idol - 50903
Sigil of Balance - 50904
Third Eye - 50905
Heavenly Vault Key - 50906
Vial of Toxic - 50907
Exotic Parfum - 50908
Dark Arts Manuscript - 50909
Idol of Kaathe - 50910
Unseen Act - 50911
Golem Heart - 50912

--Entering the dungeon
Qasim Dialogue - 50100
Is in the Dungeon - 50101
Free Pick - 30003
Free Lock Pick - 30004

--Trainers
Times used - 50200
Times used - 50201 - tile id that walksback

--Spells/Weapons
Crit Trigger - 40200
Hawkeye Stance - 40201
Berserk - 40202
Duel Stance - 40203
Toxic Ammo - 40204
Freezing Ammo - 40205
Shocking Ammo - 40206
Warlock Fire - 40207
Uses Fire - 40210
Uses Water - 40211
Uses Earth - 40213
Uses Wind - 40214
Uses Holy - 40215
Uses Death - 40216
Calida Summoned - 40221
Zephyr Summoned - 40222
Ceres Summoned - 40223
Nereid Summoned - 40224
Umbra Summoned - 40225
Elementals Summoned - 40226
Unsummon Elemental - 40227
Jet Boots CD - 40240
Scroll of Dark Arts summon - 40241
How many elements learned - 40242
Thrust stack storage - 40243

--Potions
potions - 40300

--Magic Spells Cooldown (They have to be turned off in the login.lua)
Conjure Lock Pick - 80000
Conjure Pick - 80001
Cast Light - 80002
Haste - 80003
Antidote - 80004
Mana Channeling - 80005
Self Heal - 80006
Firebolt - 80007
Fireball - 80008
Flame Wave - 80009
Wind Gale - 80010
Twister - 80011
Static Shock - 80012
Tremor - 80013
Regrowth - 80014
Acid Blast - 80015
Water Gush - 80016
Stream of Mana - 80017
Freezing Palm - 80018
Deathtouch - 80019
Body to Mind - 80020
Sudden Death - 80021
Heal - 80022
Smite - 80023
Repel Evil - 80024
Magic Blast - 80025
Equilibrium - 80031
Open Eye - 80032
Inspiration - 80033
Unseen Act - 80034
Golem Awakening - 80035
Homeward Path - 80036
Scorching Ray - 80037
Erupting Thunder - 80038
Wrath of Nature - 80039
Blizzard - 80040
Necrotic Impulse - 80041
Greater Healing - 80042
Call to Arms - 80043
Intervention - 80044
Conjure Calida - 80045 --shares cooldown with the other conjure spells
Conjure Zephyr - 80045
Conjure Ceres - 80045
Conjure Nereid - 80045
Conjure Umbra - 80045
Unsummon Elemental - 80046

--Physical Skills Cooldown (Just for a few)
Windrunner - 80100
Fissure - 80101


--FAME UIDS AND STORAGEIDS
-TASKBOARD 1 UID- 60200
-TASKBOARD 2 UID- 60201
-TASKBOARD 3 UID- 60203
Times extra secondary point - 60201
Hobgoblins - 85000
Baraku Hexer - 85001
Hoblord IV - 85002
Skeleton Warlock - 85003
Skeleton Ripper - 85004
Skeleton Captain - 85005
Gravekeeper - 85006
Undying - 85007
Darkwing Bat - 85008
Ghoul - 85009
Stalker - 85010
Banshee - 85011
Fettered Soul - 85012
Angwedh - 85013
The Hydra - 85014
Grizzly Bear - 85015
Vuku Voodoo - 85016
Vuku Bomber - 85017
Bugbear - 85018
Bugbear Champion - 85019
Magma dragon - 85020
Lackey - 85021
The Ringmaker - 85022
The Technomancer - 85023
The Champion - 85024
Demolitionist - 85025
Exterminator - 85026
Smelter Golem - 85027
Deployer - 85028
Arisen Soldier - 85029
Grand Vizier - 85030
Elder Beholder - 85031
Tomb Flayer - 85032
Aljueran - 85033
Aleaqrab - 85034
Alnaazir - 85035
--Floor completion
Floor 0 - 50000
Floor 1 - 50001
Floor 2 - 50002
Floor 3 - 50003
Floor 4 - 50004
Floor 5 - 50005
Floor 6 - 50006
Floor 7 - 50007
Floor 8 - 50008
Floor 9 - 50009
Floor 10 - 50010
--Artifact Chests
Floor 1 = 45299
Floor 2 = 43499
Floor 3 = 44299 and 44669
Floor 4 = 46199 and 46300
Floor 5 = 47199
Floor 6 = 48291
--Secret Rooms
Floor 1 rooms = 15300 and 15301
Floor 2 rooms = 15302 and 15303
Floor 3 rooms = 15304 and 15305
Floor 4 rooms = 15306 and 15307
Floor 6 rooms = 15308

--UNIQUE IDS
The Oracle Book - 40000
Dungeon Entrance - 40001
Dungeon Entrance - 40002
Free Pick - 30003
Free Lock Pick - 30004
Training Weapons - 30005
Training Weapons - 30006
Training Weapons - 30007
Training Weapons - 30008
Rapier - 30009
Dagger - 30010
Short Sword - 30011
Hand Axe - 30012
Short Spear - 30013
Iron mace - 30014
Short Bow - 30015
Crossbow - 30016
Sapphire Staff - 30017
Leather Boots - 30018
Leather Legs - 30019
Leather Vest - 30020
Leather Cap - 30021
Wooden Shield - 30022
Bag - 30023
Brown Mushroom - 30024

--LOCKED DOORS UIDS
40300 - 40399 (dex 1)
40400 - 40499 (dex 2)
40500 - 40599 (dex 3)
40600 - 40699 (dex 4)
40700 - 40799 (dex 5)
40800 - 40899 (dex 6)
40900 - 40999 (dex 7)

--BREAKABLE WALLS UIDS
41300 - 41399 (str 1)
41400 - 41499 (str 2)
41500 - 41599 (str 3)
41600 - 41699 (str 4)
41700 - 41799 (str 5)
41800 - 41899 (str 6)
41900 - 41999 (str 7)

--INTELLIGENCE INTERACTIONS UIDS
42300 - 42399 (int 1)
42400 - 42499 (int 2)
42500 - 42599 (int 3)
42600 - 42699 (int 4)
42700 - 42799 (int 5)
42800 - 42899 (int 6)
42900 - 42999 (int 7)

--0 FLOOR STORAGE UIDS
45000 - 45099 (actions and transformables)
45200 - 45298 (looting chests)
45299 (Artifact chest)
45300 - 45301 Floor Exit
45302 - 45304 Hoblord Teleport
45305 - Slime Queen check id

--1° FLOOR STORAGES UIDS
43300 - 43399 (levers and transformables)
43400 - 43498 (looting chests)
43499 (Artifact chest)
43500 - 43501 Exit
43502 - Shortcut

--2° FLOOR STORAGES UIDS
44000 - 44100 (unique ids of actions and transformables)
44200 - 44298 (looting chests)
44299 (Artifact chest)
44600 Dragon Pillar Storages / Boss Portal ID
44601 Corruption id 0 alive / 1 dead
44602 Wrath id 0 alive / 1 dead
44603 Hunger id 0 alive / 1 dead
44604 - 44605 Exit Portal
44606 - Shortcut
44607 - Serpent Keeper statue
44698 - Hydra stages: -1 until 50%, 1 until 25%, 2 until killed, 3 killed
44669 - Artifact chest
44999 - Player Storage Value for Hydra level reward

--3° FLOOR STORAGE UIDS
46000 - 46100 (unique ids of actions and transformables)
46015/46016 - throne room barrier --
46017/46021 - bear cave barrier
46018 - dictionary uid / knows the orc language storage
46019 - dictionary drawer uid
46020 - has given zunuguk the scroll
46022 - has given igug the teeth
46023 - has received the magic scroll from the king
46024 - 46025 Exit Portal
--cyclop dungeon
46026 - flamespewer door horizontal 1
46027 - flamespewer door horizontal 2
46028 - flamespewer door horizontal 3
46029 - flamespewer door horizontal 4
46030 - flamespewer door horizontal 5
46031 - flamespewer door vertical 1
46032 - flamespewer door vertical 2
46033 - flamespewer door vertical 3
46034 - flamespewer door vertical 4
46035 - flamespewer off switch
46036 - elevator 1
46037 - elevator 2
46038 - dragon lair barrier / vuku warlock demand completed
46039 - dragon lair barrier
46040 - 46043 - vuku warlock barrier 1
46044 - 46046 - vuku warlock barrier 2
46047 - 46064 - cyc fortress entrance uids --46051 IS USED ON IFRIT
46047 - left lever storage
46048 - right lever storage
46049 - gate open storage
46060 - inside mechanism
46065 - left tower lever1 / middle floor -1, upper floor 0, lower floor 1
46078 - left tower lever2 / elevator mechanism -1 not released / 1 released
46065 - 46078 - elevator uids
46079 - console to release the elevator / -1 not released / 1 released - needs power on
46080 - 46089 - console components
46090 - power on lever
46091/7 - destroyable palisade wall on dwarves dungeon
46098 - safe lever on palisade wall on dwarves dungeon
46200 - 46206 - dragon lair palisade wall, floors and lever
46070 - technomancer healing orb active
46207 - incinerator switch 1 / -1 active, 1 inactive
46208 - incinerator switch 2
46209 - left wing switch
46210 - right wing switch
46211 - left wing passage
46212 - right wing passage
46213 - left wing safe switch
46214 - right wing safe switch
--Artifact chest lever system
46215 - mechanism 1
46216 - 46228 - plataform 1
46229 - mechanism 2
46230 - 46241 - plataform 2
46242 - mechanism 3
46243 - 46254 - plataform 3
46255 - mechanism 4
46256 - 46267 - plataform 4
46268 - mechanism 5
46269 - 46280 - plataform 5
46269 - dwarf healing
46270 - dwarf haste
46271 - the champion dead or alive




46101 - 46198 (looting chests)
46199 (artifact chest)
46198 - Vuku voodo curse ID

--4° FLOOR STORAGE UIDS
47000 - 47197 (unique ids of actions and transformables)
47067 - 47068 Exit portal
47069 - Shortcut
46050 - Ifrit summon limit and death
46051 - Ifrit exit
47100 - 47198 - looting chests

--5° FLOOR STORAGE UIDS --Pyramid tomb
48000 - 48020 Mimics UIDs
48051 - Aleaqrab poison resistance
48052 - Aljueran device
48053 - 48056 - Aljueran obelisks
48057 - Aljueran death and barrier
48058 - Alaeqrab death and barrier
48059 - Alnaazir death and exit portal
48060 - Entrance portal
48061 - 48064 - Fountain INT device
48065 - Library entrance switch
48066 - Library entrance pillar
48067 - Library entrance lever
48068 - Obelisk of Aljueran killcount
48069 - Aljueran entrance
48070 - Aljueran exit
48071 - Watch dog paper clue
48072 - Watch dog paper poem1
48073 - Watch dog paper poem2
48074 - Watch dog paper poem3
48075 - Watch dog paper poem4
48076 - Dog 1 lever
48077 - Dog 2 lever
48078 - Dog 3 lever
48079 - Dog 4 lever
48080 - Dog 5 lever
48081 - Dog 6 lever
48082 - Dog 7 lever
48083 - Dog 8 lever
48084 - Dog 1 statue ON (starts OFF)
48085 - Dog 2 statue OFF (starts ON)
48086 - Dog 3 statue ON (starts ON)
48087 - Dog 4 statue OFF (starts OFF)
48088 - Dog 5 statue OFF (starts OFF)
48089 - Dog 6 statue ON (starts OFF)
48090 - Dog 7 statue OFF (starts ON)
48091 - Dog 8 statue ON (starts OFF)
48092 - Dog teleport entrance
48093 - Dog teleport exit
48094 - Poison pit switch
48095 - Aleaqrab exit
48096 - Baraku Assassin tile 1
48097 - Baraku Assassin tile 2
48098 - Baraku Assassin tile 3
48099 - Baraku Assassin tile 4
48100 - Baraku Assassin tile 5
48101 - Baraku Assassin tile 6
48102 - Baraku Assassin tile 7
48103 - Baraku Assassin tile 8
48104 - Baraku Assassin tile 9
48105 - Baraku Assassin tile 10
48106 - Str gate
48107 - Dex gate
48108 - Int gate
48109 - 48114 - Fog walls
48115 - Fog lever
48116 - Str gate exit
48117 - Dex gate exit
48118 - Int gate exit
48119 - Blood lever 1
48120 - Blood lever 2
48121 - Blood lever 3
48122 - Blood exit
48123 - Body slashed counter
48124 - 48135 - Bodies
48136 - 48137 - Blood gate
48138 - Boss entrance
48200 - 48290 - Looting chests
48291 - Artifact chest

--THE ASCENT
55000 stg - Is inside - uid ascent teleport
--First Ascent
55001 uid - Entrance teleport
55002 - F1 Switch
55003 - F1 Chest
55004 - F1 Exit
55005 - F2 Switch
55006 - F2 Chest
55007 - F2 Exit
55008 - F3 Switch
55009 - F3 Chest
55010 - F3 Exit
55011 - F4 Switch
55012 - F4 Chest
55013 - F4 Exit
55014 - F5 Switch
55015 - F5 Chest
55016 - F5 Exit
55017 - F6 Switch
55018 - F6 Chest
55019 - F6 Exit
55020 - F7 Switch
55021 - F7 Chest
55022 - F7 Exit
55023 - Boss Room Chest
55024 - Boss Room Shard
55025 - Boss Room Switch
55026 - Boss Room Exit
55027 - Id to prevent others from entering
55030 - Storage for having completed the first ascent



