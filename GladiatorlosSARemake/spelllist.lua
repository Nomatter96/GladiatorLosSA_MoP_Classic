--[[
	Some explaination how it is work
	
	GetSpellList store class and spells in a certain pattern
	CLASS = {
		[ID] = {soundName = "sound name from Voice_enUS folder", type = "chose one type buff / debuff / cast / success / kick"},
		...
	}

	Types:
	1. buff - add in "Buff Applied" and "Buff Down" in "Abilities".
		When buff down, then addon add itself current suffix "Down" to sondName (like "starfall" + "Down" = "starfallDown")
		Dont need copy past ability and rename soundName
	2. debuff - add in "Buff Applied" in "Abilities"
	3. cast - add in "Spell Cast" in "Abilities"
	4. success - add in "Spell Cast" and "Cast Success" in "Abilities"
	5. kick - you cant see that spell in "Abilities", but it is sound in battle when toggle "Enable interrupt" is active in "Abilities"

	How to chose wich type for spell:
	0. Open wowhead and define type of spell (buff, debuff or cast). (You can download addon idTip for easy finding spell id in game)
	1. buff - enemy spell, wich add buff on him or his partners (like warrior's recklessness or shaman's earth Shield)
		(but if this spell buff full party, then be better to chose "cast" type, because I guess addon start spamming spell sound)
	2. debuff - enemy spell, wich add debuff on you or your partners (like some stun or disarm)
		(but if this spell debuff multiple targets, then be better to chose "cast" type, because I guess addon start spamming spell sound)
	3. success - enemy spell, that have time cast and after you need hear "success" sound
	4. kick - enemy spell, that interrupt cast. If interrupt is success, then you hear spell sound else nothing
	5. cast - if none of the above list is fit, then chose this type 
]]

function GladiatorlosSA:GetSpellList ()
	return {
		DRUID = {
			[5229]  = { soundName = "enrage",                type = "buff"    },
			[61336] = { soundName = "survivalInstincts",     type = "buff"    },
			[29166] = { soundName = "innervate",             type = "buff"    },
			[22812] = { soundName = "barkskin",              type = "buff"    },
			[5217]  = { soundName = "tigersFury",            type = "buff"    },
			[22842] = { soundName = "frenziedRegeneration",  type = "buff"    },
			[16689] = { soundName = "naturesGrasp",          type = "buff"    },
			[17116] = { soundName = "naturesSwiftness",      type = "buff"    },
			[50334] = { soundName = "berserk",               type = "buff"    },
			[48518] = { soundName = "lunarEclipse",          type = "buff"    },
			[48517] = { soundName = "solarEclipse",          type = "buff"    },
			[16870] = { soundName = "clearcasting",          type = "buff"    },
			[52610] = { soundName = "savageRoar",            type = "buff"    },
			[69369] = { soundName = "predatorsSwiftness",    type = "buff"    },
			[48505] = { soundName = "starfall",              type = "buff"    },
			[1850]  = { soundName = "dash",                  type = "buff"    },
			[5211]  = { soundName = "bash",                  type = "debuff"  },
			[22570] = { soundName = "maim",                  type = "debuff"  },
			[9005]  = { soundName = "pounce",                type = "debuff"  },
			[2637]  = { soundName = "hibernate",             type = "success" },
			[33786] = { soundName = "cyclone",               type = "success" },
			[740]   = { soundName = "tranquility",           type = "cast"    },
			[33831] = { soundName = "forceOfNature",         type = "cast"    },
			[5215]  = { soundName = "prowl",                 type = "cast"    },
			[93985] = { soundName = "skullBash",             type = "kick"    }
		},

		HUNTER = {
			[3045]  = { soundName = "rapidFire",             type = "buff"    },
			[19263] = { soundName = "deterrence",            type = "buff"    },
			[19574] = { soundName = "bestialWrath",          type = "buff"    },
			[53480] = { soundName = "roarofsacrifice",       type = "buff"    },
			[34471] = { soundName = "theBeastWithin",        type = "buff"    },
			[54216] = { soundName = "mastersCall",           type = "buff"    },
			[34490] = { soundName = "silencingshot",         type = "debuff"  },
			[19386] = { soundName = "wyvernSting",           type = "debuff"  },
			[19503] = { soundName = "scatterShot",           type = "debuff"  },
			[90337] = { soundName = "petStun",               type = "debuff"  },
			[19577] = { soundName = "petStun",               type = "debuff"  },
			[1499]  = { soundName = "freezingTrap",          type = "debuff"  },
			[1513]  = { soundName = "scareBeast",            type = "success" },
			[60192] = { soundName = "freezingtrap",          type = "cast"    },
			[23989] = { soundName = "readiness",             type = "cast"    },
			[982]   = { soundName = "revivePet",             type = "cast"    }
			
		},

		MAGE = {
			[12043] = { soundName = "presenceOfMind",        type = "buff"    },
			[12042] = { soundName = "arcanePower",           type = "buff"    },
			[12472] = { soundName = "icyVeins",              type = "buff"    },
			[31643] = { soundName = "blazingSpeed",          type = "buff"    },
			[64343] = { soundName = "impact",                type = "buff"    },
			[48108] = { soundName = "hotStreak",             type = "buff"    },
			[57761] = { soundName = "brainFreeze",           type = "buff"    },
			[45438] = { soundName = "iceBlock",              type = "buff"    },
			[12051] = { soundName = "evocation",             type = "buff"    },
			[44572] = { soundName = "deepFreeze",            type = "debuff"  },
			[118]   = { soundName = "polymorph",             type = "success" },
			[28271] = { soundName = "polymorph",             type = "success" },
			[28272] = { soundName = "polymorph",             type = "success" },
			[61780] = { soundName = "polymorph",             type = "success" },
			[61721] = { soundName = "polymorph",             type = "success" },
			[61305] = { soundName = "polymorph",             type = "success" },
			[11129] = { soundName = "combustion",            type = "cast"    },
			[2139]  = { soundName = "counterspell",          type = "cast"    },
			[11958] = { soundName = "coldSnap",              type = "cast"    },
			[55342] = { soundName = "mirrorImage",           type = "cast"    },
			[31661] = { soundName = "dragonsBreath",         type = "cast"    },
			[66]    = { soundName = "invisibility",          type = "cast"    },
			[82676] = { soundName = "RingofFrost",           type = "cast"    }
		},

		DEATHKNIGHT = {
			[45529] = { soundName = "bloodTap",              type = "buff"    },
			[49016] = { soundName = "unholyfrenzy",          type = "buff"    },
			[55233] = { soundName = "vampiricBlood",         type = "buff"    },
			[48792] = { soundName = "iceboundFortitude",     type = "buff"    },
			[49039] = { soundName = "lichborne",             type = "buff"    },
			[51271] = { soundName = "pillarofFrost",         type = "buff"    },
			[48707] = { soundName = "antiMagicShell",        type = "buff"    },
			[49222] = { soundName = "boneShield",            type = "buff"    },
			[48266] = { soundName = "frostPresence",         type = "buff"    },
			[48263] = { soundName = "bloodPresence",         type = "buff"    },
			[48265] = { soundName = "unholyPresence",        type = "buff"    },
			[47476] = { soundName = "strangulate",           type = "debuff"  },
			[91800] = { soundName = "petStun",               type = "debuff"  },
			[49203] = { soundName = "hungeringCold",         type = "success" },
			[49028] = { soundName = "dancingRuneWeapon",     type = "cast"    },
			[48982] = { soundName = "runeTap",               type = "cast"    },
			[47568] = { soundName = "empowerRuneWeapon",     type = "cast"    },
			[49206] = { soundName = "summonGargoyle",        type = "cast"    },
			[51052] = { soundName = "antiMagicZone",         type = "cast"    },
			[47528] = { soundName = "mindFreeze",            type = "kick"    }
		},

		PALADIN = {
			[1044]  = { soundName = "handOfFreedom",         type = "buff"   },
			[498]   = { soundName = "divineProtection",      type = "buff"   },
			[31821] = { soundName = "auraMastery",           type = "buff"   },
			[1022]  = { soundName = "handOfProtection",      type = "buff"   },
			[642]   = { soundName = "divineShield",          type = "buff"   },
			[31884] = { soundName = "avengingWrath",         type = "buff"   },
			[6940]  = { soundName = "handofsacrifice",       type = "buff"   },
			[31842] = { soundName = "divineFavor",           type = "buff"   },
			[54428] = { soundName = "divinePlea",            type = "buff"   },
			[853]   = { soundName = "hammerOfJustice",       type = "debuff" },
			[20066] = { soundName = "repentance",            type = "debuff" },
			[10326] = { soundName = "turnEvil",              type = "cast"   },
			[96231] = { soundName = "Rebuke",                type = "kick"   }
		},

		PRIEST = {
			[33206] = { soundName = "painSuppression",       type = "buff"    },
			[10060] = { soundName = "powerInfusion",         type = "buff"    },
			[6346]  = { soundName = "fearWard",              type = "buff"    },
			[47788] = { soundName = "GuardianSpirit",        type = "buff"    },
			[47585] = { soundName = "dispersion",            type = "buff"    },
			[15487] = { soundName = "silence",               type = "debuff"  },
			[64044] = { soundName = "psychicHorror",         type = "debuff"  },
			[605]   = { soundName = "mindControl",           type = "success" },
			[8129]  = { soundName = "manaBurn",              type = "cast"    },
			[32375] = { soundName = "massDispel",            type = "cast"    },
			[64843] = { soundName = "divineHymn",            type = "cast"    },
			[9484]  = { soundName = "shackleUndead",         type = "cast"    },
			[8122]  = { soundName = "fear",                  type = "cast"    },
			[34433] = { soundName = "shadowFiend",           type = "cast"    },
			[32379] = { soundName = "shadowWordDeath",       type = "cast"    }
		},

		ROGUE = {
			[5277]  = { soundName = "evasion",               type = "buff"   },
			[31224] = { soundName = "cloakOfShadows",        type = "buff"   },
			[13750] = { soundName = "adrenalineRush",        type = "buff"   },
			[51690] = { soundName = "killingSpree",          type = "buff"   },
			[51713] = { soundName = "shadowDance",           type = "buff"   },
			[57934] = { soundName = "trickOfTheTrade",       type = "buff"   },
			[45182] = { soundName = "cheatingDeath",         type = "buff"   },
			[2983]  = { soundName = "sprint",                type = "buff"   },
			[13877] = { soundName = "bladeflurry",           type = "buff"   },
			[2094]  = { soundName = "blind",                 type = "debuff" },
			[408]   = { soundName = "kidney",                type = "debuff" },
			[1776]  = { soundName = "gouge",                 type = "debuff" },
			[51722] = { soundName = "disarm2",               type = "debuff" },
			[1833]  = { soundName = "cheapShot",             type = "debuff" },
			[6770]  = { soundName = "sap",                   type = "debuff" },
			[703]   = { soundName = "garrote",               type = "debuff" },
			[14177] = { soundName = "coldBlood",             type = "cast"   },
			[1784]  = { soundName = "stealth",               type = "cast"   },
			[14185] = { soundName = "preparation",           type = "cast"   },
			[36554] = { soundName = "shadowstep",            type = "cast"   },
			[1856]  = { soundName = "vanish",                type = "cast"   },
			[1766]  = { soundName = "kick",                  type = "kick"   }
		},

		SHAMAN = {
			[16166] = { soundName = "elementalMastery",      type = "buff"    },
			[30823] = { soundName = "shamanisticRage",       type = "buff"    },
			[16188] = { soundName = "naturesSwiftness",      type = "buff"    },
			[974]   = { soundName = "earthShield",           type = "buff"    },
			[52127] = { soundName = "waterShield",           type = "buff"    },
			[51514] = { soundName = "hex",                   type = "success" },
			[8143]  = { soundName = "tremorTotem",           type = "cast"    },
			[8177]  = { soundName = "groundingTotem",        type = "cast"    },
			[16190] = { soundName = "manaTideTotem",         type = "cast"    },
			[51533] = { soundName = "feralSpirit",           type = "cast"    },
			[57994] = { soundName = "windShear",             type = "kick"    }
		},

		WARLOCK = {
			[47241] = { soundName = "metamorphosis",         type = "buff"    },
			[79460] = { soundName = "demonsoul",             type = "buff"    },
			[79462] = { soundName = "demonsoul1",            type = "buff"    },
			[6789]  = { soundName = "deathcoil",             type = "debuff"  },
			[24259] = { soundName = "spellLock",             type = "debuff"  },
			[5782]  = { soundName = "fear",                  type = "success" },
			[50796] = { soundName = "chaosBolt",             type = "success" },
			[6358]  = { soundName = "seduction",             type = "success" },
			[688]   = { soundName = "summonImp",             type = "cast"    },
			[697]   = { soundName = "summonVoidwalker",      type = "cast"    },
			[712]   = { soundName = "summonSuccube",         type = "cast"    },
			[691]   = { soundName = "summonFelhunter",       type = "cast"    },
			[30146] = { soundName = "summonFelGuard",        type = "cast"    },
			[5484]  = { soundName = "howlOfTerror",          type = "cast"    },
			[48020] = { soundName = "demonicCircleTeleport", type = "cast"    },
			[30283] = { soundName = "shadowfury",            type = "cast"    }
		},

		WARRIOR = {
			[55694] = { soundName = "enragedRegeneration",   type = "buff"    },
			[46924] = { soundName = "bladestorm",            type = "buff"    },
			[871]   = { soundName = "shieldWall",            type = "buff"    },
			[18499] = { soundName = "berserkerRage",         type = "buff"    },
			[1719]  = { soundName = "recklessness",          type = "buff"    },
			[23920] = { soundName = "spellReflection",       type = "buff"    },
			[12292] = { soundName = "deathWish",             type = "buff"    },
			[12975] = { soundName = "lastStand",             type = "buff"    },
			[20230] = { soundName = "Retaliation",           type = "buff"    },
			[12328] = { soundName = "sweepingStrikes",       type = "buff"    },
			[676]   = { soundName = "disarm",                type = "debuff"  },
			[12809] = { soundName = "concussionBlow",        type = "debuff"  },
			[12809] = { soundName = "shockwave",             type = "debuff"  },
			[85388] = { soundName = "throwdown",             type = "debuff"  },
			[64382] = { soundName = "shatteringThrow",       type = "success" },
			[5246]  = { soundName = "fear",                  type = "cast"    },
			[2457]  = { soundName = "battleStance",          type = "cast"    },
			[71]    = { soundName = "defensiveStance",       type = "cast"    },
			[2458]  = { soundName = "berserkerStance",       type = "cast"    },
			[6552]  = { soundName = "pummel",                type = "kick"    }
		}
	}
end

function GladiatorlosSA:IsPvPTrinket(spellID)
	local pvpTrinket = 42292
	local willToSurvive = 59752
	return (spellID == pvpTrinket) or (spellID == willToSurvive)
end

function GladiatorlosSA:IsEpicBG(instanceMapID)
	return instanceMapID == 2118 or -- Wintergrasp
		instanceMapID == 30 or      -- Alterac Valley
		instanceMapID == 628 or     -- Isle of Conquest
		instanceMapID == 2755       -- Tol Barad
end

function GladiatorlosSA:FindSpellByID(spellID)
	for _,kind in pairs(self.spellList) do
        for id,body in pairs(kind) do
			if id == spellID then
				return body
			end
		end
	end
	return nil
end

function GladiatorlosSA:GetClassByPet(petGUID)
	local unitType, _, _, _, _, petID, _ = strsplit("-", petGUID)
	if (unitType ~= "Pet") then
		return nil
	end
	petID = tonumber(petID)
	if petID == 510 then
		return "MAGE"
	elseif petID == 26125 or petID == 31411 then
		return "DEATHKNIGHT"
	elseif petID == 417 or petID == 1863 or petID == 416 or petID == 17252 or petID == 1860 then
		return "WARLOCK"
	else
		return "HUNTER"
	end
end
