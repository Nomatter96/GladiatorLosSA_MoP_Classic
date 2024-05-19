function GladiatorlosSA:GetSpellList ()
	return {
		auraApplied ={					-- aura applied [spellid] = ".mp3 file name",
			-- GENERAL

			general = {
				[34709] = "shadowSight",
				[44055] = "battlemaster",
				[54861] = "nitroBoost",
				[54758] = "hyperspeedAccelerator",
			},
			drinking = {
				[5006] = "drinking",
			},

			druid = {
				[5229] = "enrage",
				[61336] = "survivalInstincts",
				[29166] = "innervate",
				[22812] = "barkskin",
				[5217] = "tigersFury",
				[22842] = "frenziedRegeneration",
				[16689] = "naturesGrasp",
				[17116] = "naturesSwiftness",
				[50334] = "berserk",
				[48518] = "lunarEclipse",
				[48517] = "solarEclipse",
				[16870] = "clearcasting",
				[52610] = "savageRoar",
				[69369] = "predatorsSwiftness",
			},

			hunter = {
				[3045] = "rapidFire",
				[19577] = "intimidation",
				[19263] = "deterrence",
				[19574] = "bestialWrath",
				[53480] = "roarofsacrifice",
				[34471] = "theBeastWithin",
				[54216] = "mastersCall",
				[34026] = "killCommand",
				-- Check on friendly
				[1499] = "freezingTrap", -- Freezing Trap
			},

			mage = {
				[543] = "mageArmor",
				[7302] = "frostArmor",
				[1463] = "manaShield",
				[11426] = "iceBarrier",
				[12043] = "presenceOfMind",
				[12042] = "arcanePower",
				[11129] = "combustion",
				[12472] = "icyVeins",
				[31643] = "blazingSpeed",
				[64343] = "impact",
				[48108] = "hotStreak",
				[57761] = "brainFreeze",
			},

			dk = {
				[45529] = "bloodTap",
				[49028] = "dancingRuneWeapon",
				[49016] = "hysteria",
				[55233] = "vampiricBlood",
				[57330] = "hornOfWinter",
				[48792] = "iceboundFortitude",
				[49039] = "lichborne",
				[51271] = "pillarofFrost",
				[48707] = "antiMagicShell",
				[51052] = "antiMagicZone",
				[49222] = "boneShield",
			},

			paladin = {
				[1044] = "handOfFreedom",
				[498] = "divineProtection",
				[31821] = "auraMastery",
				[1022] = "handOfProtection",
				[20164] = "sealOfJustice",
				[642] = "divineShield",
				[31884] = "avengingWrath",
				[6940]  = "handofsacrifice",
				[1038]  = "handofsalvation",
				[31842] = "divineFavor",
				[20178] = "reckoning",
				[853] = "hammerOfJustice",
				[54428] = "divinePlea",
				[53563] = "beaconOfLight",
				[85285] = "sacredShield", -- idk why toggle is empty
			},

			priest = {
				[33206] = "painSuppression",
				[10060] = "powerInfusion",
				[6346] = "fearWard",
				[15286] = "vampiricEmbrace",
				[47788] = "GuardianSpirit",
				[47585] = "dispersion",
				[586]   = "fade",
				[15473] = "shadowForm",
			},

			rogue = {
				[5277] = "evasion",
				[31224] = "cloakOfShadows",
				[14177] = "coldBlood",
				[13750] = "adrenalineRush",
				[51690] = "killingSpree", 
				-- Check on friendly
				[1833] = "cheapShot",
				[6770] = "sap",
				[703] = "garrote",
				[51713] = "shadowDance",
				[57934] = "trickOfTheTrade",
				[45182] = "cheatingDeath",
			},

			shaman = {
				[16166] = "elementalMastery",
				[30823] = "shamanisticRage",
				[16188] = "naturesSwiftness",
				[974] = "earthShield",
				[52127] = "waterShield",
			},

			warlock = {
				[6229] = "shadowWard",
				[18708] = "felDomination",
				[47241] = "metamorphosis",
			},

			warrior = {
				[55694] = "enragedRegeneration",
				[46924] = "bladestorm",
				[871] = "shieldWall",
				[18499] = "berserkerRage",
				[1719] = "recklessness",
				[23920] = "spellReflection",
				[12292] = "deathWish",
				[12975] = "lastStand",
				[20230] = "Retaliation",
				[23881] = "bloodthirst",
			},
		},
		auraRemoved = {					-- aura removed [spellid] = ".mp3 file name",
			general = {
				[44055] = "battlemasterDown",
				[34709] = "shadowSightDown",
				[54861] = "nitroBoostDown",
				[54758] = "hyperspeedAceleratorDown",
			},
			
			races = {
				[58984] = "shadowmeldDown",
				[26297] = "berserkingDown",
				[20594] = "stoneformDown",
				[20572] = "bloodFuryDown",
				[33702] = "bloodFuryDown",
				[7744] = "willOfTheForsakenDown",
				[28880] = "giftOfTheNaaruDown",
				[28730] = "arcaneTorrentDown",
				[25046] = "arcaneTorrentDown",
				[50613] = "arcaneTorrentDown",
			},

			druid = {
				[22812] = "barkskinDown",
				[29166] = "innervateDown",
				[16689] = "naturesGraspDown",
				[48505] = "starfallDown",
				[50334] = "berserkDown",
				[1850] = "dashDown",
				[5229] = "enrageDown",
				[22842] = "frenziedRegenerationDown",
				[52610] = "savageRoarDown",
				[61336] = "survivalInstinctsDown",
				[69369] = "predatorsSwiftnessDown",
				[17116] = "naturesSwiftnessDown",
			},

			hunter = {
				[34026] = "killCommandDown",
				[54216] = "mastersCallDown",
				[34471] = "theBeastWithinDown",
				[3045] = "rapidFireDown",
				[19263] = "deterrenceDown",
			},

			mage = {
				[12042] = "arcanePowerDown",
				[66] = "invisibilityDown",
				[1463] = "mageArmorDown", -- no sound
				[11129] = "combustionDown",
				[12043] = "presenceOfMindDown",
				[64343] = "impactDown",
				[48108] = "hotStreakDown",
				[7302] = "frostArmorDown",
				[11426] = "iceBarrierDown",
				[45438] = "iceBlockDown",
				[12472] = "icyveinsDown",
				[543] = "mageWardDown",
				[31643] = "blazingSpeedDown",
				[57761] = "brainFreezeDown",
			},

			paladin = {
				[31821] = "auraMasteryDown",
				[53563] = "beaconOfLightDown",
				[54428] = "divinePleaDown",
				[85285] = "sacredShieldDown", -- idk why toggle is empty
				[25771] = "forbearanceDown",
				[498] = "divineProtectionDown", -- Rank 1
				[642] = "divineShieldDown", -- Rank 1
				[31842] = "divineFavorDown",
				[1044] = "handOfFreedomDown",
				[1022] = "handOfProtectionDown",
				[6940] = "handofsacrificeDown",
				[1038] = "handofsalvationDown",
				[20178] = "reckoningDown",
				[31884] = "avengingWrathDown",
			},

			priest = {
				[6346] = "fearWardDown",
				[48168] = "innerFireDown", 
				[33206] = "painSuppressionDown",
				[10060] = "powerInfusionDown",
				[47788] = "guardianSpiritDown",
				[47585] = "dispersionDown",
				[586] = "fadeDown",	
				[15473] = "shadowFormDown",
			},

			rogue = {
				[14177] = "coldBloodDown",
				[13750] = "adrenalineRushDown",
				[5277] = "evasionDown",
				[51690] = "killingSpreeDown",
				[2983] = "sprintDown",
				[31224] = "cloakDown",
				[51713] = "shadowDanceDown",
				[57934] = "trickOfTheTradeDown",
				[45182] = "cheatingDeathDown",
			},

			shaman = {
				[16166] = "elementalMasteryDown",
				[32182] = "heroismDown", 
				[2825] = "bloodlustDown",
				[30823] = "shamanisticRageDown",
				[16188] = "naturesSwiftnessDown",
			},

			warlock = {
				[18708] = "felDominationDown",
				[47241] = "metamorphDown",
			},

			dk = {
				[45529] = "bloodTapDown",
				[49028] = "dancingRuneWeaponDown",
				[49016] = "hysteriaDown",
				[55233] = "vampiricBloodDown",
				[57330] = "hornOfWinterDown",
				[48792] = "iceboundFortitudeDown",
				[49039] = "lichborneDown",
				[51271] = "pillarofFrostDown",
				[48707] = "antiMagicShellDown",
				[51052] = "antiMagicZoneDown",
				[49222] = "boneShieldDown",
			},

			warrior = {
				[46924] = "bladestormDown",
				[20230] = "RetaliationDown",
				[12328] = "sweepingStrikesDown",
				[18499] = "berserkerRageDown",
				[12292] = "deathWishDown",
				[55694] = "enragedRegenerationDown",
				[12975] = "lastStandDown",
				[1719] = "recklessnessDown",
				[871] = "shieldWallDown",
				[23920] = "spellReflectionDown",
			},
		},
		castStart = {					-- cast start [spellid] = ".mp3 file name",
		
		--GENERAL
			big_heal = {
				[635] = "bigHeal",	--Holy Light
				[2060] = "bigHeal",		--Greater Heal
				[331] = "bigHeal",	--Healing Wave
				[5185] = "bigHeal",		--Healing Touch
			},
			
			-- Non-Combat Resurrections
			res = {
				[2006] = "resurrection",	--Resurrection (priest)
				[7328] = "resurrection",	--Redemption
				[2008] = "resurrection",	--Ancestral Spirit
				[50769] = "resurrection",	--Revive
			},

			druid = {
				[2637] = "hibernate",
				[33786] = "cyclone",
				[2912] = "starfire",
				[740] = "tranquility",
			},

			hunter = {
				[19434] = "aimedShot",
				[982] = "revivePet",
				[1513] = "scareBeast",
			},

			mage = {
				[118] = "polymorph", -- (Sheep)
				[28271] = "polymorph", -- (Turtle)
				[28272] = "polymorph", -- (Pig)
				[61305] = "polymorph",
				[61721] = "polymorph",
				[61025] = "polymorph",
				[61780] = "polymorph",
				[12051] = "evocation",
			},

			paladin = {
				[10326] = "turnEvil",
			},

			-- This is when the drinking started so maybe double check later when I'm sober  vvvvv

			priest = {
				[605] = "mindControl",
				[8129] = "manaBurn",
				[32375] = "massDispel",
				[64843] = "divineHymn",
				[9484]  = "shackleUndead",
			},

			rogue = {
				[1842]  = "disarmTrap",
			},

			shaman = {
				[51514] = "hex",
				[51505] = "lavaBurst",
			},		

			warlock = {
				[688] = "summonImp", -- Imp
				[697] = "summonVoidwalker", -- Voidwalker
				[712] = "summonSuccube", -- Succubus
				[691] = "summonFelhunter", -- Felhunter
				[30146] = "summonFelGuard", -- Felguard
				[1122] = "summonInfernal", -- no sound
				[5782] = "fear",
				[5484] = "howlOfTerror",
				[30108] = "unstableAffliction",
				[710] = "banish",
				[29893] = "createHealthstone", -- Ritual of Souls
				[6201] = "createHealthstone", -- Create Healthstone
				[689] = "drainLife",
				[6353] = "soulFire",
				[48018] = "demonicCircleSummon",
				[50796] = "chaosBolt",
			},

			warrior = {
				[64382] = "shatteringThrow",
			},
		},
		castSuccess = {					--cast success [spellid] = ".mp3 file name",
--[[			-- Cure (DPS Dispel)
			[51886] = "cure", 		-- Cleanse Spirit (Enhancement/Elemental Shaman)
			[2782] = "cure", 		-- Remove Corruption (Guardian/Feral/Balance Druid)
			[475] = "cure",			-- Remove Curse (Mage)
			--I miss Remove Curse for mages. :( This spot is reserved for its memory. ]]
			
--[[			-- Dispel (Healer (Magic) Dispel)
			[4987] = "dispel", 		-- Cleanse (Holy Paladin)
			[527] = "dispel", 		-- Purify (Holy/Discipline Priest)]]
			
			-- CastSuccess (Major, cast-time CCs that went off)
			-- CastSuccess (Major non-CC spells that connect)
			druid_success = {
				[2637] = "success", -- Hibernate
				[33786] = "success", -- Cyclone
			},
			
			hunter_success = {
				[1513] = "success", -- Scare Beast
			},
			
			mage_success = {
				[118] = "success", -- Polymorph Rank 1 (Sheep)
				[28271] = "success", -- Polymorph Rank 1 (Turtle)
				[28272] = "success", -- Polymorph Rank 1 (Pig)
			},

			priest_success = {
				[605] = "success", -- Mind Control
				[8129] = "connected", -- Mana Burn
			},
			
			warlock_success = {
				[5782] = "success", -- Fear
				[6353] = "connected", -- Soul Fire
			},
			
			shaman_success = {
				[51514] = "success", -- Hex
			},

			-- Purges
			-- PH
		
			--GENERAL
			races = {
				[28730] = "arcaneTorrent",
				[25046] = "arcaneTorrent",
				[50613] = "arcaneTorrent",
				[58984] = "shadowmeld",
				[26297] = "berserking",
				[20594] = "stoneform",
				[20572] = "bloodFury",
				[33702] = "bloodFury",
				[7744]  = "willOfTheForsaken",
				[28880] = "giftOfTheNaaru",
			},
			
			trinket = {
				[59752] = "trinket", -- Every Man (Human)
				[42292] = "trinket", -- Inherited Insignias (Heirloom PvP Trinkets)
			},

			druid = {
				[2782] = "removeCurse",
				[5211] = "bash",
				[5215] = "prowl",
				[1850] = "dash",
				[770] = "faeryFire",
				[33831] = "forceOfNature",
				[18562] = "swiftmend",
				[48505] = "starfall",	--starfall
				[16979] = "feralChargeBear",
				[49376] = "feralChargeCat",
				[22570] = "maim",
				[9005] = "pounce",
			},

			hunter = {
				[5116] = "concussiveShot",
				[1543] = "flare",
				[1130] = "huntersMark",
				[1499] = "freezingTrap",
				[60192] = "freezingtrap", --double check
				[13810] = "frostTrap", --frost trap aura
				[13809] = "frostTrap", --frost trap aura
				[34490] = "silencingshot",
				[19801] = "tranquilizingShot",
				[23989] = "readiness",
				[19386] = "wyvernSting",
				[19503] = "scatterShot",
				[3044] = "arcaneShot",
				[53271] = "masterscall",
				[781]   = "disengage",
				[34600] = "snaketrap",
			},

			mage = {
				[1953] = "blink",
				[2139] = "counterspell",
				[45438] = "iceBlock",
				[42987] = "manaGem",
				[122] = "frostNova",
				[66] = "invisibility",
				[30449] = "spellSteal",
				[11113] = "blastWave",
				[11958] = "coldSnap",
				[31687] = "summonWaterElemental",
				[44572] = "deepFreeze",
				[55342] = "mirrorImage",
				[475]   = "removeCurse",
				[31661] = "dragonsBreath",
				[33395] = "petFreeze",
			},

			dk = {
				[48721] = "bloodBoil", 
				[48266] = "frostPresence",
				[48982] = "runeTap", 
				[47476] = "strangulate",
				[45524] = "chainOfIce", 
				[47568] = "empowerRuneWeapon",
				[48263] = "bloodPresence", 
				[49203] = "hungeringCold",
				[47528] = "mindFreeze",
				[43265] = "deathAndDecay", 
				[49576] = "deathGrip", 
				[61999] = "raiseAlly", 
				[46584] = "raiseDead", 
				[49206] = "summonGargoyle",
				[48265] = "unholyPresence",
				[47481] = "petStun", 
			},

			paladin = {
				[20271] = "judgementOfLight",
				[4987] = "cleanse",
				[853] = "hammerOfJustice",
				[633] = "layOnHands",
				[20473] = "holyShock",
				[20066] = "repentance",
				[19746] = "concentrationAura",
			},

			priest = {
				[528] = "cureDisease",
				[527] = "dispelMagic",
				[8122] = "Fear4",
				[34433] = "shadowFiend",
				[2944] = "devouringPlague",
				[32379] = "shadowWordDeath",
				[15487] = "silence",
				[64044] = "psychicHorror", --psychic horror
				[15237] = "holyNova",
				[48045] = "mindSear",
			},

			rogue = {
				[2094] = "blind",
				[408] = "kidney",
				[2983] = "sprint",
				[1784] = "stealth",
				[1856] = "vanish",
				[1776] = "gouge",
				[1766] = "kick",
				[14185] = "preparation",
				[36554] = "shadowstep",
				[51722] = "disarm2", --dismantle
				[6770] = "sap",
				[13877] = "bladeflurry",
				[51723] = "fanOfKnive",
			},

			shaman = {
				[2484] = "earthbindTotem",
				[8143] = "tremorTotem",
				[8177] = "groundingTotem",
				[370] = "purge",
				[8042] = "earthShock",
				[2062] = "earthElementalTotem",
				[2894] = "fireElementalTotem",
				[2825] = "bloodlust",
				[32182] = "heroism", -- Heroism
				[16190] = "manaTideTotem",
				[8143] = "tremorTotem", --works
				[65992] = "tremorTotem", --dont know which one
				[51533] = "feralSpirit",
				[51490] = "thunderstorm",
				[51886] = "cleanseSpirit",
			},

			warlock = {
				[5484] = "fear2", --Howl of Terror
				[19647] = "spellLock",
				[48020] = "demonicCircleTeleport",
				[6789] = "deathcoil",
				[30283] = "shadowfury",
				[6358] = "seduction",
			},

			warrior = {
				[676] = "disarm",
				[5246] = "Fear3",
				[6552] = "pummel",
				[100] = "charge",
				[20252] = "intercept",
				[12328] = "sweepingStrikes",
				[12809] = "concussionBlow",
				[2457] = "battleStance",
				[71] = "defensiveStance",
				[2458] = "berserkerStance",
				[57755] = "heroicThrow",
				[6572] = "revenge",
				[46968] = "shockwave",
				[7386]  = "sunderArmor",
				[85388] = "throwdown",
			},
		},
		friendlyInterrupt = {			--friendly interrupt [spellid] = ".mp3 file name",
			interrupt = {
				[19647] = "lockout",
				[2139] = "lockout", -- Counterspell
				[1766] = "lockout", -- Kick
				[6552] = "lockout", -- Pummel
				[47528] = "lockout", -- Mind Freeze
				[96231] = "lockout", -- Rebuke
				[93985] = "lockout", -- Skull Bash
				[97547] = "lockout", -- Solar Beam
				[57994] = "lockout", -- Wind Shear
				[116705] = "lockout", -- Spear Hand Strike
				[147362] = "lockout", -- Counter Shot
				[183752] = "lockout", -- Consume Magic (Demon Hunter)
				[187707] = "lockout", -- Muzzle (Survival Hunter)
			},
		},
		friendlyInterrupted = {			--friendly interrupt [spellid] = ".mp3 file name",
			interrupt = {
				[19647] = "interrupted",
				[2139] = "interrupted", -- Counterspell
				[1766] = "interrupted", -- Kick
				[6552] = "interrupted", -- Pummel
				[47528] = "interrupted", -- Mind Freeze
				[96231] = "interrupted", -- Rebuke
				[93985] = "interrupted", -- Skull Bash
				[97547] = "interrupted", -- Solar Beam
				[57994] = "interrupted", -- Wind Shear
				[116705] = "interrupted", -- Spear Hand Strike
				[147362] = "interrupted", -- Counter Shot
				[183752] = "interrupted", -- Consume Magic (Demon Hunter)
				[187707] = "interrupted", -- Muzzle (Survival Hunter)
			},
		},
	}
end
