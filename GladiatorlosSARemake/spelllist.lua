--[[
	Some explaination how it is work
	
	GetSpellList store class and spells in a certain pattern
	CLASS = {
		[ID] = {
			soundName = "sound name from Voice_enUS folder *".mp3" or *".ogg", (Voice sound is Neospeech Julie)
			durationSound = seconds (if you don't know about duration sound, you can use https://editor.audio/ or print 1.0 if you don't care),
			type = "chose one type buff / debuff / cast / success / kick"
		},
		...
	}

	Types:
	1. buff - add in "Buff Applied" and "Buff Down" in "Abilities".
		When buff down, then addon sound itself suffix "Down" after sond spell
		Dont need copy past ability and rename soundName and add second soundfile like spellNameDown (it's useless)
	2. debuff - add in "Buff Applied" in "Abilities"
	3. ability - add in "Spell Cast" in "Abilities"
	4. cast - add in "Spell Cast" and "Cast Success" in "Abilities"
	5. kick - you cant see that spell in "Abilities", but it is sound in battle when toggle "Enable interrupt" is active in "Abilities"

	How to chose wich type for spell:
	0. Open wowhead and define type of spell (buff, debuff or cast). (You can download addon idTip for easy finding spell id in game)
	1. buff - enemy spell, wich add buff on him or his partners (like warrior's recklessness or shaman's earth Shield)
		(but if this spell buff full party, then be better to chose "ability" type, because I guess addon start spamming spell sound)
	2. debuff - enemy spell, wich add debuff on you or your partners (like some stun or disarm)
		(but if this spell debuff multiple targets, then be better to chose "ability" type, because I guess addon start spamming spell sound)
	3. cast - enemy spell, that have time cast and after you need hear "cast" sound "success"
	4. kick - enemy spell, that interrupt cast. If interrupt is success, then you hear spell sound else nothing
	5. ability - if none of the above list is fit, then chose this type
]]

function GladiatorlosSA:GetSpellList()
	return {
		GENERAL = {
			[34709] = { soundName = "shadowSight.mp3",           durationSound = 0.85, type = "buff"    },
			[44055] = { soundName = "battlemaster.mp3",          durationSound = 0.9,  type = "buff"    }
		},

		RACIAL = {
			[58984] = { soundName = "shadowmeld.mp3",            durationSound = 0.9,  type = "buff"    },
			[26297] = { soundName = "berserking.mp3",            durationSound = 0.8,  type = "buff"    },
			[65116] = { soundName = "stoneform.mp3",             durationSound = 0.95, type = "buff"    },
			[20572] = { soundName = "bloodFury.mp3",             durationSound = 0.75, type = "buff"    }, -- Blizzard's Copy past start
			[33697] = { soundName = "bloodFury.mp3",             durationSound = 0.75, type = "buff"    },
			[33702] = { soundName = "bloodFury.mp3",             durationSound = 0.75, type = "buff"    }, -- Blizzard's Copy past end
			[28880] = { soundName = "giftOfTheNaaru.mp3",        durationSound = 0.9,  type = "buff"    },
			[28730] = { soundName = "arcaneTorrent.mp3",         durationSound = 0.9,  type = "debuff"  }, -- Blizzard's Copy past start
			[80483] = { soundName = "arcaneTorrent.mp3",         durationSound = 0.9,  type = "debuff"  },
			[25046] = { soundName = "arcaneTorrent.mp3",         durationSound = 0.9,  type = "debuff"  },
			[50613] = { soundName = "arcaneTorrent.mp3",         durationSound = 0.9,  type = "debuff"  },
			[69179] = { soundName = "arcaneTorrent.mp3",         durationSound = 0.9,  type = "debuff"  }, -- Blizzard's Copy past end
			[7744]  = { soundName = "willOfTheForsaken.mp3",     durationSound = 1.1,  type = "ability" }
		},
		
		DRUID = {
			[5229]  = { soundName = "enrage.mp3",                durationSound = 0.65, type = "buff"    },
			[61336] = { soundName = "survivalInstincts.mp3",     durationSound = 1.24, type = "buff"    },
			[29166] = { soundName = "innervate.mp3",             durationSound = 0.55, type = "buff"    },
			[22812] = { soundName = "barkskin.mp3",              durationSound = 0.78, type = "buff"    },
			[5217]  = { soundName = "tigersFury.mp3",            durationSound = 0.86, type = "buff"    },
			[22842] = { soundName = "frenziedRegeneration.mp3",  durationSound = 1.38, type = "buff"    },
			[16689] = { soundName = "naturesGrasp.mp3",          durationSound = 1.09, type = "buff"    },
			[17116] = { soundName = "naturesSwiftness.mp3",      durationSound = 1.25, type = "buff"    },
			[50334] = { soundName = "berserk.mp3",               durationSound = 0.67, type = "buff"    },
			[48518] = { soundName = "lunarEclipse.mp3",          durationSound = 1.03, type = "buff"    },
			[48517] = { soundName = "solarEclipse.mp3",          durationSound = 1.09, type = "buff"    },
			[16870] = { soundName = "clearcasting.mp3",          durationSound = 0.92, type = "buff"    },
			[52610] = { soundName = "savageRoar.mp3",            durationSound = 0.94, type = "buff"    },
			[69369] = { soundName = "predatorsSwiftness.mp3",    durationSound = 1.25, type = "buff"    },
			[48505] = { soundName = "starfall.mp3",              durationSound = 0.71, type = "buff"    },
			[1850]  = { soundName = "dash.mp3",                  durationSound = 0.64, type = "buff"    },
			[5211]  = { soundName = "bash.mp3",                  durationSound = 0.52, type = "debuff"  },
			[22570] = { soundName = "maim.mp3",                  durationSound = 0.48, type = "debuff"  },
			[9005]  = { soundName = "pounce.mp3",                durationSound = 0.59, type = "debuff"  },
			[2637]  = { soundName = "hibernate.mp3",             durationSound = 0.68, type = "cast"    },
			[33786] = { soundName = "cyclone.mp3",               durationSound = 0.82, type = "cast"    },
			[740]   = { soundName = "tranquility.mp3",           durationSound = 0.86, type = "ability" },
			[33831] = { soundName = "forceOfNature.mp3",         durationSound = 1.14, type = "ability" },
			[5215]  = { soundName = "prowl.mp3",                 durationSound = 0.56, type = "ability" },
			[93985] = { soundName = "skullBash.mp3",             durationSound = 0.84, type = "kick"    },
			[97547] = { soundName = "SolarBeam.mp3",             durationSound = 0.86, type = "kick"    }
		},

		HUNTER = {
			[3045]  = { soundName = "rapidFire.mp3",             durationSound = 0.85, type = "buff"    },
			[19263] = { soundName = "deterrence.mp3",            durationSound = 0.82, type = "buff"    },
			[19574] = { soundName = "bestialWrath.mp3",          durationSound = 0.88, type = "buff"    },
			[53480] = { soundName = "roarofsacrifice.mp3",       durationSound = 1.16, type = "buff"    },
			[34471] = { soundName = "theBeastWithin.mp3",        durationSound = 0.87, type = "buff"    },
			[54216] = { soundName = "mastersCall.mp3",           durationSound = 0.99, type = "buff"    },
			[34490] = { soundName = "silencingshot.mp3",         durationSound = 1.1,  type = "debuff"  },
			[19386] = { soundName = "wyvernSting.mp3",           durationSound = 0.9,  type = "debuff"  },
			[19503] = { soundName = "scatterShot.mp3",           durationSound = 0.91, type = "debuff"  },
			[90337] = { soundName = "petStun.mp3",               durationSound = 0.74, type = "debuff"  },
			[19577] = { soundName = "petStun.mp3",               durationSound = 0.74, type = "debuff"  },
			[3355]  = { soundName = "FreezingTrap.mp3",          durationSound = 0.95, type = "debuff"  },
			[1513]  = { soundName = "scareBeast.mp3",            durationSound = 0.78, type = "cast"    },
			[982]   = { soundName = "revivePet.mp3",             durationSound = 0.82, type = "cast"    },
			[1499]  = { soundName = "FreezingTrap.mp3",          durationSound = 0.95, type = "ability" },
			[60192] = { soundName = "FreezingTrap.mp3",          durationSound = 0.95, type = "ability" },
			[23989] = { soundName = "readiness.mp3",             durationSound = 0.68, type = "ability" }
			
		},

		MAGE = {
			[12043] = { soundName = "presenceOfMind.mp3",        durationSound = 1.05, type = "buff"    },
			[12042] = { soundName = "arcanePower.mp3",           durationSound = 0.9,  type = "buff"    },
			[12472] = { soundName = "icyVeins.mp3",              durationSound = 0.97, type = "buff"    },
			[31643] = { soundName = "blazingSpeed.mp3",          durationSound = 0.99, type = "buff"    },
			[64343] = { soundName = "impact.mp3",                durationSound = 1.02, type = "buff"    },
			[48108] = { soundName = "hotStreak.mp3",             durationSound = 0.73, type = "buff"    },
			[57761] = { soundName = "brainFreeze.mp3",           durationSound = 0.93, type = "buff"    },
			[45438] = { soundName = "iceBlock.mp3",              durationSound = 0.68, type = "buff"    },
			[12051] = { soundName = "evocation.mp3",             durationSound = 0.87, type = "buff"    },
			[44572] = { soundName = "deepFreeze.mp3",            durationSound = 0.8,  type = "debuff"  },
			[118]   = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    }, -- Blizzard's Copy past start
			[28271] = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    },
			[28272] = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    },
			[61780] = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    },
			[61721] = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    },
			[61305] = { soundName = "polymorph.mp3",             durationSound = 0.73, type = "cast"    }, -- Blizzard's Copy past end
			[11129] = { soundName = "combustion.mp3",            durationSound = 0.85, type = "ability" },
			[2139]  = { soundName = "counterspell.mp3",          durationSound = 0.85, type = "ability" },
			[11958] = { soundName = "coldSnap.mp3",              durationSound = 0.74, type = "ability" },
			[55342] = { soundName = "mirrorImage.mp3",           durationSound = 0.86, type = "ability" },
			[31661] = { soundName = "dragonsBreath.mp3",         durationSound = 1.04, type = "ability" },
			[66]    = { soundName = "invisibility.mp3",          durationSound = 0.97, type = "ability" },
			[82676] = { soundName = "RingofFrost.mp3",           durationSound = 0.96, type = "ability" }
		},

		DEATHKNIGHT = {
			[45529] = { soundName = "bloodTap.mp3",              durationSound = 0.73, type = "buff"    },
			[49016] = { soundName = "unholyfrenzy.mp3",          durationSound = 1.09, type = "buff"    },
			[55233] = { soundName = "vampiricBlood.mp3",         durationSound = 1.06, type = "buff"    },
			[48792] = { soundName = "iceboundFortitude.mp3",     durationSound = 0.83, type = "buff"    },
			[49039] = { soundName = "lichborne.mp3",             durationSound = 0.78, type = "buff"    },
			[51271] = { soundName = "pillarofFrost.mp3",         durationSound = 1.06, type = "buff"    },
			[48707] = { soundName = "antiMagicShell.mp3",        durationSound = 1.27, type = "buff"    },
			[49222] = { soundName = "boneShield.mp3",            durationSound = 0.84, type = "buff"    },
			[48266] = { soundName = "frostPresence.mp3",         durationSound = 1.07, type = "buff"    },
			[48263] = { soundName = "bloodPresence.mp3",         durationSound = 0.87, type = "buff"    },
			[48265] = { soundName = "unholyPresence.mp3",        durationSound = 1.14, type = "buff"    },
			[47476] = { soundName = "strangulate.mp3",           durationSound = 0.84, type = "debuff"  },
			[91800] = { soundName = "petStun.mp3",               durationSound = 0.74, type = "debuff"  },
			[49203] = { soundName = "hungeringCold.mp3",         durationSound = 1.0,  type = "cast"    },
			[49028] = { soundName = "dancingRuneWeapon.mp3",     durationSound = 1.14, type = "ability" },
			[48982] = { soundName = "runeTap.mp3",               durationSound = 0.7 , type = "ability" },
			[47568] = { soundName = "empowerRuneWeapon.mp3",     durationSound = 1.14, type = "ability" },
			[49206] = { soundName = "summonGargoyle.mp3",        durationSound = 0.68, type = "ability" },
			[51052] = { soundName = "antiMagicZone.mp3",         durationSound = 1.24, type = "ability" },
			[47528] = { soundName = "mindFreeze.mp3",            durationSound = 0.88, type = "kick"    }
		},

		PALADIN = {
			[1044]  = { soundName = "handOfFreedom.mp3",         durationSound = 0.74, type = "buff"    },
			[498]   = { soundName = "divineProtection.mp3",      durationSound = 1.15, type = "buff"    },
			[31821] = { soundName = "auraMastery.mp3",           durationSound = 0.84, type = "buff"    },
			[1022]  = { soundName = "handOfProtection.mp3",      durationSound = 1.16, type = "buff"    },
			[642]   = { soundName = "divineShield.mp3",          durationSound = 0.88, type = "buff"    },
			[31884] = { soundName = "avengingWrath.mp3",         durationSound = 0.92, type = "buff"    },
			[6940]  = { soundName = "handofsacrifice.mp3",       durationSound = 1.06, type = "buff"    },
			[31842] = { soundName = "divineFavor.mp3",           durationSound = 0.94, type = "buff"    },
			[54428] = { soundName = "divinePlea.mp3",            durationSound = 0.83, type = "buff"    },
			[853]   = { soundName = "hammerOfJustice.mp3",       durationSound = 1.04, type = "debuff"  },
			[20066] = { soundName = "repentance.mp3",            durationSound = 0.75, type = "debuff"  },
			[10326] = { soundName = "turnEvil.mp3",              durationSound = 0.59, type = "cast"    },
			[96231] = { soundName = "Rebuke.mp3",                durationSound = 0.60, type = "kick"    }
		},

		PRIEST = {
			[33206] = { soundName = "painSuppression.mp3",       durationSound = 0.97, type = "buff"    },
			[10060] = { soundName = "powerInfusion.mp3",         durationSound = 1.04, type = "buff"    },
			[6346]  = { soundName = "fearWard.mp3",              durationSound = 0.63, type = "buff"    },
			[47788] = { soundName = "GuardianSpirit.mp3",        durationSound = 0.94, type = "buff"    },
			[47585] = { soundName = "dispersion.mp3",            durationSound = 0.73, type = "buff"    },
			[586]   = { soundName = "fade.mp3",                  durationSound = 0.61, type = "buff"    },
			[96267] = { soundName = "innerFocus.mp3",            durationSound = 1.01, type = "buff"    }, -- rank 2
			[96266] = { soundName = "innerFocus.mp3",            durationSound = 1.01, type = "buff"    }, -- rank 1
			[96219] = { soundName = "handOfFreedom.mp3",         durationSound = 0.74, type = "buff"    },
			[87153] = { soundName = "darkArchangel.mp3",         durationSound = 0.73, type = "buff"    },
			[87152] = { soundName = "archangel.mp3",             durationSound = 0.77, type = "buff"    },
			[15487] = { soundName = "silence.mp3",               durationSound = 0.78, type = "debuff"  },
			[64044] = { soundName = "psychicHorror.mp3",         durationSound = 0.94, type = "debuff"  },
			[605]   = { soundName = "mindControl.mp3",           durationSound = 0.86, type = "cast"    },
			[8129]  = { soundName = "manaBurn.mp3",              durationSound = 0.76, type = "cast"    },
			[32375] = { soundName = "massDispel.mp3",            durationSound = 0.89, type = "cast"    },
			[64843] = { soundName = "divineHymn.mp3",            durationSound = 1.31, type = "ability" },
			[9484]  = { soundName = "shackleUndead.mp3",         durationSound = 0.58, type = "ability" },
			[8122]  = { soundName = "fear.mp3",                  durationSound = 0.66, type = "ability" },
			[34433] = { soundName = "shadowFiend.mp3",           durationSound = 0.97, type = "ability" },
			[32379] = { soundName = "shadowWordDeath.mp3",       durationSound = 0.52, type = "ability" }
		},

		ROGUE = {
			[5277]  = { soundName = "evasion.mp3",               durationSound = 0.6,  type = "buff"    },
			[31224] = { soundName = "cloakOfShadows.mp3",        durationSound = 1.04, type = "buff"    },
			[13750] = { soundName = "adrenalineRush.mp3",        durationSound = 0.46, type = "buff"    },
			[51690] = { soundName = "killingSpree.mp3",          durationSound = 0.9,  type = "buff"    },
			[51713] = { soundName = "shadowDance.mp3",           durationSound = 0.99, type = "buff"    },
			[57934] = { soundName = "trickOfTheTrade.mp3",       durationSound = 0.3,  type = "buff"    },
			[45182] = { soundName = "cheatingDeath.mp3",         durationSound = 0.83, type = "buff"    },
			[2983]  = { soundName = "sprint.mp3",                durationSound = 0.46, type = "buff"    },
			[13877] = { soundName = "bladeflurry.mp3",           durationSound = 0.73, type = "buff"    },
			[2094]  = { soundName = "blind.mp3",                 durationSound = 0.63, type = "debuff"  },
			[408]   = { soundName = "kidney.mp3",                durationSound = 0.48, type = "debuff"  },
			[1776]  = { soundName = "gouge.mp3",                 durationSound = 0.44, type = "debuff"  },
			[51722] = { soundName = "disarm2.mp3",               durationSound = 0.78, type = "debuff"  },
			[1833]  = { soundName = "cheapShot.mp3",             durationSound = 0.61, type = "debuff"  },
			[6770]  = { soundName = "sap.mp3",                   durationSound = 0.59, type = "debuff"  },
			[703]   = { soundName = "garrote.mp3",               durationSound = 0.48, type = "debuff"  },
			[14177] = { soundName = "coldBlood.mp3",             durationSound = 0.67, type = "ability" },
			[1784]  = { soundName = "stealth.mp3",               durationSound = 0.52, type = "ability" },
			[14185] = { soundName = "preparation.mp3",           durationSound = 0.96, type = "ability" },
			[36554] = { soundName = "shadowstep.mp3",            durationSound = 0.83, type = "ability" },
			[1856]  = { soundName = "vanish.mp3",                durationSound = 0.69, type = "ability" },
			[76577] = { soundName = "SmokeBomb.mp3",             durationSound = 0.85, type = "ability" },
			[1766]  = { soundName = "kick.mp3",                  durationSound = 0.47, type = "kick"    }
		},

		SHAMAN = {
			[16166] = { soundName = "elementalMastery.mp3",      durationSound = 1.12, type = "buff"    },
			[30823] = { soundName = "shamanisticRage.mp3",       durationSound = 1.21, type = "buff"    },
			[16188] = { soundName = "naturesSwiftness.mp3",      durationSound = 1.25, type = "buff"    },
			[974]   = { soundName = "earthShield.mp3",           durationSound = 0.86, type = "buff"    },
			[52127] = { soundName = "waterShield.mp3",           durationSound = 0.73, type = "buff"    },
			[51514] = { soundName = "hex.mp3",                   durationSound = 0.48, type = "cast"    },
			[8143]  = { soundName = "tremorTotem.mp3",           durationSound = 0.48, type = "ability" },
			[8177]  = { soundName = "groundingTotem.mp3",        durationSound = 0.56, type = "ability" },
			[16190] = { soundName = "manaTideTotem.mp3",         durationSound = 0.75, type = "ability" },
			[98008] = { soundName = "spiritLink.mp3",            durationSound = 0.86, type = "ability" },
			[51533] = { soundName = "feralSpirit.mp3",           durationSound = 0.89, type = "ability" },
			[57994] = { soundName = "windShear.mp3",             durationSound = 0.70, type = "kick"    }
		},

		WARLOCK = {
			[47241] = { soundName = "metamorphosis.mp3",         durationSound = 1.09, type = "buff"    },
			[79460] = { soundName = "demonsoul.mp3",             durationSound = 0.83, type = "buff"    },
			[79462] = { soundName = "demonsoul.mp3",             durationSound = 0.83, type = "buff"    },
			[6789]  = { soundName = "deathcoil.mp3",             durationSound = 0.72, type = "debuff"  },
			[24259] = { soundName = "spellLock.mp3",             durationSound = 0.69, type = "debuff"  },
			[5782]  = { soundName = "fear.mp3",                  durationSound = 0.66, type = "cast"    },
			[50796] = { soundName = "chaosBolt.mp3",             durationSound = 0.92, type = "cast"    },
			[6358]  = { soundName = "seduction.mp3",             durationSound = 0.78, type = "cast"    },
			[688]   = { soundName = "summonImp.mp3",             durationSound = 0.7,  type = "cast"    },
			[697]   = { soundName = "summonVoidwalker.mp3",      durationSound = 0.77, type = "cast"    },
			[712]   = { soundName = "summonSuccube.mp3",         durationSound = 0.53, type = "cast"    },
			[691]   = { soundName = "summonFelhunter.mp3",       durationSound = 0.77, type = "cast"    },
			[30146] = { soundName = "summonFelGuard.mp3",        durationSound = 0.65, type = "cast"    },
			[5484]  = { soundName = "howlOfTerror.mp3",          durationSound = 0.8,  type = "ability" },
			[48020] = { soundName = "demonicCircleTeleport.mp3", durationSound = 0.71, type = "ability" },
			[30283] = { soundName = "shadowfury.mp3",            durationSound = 0.85, type = "ability" }
		},

		WARRIOR = {
			[55694] = { soundName = "enragedRegeneration.mp3",   durationSound = 1.35, type = "buff"    },
			[46924] = { soundName = "bladestorm.mp3",            durationSound = 0.71, type = "buff"    },
			[871]   = { soundName = "shieldWall.mp3",            durationSound = 0.73, type = "buff"    },
			[18499] = { soundName = "berserkerRage.mp3",         durationSound = 1.17, type = "buff"    },
			[1719]  = { soundName = "recklessness.mp3",          durationSound = 0.92, type = "buff"    },
			[23920] = { soundName = "spellReflection.mp3",       durationSound = 1.8,  type = "buff"    },
			[12292] = { soundName = "deathWish.mp3",             durationSound = 0.78, type = "buff"    },
			[12975] = { soundName = "lastStand.mp3",             durationSound = 0.91, type = "buff"    },
			[20230] = { soundName = "Retaliation.mp3",           durationSound = 0.97, type = "buff"    },
			[12328] = { soundName = "sweepingStrikes.mp3",       durationSound = 1.16, type = "buff"    },
			[85730] = { soundName = "deadlyCalm.mp3",            durationSound = 0.93, type = "buff"    },
			[676]   = { soundName = "disarm.mp3",                durationSound = 0.55, type = "debuff"  },
			[12809] = { soundName = "concussionBlow.mp3",        durationSound = 1.04, type = "debuff"  },
			[46968] = { soundName = "shockwave.mp3",             durationSound = 0.8,  type = "debuff"  },
			[85388] = { soundName = "throwdown.mp3",             durationSound = 0.67, type = "debuff"  },
			[64382] = { soundName = "shatteringThrow.mp3",       durationSound = 0.94, type = "cast"    },
			[5246]  = { soundName = "fear.mp3",                  durationSound = 0.66, type = "ability" },
			[2457]  = { soundName = "battleStance.mp3",          durationSound = 1.05, type = "ability" },
			[71]    = { soundName = "defensiveStance.mp3",       durationSound = 1.31, type = "ability" },
			[2458]  = { soundName = "berserkerStance.mp3",       durationSound = 1.23, type = "ability" },
			[97462] = { soundName = "RallyingCry.mp3",           durationSound = 0.9,  type = "ability" },
			[6552]  = { soundName = "pummel.mp3",                durationSound = 0.35, type = "kick"    }
		}
	}
end

-- you can change this type of sound if you want
function GladiatorlosSA:GetClassTrinketSound(engClass)
	return engClass .. ".mp3"
end

function GladiatorlosSA:GetFriendReflectedSound()
	return "reflected.mp3"
end

function GladiatorlosSA:GetEnemyReflectedSound()
	return "enemyReflected.mp3"
end

function GladiatorlosSA:GetEnemyInterruptedSuccessSound()
	return "interrupted.mp3"
end

function GladiatorlosSA:GetFriendInterruptedSuccessSound()
	return "Lockout.mp3"
end

function GladiatorlosSA:GetAuraDownSound()
	return "Down.mp3"
end

function GladiatorlosSA:GetCastSuccessSound()
	return "success.mp3"
end

function GladiatorlosSA:GetDrinkingSound()
	return "drinking.mp3"
end

function GladiatorlosSA:FindSpellByID(spellID)
	for kind,_ in pairs(self.spellList) do
		if self.spellList[kind][spellID] ~= nil then
			return self.spellList[kind][spellID]
		end
	end
	return nil
end

local pvpTrinkets = {
	[42292] = true, -- PvP Trinket
	[59752] = true  -- Will To Survive
}

function GladiatorlosSA:IsPvPTrinket(spellID)
	return pvpTrinkets[spellID] ~= nil
end

local epicBG = {
	[2118] = true, -- Wintergrasp
	[30]   = true, -- Alterac Valley
	[628]  = true, -- Isle of Conquest
	[2755] = true  -- Tol Barad
}

function GladiatorlosSA:IsEpicBG(instanceMapID)
	return epicBG[instanceMapID] ~= nil
end

-- It's not using now, but maybe someday
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
