--[[
    Some explanation how it is work
    
    GetSpellList store class and spells in a certain pattern
    CLASS = {
        [ID] = {
            soundName = "sound name from Voice_enUS folder without audio format, (English voice sound is Neospeech Julie)
            type = "buff / debuff / cast / kick"
        },
        ...
    }

    Types:
    1. buff - add in "Aura Applied" and "Aura Down" in "Abilities".
        Create two sound file like (rapidFire.mp3, rapidFireDown.mp3)
    2. debuff - add in "Aura Applied" in "Abilities"
    3. ability - add in "Spell Cast" in "Abilities"
    4. cast - add in "Spell Cast" and "Cast Success" in "Abilities"
    5. kick - you cant see that spell in "Abilities", but it is sound in battle when toggle "Enable interrupt" is active in "Abilities"

    How to chose which type for spell:
    0. Open wowhead and define type of spell (buff, debuff or cast). (You can download addon idTip for easy finding spell id in game)
    1. buff - enemy spell, which add buff on him or his partners (like warrior's recklessness or shaman's earth Shield)
        (but if this spell buff full party, then be better to chose "ability" type, because I guess addon start spamming spell sound)
    2. debuff - enemy spell, which add debuff on you or your partners (like some stun or disarm)
        (but if this spell debuff multiple targets, then be better to chose "ability" type, because I guess addon start spamming spell sound)
    3. cast - enemy spell, that have time cast and after you need hear "cast" sound "success"
    4. kick - enemy spell, that interrupt cast.
    5. ability - if none of the above list is fit, then chose this type
]]

function GladiatorlosSA:GetSpellList()
    return {
        GENERAL = {
            [34709] = { soundName = "shadowSight",           type = "buff"    },
            [44055] = { soundName = "battlemaster",          type = "buff"    }
        },

        RACIAL = {
            [26297]  = { soundName = "berserking",            type = "buff"    },
            [65116]  = { soundName = "stoneform",             type = "buff"    },
            [20572]  = { soundName = "bloodFury",             type = "buff"    }, -- Blizzard's Copy past start
            [33697]  = { soundName = "bloodFury",             type = "buff"    },
            [33702]  = { soundName = "bloodFury",             type = "buff"    }, -- Blizzard's Copy past end
            [28880]  = { soundName = "giftOfTheNaaru",        type = "buff"    },
            [58984]  = { soundName = "shadowmeld",            type = "ability" },
            [28730]  = { soundName = "arcaneTorrent",         type = "ability" }, -- Blizzard's Copy past start
            [80483]  = { soundName = "arcaneTorrent",         type = "ability" },
            [25046]  = { soundName = "arcaneTorrent",         type = "ability" },
            [50613]  = { soundName = "arcaneTorrent",         type = "ability" },
            [69179]  = { soundName = "arcaneTorrent",         type = "ability" }, -- Blizzard's Copy past end
            [7744]   = { soundName = "willOfTheForsaken",     type = "ability" },
            [107079] = { soundName = "quakingPalm",           type = "ability" }
        },    
        
        DRUID = {
            [5229]   = { soundName = "enrage",                type = "buff"    },
            [61336]  = { soundName = "survivalInstincts",     type = "buff"    },
            [29166]  = { soundName = "innervate",             type = "buff"    },
            [22812]  = { soundName = "barkskin",              type = "buff"    },
            [5217]   = { soundName = "tigersFury",            type = "buff"    },
            [22842]  = { soundName = "frenziedRegeneration",  type = "buff"    },
            [16689]  = { soundName = "naturesGrasp",          type = "buff"    },
            [132158] = { soundName = "naturesSwiftness",      type = "buff"    },
            [50334]  = { soundName = "berserk",               type = "buff"    },
            [48518]  = { soundName = "lunarEclipse",          type = "buff"    },
            [48517]  = { soundName = "solarEclipse",          type = "buff"    },
            [16870]  = { soundName = "clearcasting",          type = "buff"    },
            [52610]  = { soundName = "savageRoar",            type = "buff"    },
            [69369]  = { soundName = "predatorsSwiftness",    type = "buff"    },
            [48505]  = { soundName = "starfall",              type = "buff"    },
            [1850]   = { soundName = "dash",                  type = "buff"    },
            [110570] = { soundName = "sAntiMagicShell",       type = "buff"    }, -- Symbiosis
            [110575] = { soundName = "sIceboundFortitude",    type = "buff"    }, -- Symbiosis
            [110617] = { soundName = "sDeterrence",           type = "buff"    }, -- Symbiosis
            [110696] = { soundName = "sIceBlock",             type = "buff"    }, -- Symbiosis
            [126456] = { soundName = "sFortifyingBrew",       type = "buff"    }, -- Symbiosis
            [110700] = { soundName = "sDivineShield",         type = "buff"    }, -- Symbiosis
            [110717] = { soundName = "sFearWard",             type = "buff"    }, -- Symbiosis
            [110715] = { soundName = "sDispersion",           type = "buff"    }, -- Symbiosis
            [110788] = { soundName = "sCloakOfShadows",       type = "buff"    }, -- Symbiosis
            [110791] = { soundName = "sEvasion",              type = "buff"    }, -- Symbiosis
            [110806] = { soundName = "sSpiritwalkersGrace",   type = "buff"    }, -- Symbiosis
            [122291] = { soundName = "sUnendingResolve",      type = "buff"    }, -- Symbiosis
            [113002] = { soundName = "sSpellReflection",      type = "buff"    }, -- Symbiosis
            --[110597] = { soundName = "sPlayDead",             type = "buff"    }, -- Symbiosis -- NoSound
            [102342] = { soundName = "IronBark",              type = "buff"    },
            [112071] = { soundName = "celestialAlignment",    type = "buff"    },
            [102560] = { soundName = "incarnation",           type = "buff"    }, -- Blizzard's Copy past start
            [33891]  = { soundName = "incarnation",           type = "buff"    },
            [102543] = { soundName = "incarnation",           type = "buff"    },
            [102558] = { soundName = "incarnation",           type = "buff"    }, -- Blizzard's Copy past end
            [102351] = { soundName = "cenarionWard",          type = "buff"    },
            [108288] = { soundName = "heartOfTheWild",        type = "buff"    },
            [124974] = { soundName = "natureVigil",           type = "buff"    },
            [122292] = { soundName = "sIntervene",            type = "buff"    }, -- Symbiosis
            [106922] = { soundName = "ursoc",                 type = "buff"    },
            [5211]   = { soundName = "bash",                  type = "debuff"  },
            [22570]  = { soundName = "maim",                  type = "debuff"  },
            [9005]   = { soundName = "pounce",                type = "debuff"  },
            [2637]   = { soundName = "hibernate",             type = "cast"    },
            [33786]  = { soundName = "cyclone",               type = "cast"    },
            [110707] = { soundName = "sMassDispel",           type = "cast"    }, -- Symbiosis
            [112997] = { soundName = "sShatteringBlow",       type = "cast"    }, -- Symbiosis
            [740]    = { soundName = "tranquility",           type = "ability" },
            [33831]  = { soundName = "forceOfNature",         type = "ability" },
            [5215]   = { soundName = "prowl",                 type = "ability" },
            [106898] = { soundName = "stampedingRoar",        type = "ability" },
            [110621] = { soundName = "sMirrorImage",          type = "ability" }, -- Symbiosis
            [126458] = { soundName = "sGrappleWeapon",        type = "ability" }, -- Symbiosis
            [126449] = { soundName = "sClash",                type = "ability" }, -- Symbiosis
            [110698] = { soundName = "sHammerOfJustice",      type = "ability" }, -- Symbiosis
            [110730] = { soundName = "sRedirect",             type = "ability" }, -- Symbiosis
            [110807] = { soundName = "sFeralSpirit",          type = "ability" }, -- Symbiosis
            [110810] = { soundName = "sSoulSwap",             type = "ability" }, -- Symbiosis
            [112970] = { soundName = "sTeleport",             type = "ability" }, -- Symbiosis
            [113004] = { soundName = "sIntimidatingRoar",     type = "ability" }, -- Symbiosis
            [102795] = { soundName = "bearHug",               type = "ability" },
            [102280] = { soundName = "displacerBeast",        type = "ability" },
            [99]     = { soundName = "disorientingRoar",      type = "ability" },
            [102359] = { soundName = "massEntanglement",      type = "ability" },
            [108238] = { soundName = "renewal",               type = "ability" },
            [102793] = { soundName = "ursolVortex",           type = "ability" },
            [93985]  = { soundName = "skullBash",             type = "kick"    },
            [97547]  = { soundName = "SolarBeam",             type = "kick"    }
        },

        HUNTER = {
            [3045]   = { soundName = "rapidFire",             type = "buff"    },
            [19263]  = { soundName = "deterrence",            type = "buff"    },
            [19574]  = { soundName = "bestialWrath",          type = "buff"    },
            [53480]  = { soundName = "roarofsacrifice",       type = "buff"    },
            [54216]  = { soundName = "mastersCall",           type = "buff"    },
            [82726]  = { soundName = "fervor",                type = "buff"    },
            [113073] = { soundName = "sDash",                 type = "buff"    }, -- Symbiosis
            [34490]  = { soundName = "silencingshot",         type = "debuff"  },
            [19386]  = { soundName = "wyvernSting",           type = "debuff"  },
            [19503]  = { soundName = "scatterShot",           type = "debuff"  },
            [19577]  = { soundName = "petStun",               type = "debuff"  },
            [3355]   = { soundName = "FreezingTrap",          type = "debuff"  },
            [131894] = { soundName = "aMurderOfCrows",        type = "debuff"  },
            [1513]   = { soundName = "scareBeast",            type = "cast"    },
            [982]    = { soundName = "revivePet",             type = "cast"    },
            [109259] = { soundName = "powershot",             type = "cast"    },
            [1499]   = { soundName = "FreezingTrap",          type = "ability" },
            [60192]  = { soundName = "FreezingTrap",          type = "ability" },
            [34600]  = { soundName = "SnakeTrap",             type = "ability" },
            [82948]  = { soundName = "SnakeTrap",             type = "ability" },
            [121818] = { soundName = "stampede",              type = "ability" },
            [109248] = { soundName = "bindingShot",           type = "ability" },
            [109304] = { soundName = "exhilaration",          type = "ability" },
            [120679] = { soundName = "direBeast",             type = "ability" },
            [147362] = { soundName = "counterShot",           type = "kick"    } 
        },

        MAGE = {
            [12043]  = { soundName = "presenceOfMind",        type = "buff"    },
            [12042]  = { soundName = "arcanePower",           type = "buff"    },
            [12472]  = { soundName = "icyVeins",              type = "buff"    },
            [48108]  = { soundName = "hotStreak",             type = "buff"    },
            [57761]  = { soundName = "brainFreeze",           type = "buff"    },
            [45438]  = { soundName = "iceBlock",              type = "buff"    },
            [12051]  = { soundName = "evocation",             type = "buff"    },
            [110909] = { soundName = "alterTime",             type = "buff"    },
            [108839] = { soundName = "iceFloes",              type = "buff"    },
            [115610] = { soundName = "temporalShield",        type = "buff"    },
            [108843] = { soundName = "blazingSpeed",          type = "buff"    },
            [87024]  = { soundName = "cauterize",             type = "buff"    },
            [44572]  = { soundName = "deepFreeze",            type = "debuff"  },
            [83853]  = { soundName = "combustion",            type = "debuff"  },
            [118]    = { soundName = "polymorph",             type = "cast"    }, -- Blizzard's Copy past start
            [28271]  = { soundName = "polymorph",             type = "cast"    },
            [28272]  = { soundName = "polymorph",             type = "cast"    },
            [61780]  = { soundName = "polymorph",             type = "cast"    },
            [61721]  = { soundName = "polymorph",             type = "cast"    },
            [61305]  = { soundName = "polymorph",             type = "cast"    }, -- Blizzard's Copy past end
            [31687]  = { soundName = "waterElemental",        type = "cast"    },
            [102051] = { soundName = "frostjaw",              type = "cast"    },
            [113724] = { soundName = "RingofFrost",           type = "cast"    },
            [116011] = { soundName = "runeOfPower",           type = "cast"    },
            [11958]  = { soundName = "coldSnap",              type = "ability" },
            [55342]  = { soundName = "mirrorImage",           type = "ability" },
            [31661]  = { soundName = "dragonsBreath",         type = "ability" },
            [66]     = { soundName = "invisibility",          type = "ability" },
            [110959] = { soundName = "greaterInvisibility",   type = "ability" },
            [84714]  = { soundName = "frozenOrb",             type = "ability" },
            [2139]   = { soundName = "counterspell",          type = "kick"    }
        },

        MONK = {
            [122278] = { soundName = "dampenHarm",            type = "buff"    },
            [122464] = { soundName = "dematerialize",         type = "buff"    },
            [122783] = { soundName = "diffuseMagic",          type = "buff"    },
            [116849] = { soundName = "lifeCocoon",            type = "buff"    },
            [137562] = { soundName = "nimbleBrew",            type = "buff"    },
            [116844] = { soundName = "ringOfPeace",           type = "buff"    },
            [116841] = { soundName = "tigerLust",             type = "buff"    },
            [116740] = { soundName = "tigereyeBrew",          type = "buff"    },
            [115176] = { soundName = "zenMeditation",         type = "buff"    },
            [113306] = { soundName = "sSurvivalInstincts",    type = "buff"    }, -- Symbiosis
            [124488] = { soundName = "zenFocus",              type = "buff"    },
            [119996] = { soundName = "Transfer",              type = "cast"    },
            [119392] = { soundName = "chargingOxWave",        type = "ability" },
            [122470] = { soundName = "touchOfKarma",          type = "ability" },
            [115399] = { soundName = "chiBrew",               type = "ability" },
            [122057] = { soundName = "clash",                 type = "ability" },
            [113656] = { soundName = "fistsOfFury",           type = "ability" },
            [117368] = { soundName = "grappleWeapon",         type = "ability" },
            [123904] = { soundName = "invokeXuen",            type = "ability" },
            [119381] = { soundName = "legSweep",              type = "ability" },
            [115294] = { soundName = "manaTea",               type = "ability" },
            [115078] = { soundName = "paralysis",             type = "ability" },
            [115310] = { soundName = "revival",               type = "ability" },
            [137639] = { soundName = "StormEarthFire",        type = "ability" },
            [127361] = { soundName = "sBearHug",              type = "ability" }, -- Symbiosis
            [116705] = { soundName = "spearHandStrike",       type = "kick"    } 
        },

        DEATHKNIGHT = {
            [45529]  = { soundName = "bloodTap",              type = "buff"    },
            [49016]  = { soundName = "unholyfrenzy",          type = "buff"    },
            [55233]  = { soundName = "vampiricBlood",         type = "buff"    },
            [48792]  = { soundName = "iceboundFortitude",     type = "buff"    },
            [49039]  = { soundName = "lichborne",             type = "buff"    },
            [51271]  = { soundName = "pillarofFrost",         type = "buff"    },
            [48707]  = { soundName = "antiMagicShell",        type = "buff"    },
            [49222]  = { soundName = "boneShield",            type = "buff"    },
            [48266]  = { soundName = "frostPresence",         type = "buff"    },
            [48263]  = { soundName = "bloodPresence",         type = "buff"    },
            [48265]  = { soundName = "unholyPresence",        type = "buff"    },
            [96268]  = { soundName = "deathAdvance",          type = "buff"    },
            [108200] = { soundName = "remorselessWinter",     type = "buff"    },
            [113072] = { soundName = "sUrsoc",                type = "buff"    }, -- Symbiosis
            [116888] = { soundName = "purgatory",             type = "buff"    },
            [47476]  = { soundName = "strangulate",           type = "debuff"  },
            [91800]  = { soundName = "petStun",               type = "debuff"  },
            [130736] = { soundName = "soulReaper",            type = "debuff"  }, -- Blizzard's Copy past start
            [130735] = { soundName = "soulReaper",            type = "debuff"  },
            [114866] = { soundName = "soulReaper",            type = "debuff"  }, -- Blizzard's Copy past end
            [77606]  = { soundName = "darkSimulacrum",        type = "debuff"  },
            [49028]  = { soundName = "dancingRuneWeapon",     type = "ability" },
            [48982]  = { soundName = "runeTap",               type = "ability" },
            [47568]  = { soundName = "empowerRuneWeapon",     type = "ability" },
            [49206]  = { soundName = "summonGargoyle",        type = "ability" },
            [51052]  = { soundName = "antiMagicZone",         type = "ability" },
            [108194] = { soundName = "asphyxiate",            type = "ability" },
            [48743]  = { soundName = "deathPact",             type = "ability" },
            [108201] = { soundName = "desecratedGround",      type = "ability" },
            [108199] = { soundName = "gorefiendGrasp",        type = "ability" },
            [47528]  = { soundName = "mindFreeze",            type = "kick"    }
        },

        PALADIN = {
            [1044]   = { soundName = "handOfFreedom",         type = "buff"    },
            [498]    = { soundName = "divineProtection",      type = "buff"    },
            [31821]  = { soundName = "auraMastery",           type = "buff"    },
            [1022]   = { soundName = "handOfProtection",      type = "buff"    },
            [642]    = { soundName = "divineShield",          type = "buff"    },
            [31884]  = { soundName = "avengingWrath",         type = "buff"    },
            [6940]   = { soundName = "handofsacrifice",       type = "buff"    },
            [31842]  = { soundName = "divineFavor",           type = "buff"    },
            [54428]  = { soundName = "divinePlea",            type = "buff"    },
            [86698]  = { soundName = "Guardian",              type = "buff"    },
            [84963]  = { soundName = "Inquisition",           type = "buff"    },
            [85499]  = { soundName = "speedOfLight",          type = "buff"    },
            [87173]  = { soundName = "longArmOfTheLaw",       type = "buff"    },
            [114039] = { soundName = "handOfPurity",          type = "buff"    },
            [105809] = { soundName = "holyAvenger",           type = "buff"    },
            [114917] = { soundName = "ExecutionSentence",     type = "buff"    },
            [113075] = { soundName = "sBarkskin",             type = "buff"    }, -- Symbiosis
            [853]    = { soundName = "hammerOfJustice",       type = "debuff"  },
            [105593] = { soundName = "fistOfJustice",         type = "debuff"  },
            [114916] = { soundName = "ExecutionSentence",     type = "debuff"  },
            [20066]  = { soundName = "repentance",            type = "cast"    },
            [10326]  = { soundName = "turnEvil",              type = "cast"    },
            [145067] = { soundName = "turnEvil",              type = "cast"    },
            [115750] = { soundName = "blindingLight",         type = "cast"    },
            [114158] = { soundName = "lightsHammer",          type = "ability" },
            [96231]  = { soundName = "Rebuke",                type = "kick"    }
        },

        PRIEST = {
            [33206]  = { soundName = "painSuppression",       type = "buff"    },
            [10060]  = { soundName = "powerInfusion",         type = "buff"    },
            [6346]   = { soundName = "fearWard",              type = "buff"    },
            [47788]  = { soundName = "GuardianSpirit",        type = "buff"    },
            [47585]  = { soundName = "dispersion",            type = "buff"    },
            [586]    = { soundName = "fade",                  type = "buff"    },
            [96267]  = { soundName = "innerFocus",            type = "buff"    },
            [81700]  = { soundName = "archangel",             type = "buff"    },
            [114239] = { soundName = "phantasm",              type = "buff"    },
            [109964] = { soundName = "spiritShell",           type = "buff"    },
            [15487]  = { soundName = "silence",               type = "debuff"  },
            [64044]  = { soundName = "psychicHorror",         type = "debuff"  },
            [605]    = { soundName = "mindControl",           type = "cast"    },
            [32375]  = { soundName = "massDispel",            type = "cast"    },
            [9484]   = { soundName = "shackleUndead",         type = "cast"    },
            [126135] = { soundName = "lightwell",             type = "cast"    },
            [113506] = { soundName = "sCyclone",              type = "cast"    }, -- Symbiosis
            [64843]  = { soundName = "divineHymn",            type = "ability" },
            [9484]   = { soundName = "shackleUndead",         type = "ability" },
            [8122]   = { soundName = "fearPriest",            type = "ability" },
            [34433]  = { soundName = "shadowFiend",           type = "ability" },
            [123040] = { soundName = "mindbender",            type = "ability" },
            [32379]  = { soundName = "shadowWordDeath",       type = "ability" },
            [108920] = { soundName = "voidTendrils",          type = "ability" },
            [19236]  = { soundName = "desperatePrayer",       type = "ability" },
            [112833] = { soundName = "spectralGuise",         type = "ability" },
            [62618]  = { soundName = "barrier",               type = "ability" },
            [108968] = { soundName = "voidShift",             type = "ability" },
            [64901]  = { soundName = "hymnOfHope",            type = "ability" },
            [88625]  = { soundName = "chastise",              type = "ability" },
            [113277] = { soundName = "sTranquility",          type = "ability" }, -- Symbiosis
            [108921] = { soundName = "psyfiend",              type = "ability" } 
        },

        ROGUE = {
            [5277]   = { soundName = "evasion",               type = "buff"    },
            [31224]  = { soundName = "cloakOfShadows",        type = "buff"    },
            [13750]  = { soundName = "adrenalineRush",        type = "buff"    },
            [51690]  = { soundName = "killingSpree",          type = "buff"    },
            [51713]  = { soundName = "shadowDance",           type = "buff"    },
            [57934]  = { soundName = "trickOfTheTrade",       type = "buff"    },
            [45182]  = { soundName = "cheatingDeath",         type = "buff"    },
            [2983]   = { soundName = "sprint",                type = "buff"    },
            [13877]  = { soundName = "bladeflurry",           type = "buff"    },
            [74001]  = { soundName = "combatReadiness",       type = "buff"    },
            [1966]   = { soundName = "feint",                 type = "buff"    },
            [121471] = { soundName = "shadowBlades",          type = "buff"    },
            [113613] = { soundName = "sGrowl",                type = "buff"    }, -- Symbiosis
            [2094]   = { soundName = "blind",                 type = "debuff"  },
            [408]    = { soundName = "kidney",                type = "debuff"  },
            [1776]   = { soundName = "gouge",                 type = "debuff"  },
            [51722]  = { soundName = "disarm2",               type = "debuff"  },
            [1833]   = { soundName = "cheapShot",             type = "debuff"  },
            [6770]   = { soundName = "sap",                   type = "debuff"  },
            [703]    = { soundName = "garrote",               type = "debuff"  },
            [113953] = { soundName = "poisonStun",            type = "debuff"  },
            [79140]  = { soundName = "vendetta",              type = "debuff"  },
            [1784]   = { soundName = "stealth",               type = "ability" },
            [14185]  = { soundName = "preparation",           type = "ability" },
            [36554]  = { soundName = "shadowstep",            type = "ability" },
            [1856]   = { soundName = "vanish",                type = "ability" },
            [76577]  = { soundName = "SmokeBomb",             type = "ability" },
            [108212] = { soundName = "burstOfSpeed",          type = "ability" },
            [137619] = { soundName = "markedForDeath",        type = "ability" },
            [73981]  = { soundName = "redirect",              type = "ability" },
            [26679]  = { soundName = "deadlyThrow",           type = "kick"    },
            [1766]   = { soundName = "kick",                  type = "kick"    }
        },

        SHAMAN = {
            [16166]  = { soundName = "elementalMastery",      type = "buff"    },
            [30823]  = { soundName = "shamanisticRage",       type = "buff"    },
            [16188]  = { soundName = "naturesSwiftness",      type = "buff"    },
            [974]    = { soundName = "earthShield",           type = "buff"    },
            [52127]  = { soundName = "waterShield",           type = "buff"    },
            [79206]  = { soundName = "SpiritwalkersGrace",    type = "buff"    },
            [114052] = { soundName = "ascendance",            type = "buff"    },
            [114050] = { soundName = "ascendance",            type = "buff"    },
            [114051] = { soundName = "ascendance",            type = "buff"    },
            [108271] = { soundName = "astralShift",           type = "buff"    },
            [108281] = { soundName = "ancestralGuidance",     type = "buff"    },
            [131558] = { soundName = "spiritwalkersAegis",    type = "buff"    },
            [51514]  = { soundName = "hex",                   type = "cast"    },
            [76780]  = { soundName = "bindElemental",         type = "cast"    },
            [117014] = { soundName = "elementalBlast",        type = "cast"    },
            [8143]   = { soundName = "tremorTotem",           type = "ability" },
            [8177]   = { soundName = "groundingTotem",        type = "ability" },
            [16190]  = { soundName = "manaTideTotem",         type = "ability" },
            [98008]  = { soundName = "spiritLink",            type = "ability" },
            [51533]  = { soundName = "feralSpirit",           type = "ability" },
            [108269] = { soundName = "capacitorTotem",        type = "ability" },
            [120668] = { soundName = "stormlashTotem",        type = "ability" },
            [5394]   = { soundName = "healingStreamTotem",    type = "ability" },
            [108280] = { soundName = "healingTideTotem",      type = "ability" },
            [73680]  = { soundName = "unleashElemental",      type = "ability" },
            [16190]  = { soundName = "manaTideTotem",         type = "ability" },
            [108270] = { soundName = "stoneBulwarkTotem",     type = "ability" },
            [108273] = { soundName = "windwalkTotem",         type = "ability" },
            [108285] = { soundName = "callOfTheElements",     type = "ability" },
            [113289] = { soundName = "sProwl",                type = "ability" }, -- Symbiosis
            [57994]  = { soundName = "windShear",             type = "kick"    },
            [113288] = { soundName = "sSolarBeam",            type = "kick"    }  -- Symbiosis
        },

        WARLOCK = {
            [103958] = { soundName = "metamorphosis",         type = "buff"    },
            [113858] = { soundName = "darkSoul",              type = "buff"    },
            [113861] = { soundName = "darkSoul",              type = "buff"    },
            [113860] = { soundName = "darkSoul",              type = "buff"    },
            [111397] = { soundName = "bloodHorror",           type = "buff"    },
            [104773] = { soundName = "unendingResolve",       type = "buff"    },
            [6789]   = { soundName = "mortalCoil",            type = "debuff"  },
            [89766]  = { soundName = "petStun",               type = "debuff"  },
            [118093] = { soundName = "disarm",                type = "debuff"  },
            [5782]   = { soundName = "fearWarlock",           type = "cast"    },
            [116858] = { soundName = "chaosBolt",             type = "cast"    },
            [6358]   = { soundName = "seduction",             type = "cast"    },
            [115268] = { soundName = "seduction",             type = "cast"    },
            [688]    = { soundName = "summonImp",             type = "cast"    },
            [697]    = { soundName = "summonVoidwalker",      type = "cast"    },
            [712]    = { soundName = "summonSuccube",         type = "cast"    },
            [691]    = { soundName = "summonFelhunter",       type = "cast"    },
            [30146]  = { soundName = "summonFelGuard",        type = "cast"    },
            [18540]  = { soundName = "summonDoomguard",       type = "cast"    },
            [111771] = { soundName = "demonicGateway",        type = "cast"    },
            [48181]  = { soundName = "haunt",                 type = "cast"    },
            [80240]  = { soundName = "havoc",                 type = "ability" },
            [5484]   = { soundName = "howlOfTerror",          type = "ability" },
            [48020]  = { soundName = "demonicCircleTeleport", type = "ability" },
            [30283]  = { soundName = "shadowfury",            type = "ability" },
            [108482] = { soundName = "unboundWill",           type = "ability" },
            [86121]  = { soundName = "soulSwap",              type = "ability" },
            [24259]  = { soundName = "spellLock",             type = "kick"    }
        },

        WARRIOR = {
            [55694]  = { soundName = "enragedRegeneration",   type = "buff"    },
            [46924]  = { soundName = "bladestorm",            type = "buff"    },
            [871]    = { soundName = "shieldWall",            type = "buff"    },
            [18499]  = { soundName = "berserkerRage",         type = "buff"    },
            [1719]   = { soundName = "recklessness",          type = "buff"    },
            [23920]  = { soundName = "spellReflection",       type = "buff"    },
            [12975]  = { soundName = "lastStand",             type = "buff"    },
            [118038] = { soundName = "dieByTheSword",         type = "buff"    },
            [12328]  = { soundName = "sweepingStrikes",       type = "buff"    },
            [107574] = { soundName = "avatar",                type = "buff"    },
            [12292]  = { soundName = "bloodbath",             type = "buff"    },
            [114029] = { soundName = "safeguard",             type = "buff"    },
            [147833] = { soundName = "intervene",             type = "buff"    },
            [114030] = { soundName = "vigilance",             type = "buff"    },
            [122294] = { soundName = "sStampedingShout",      type = "buff"    }, -- Symbiosis
            [64382]  = { soundName = "shatteringThrow",       type = "cast"    },
            [5246]   = { soundName = "fearWarrior",           type = "ability" },
            [676]    = { soundName = "disarm",                type = "ability" },
            [46968]  = { soundName = "shockwave",             type = "ability" },
            [97462]  = { soundName = "RallyingCry",           type = "ability" },
            [2457]   = { soundName = "battleStance",          type = "ability" },
            [71]     = { soundName = "defensiveStance",       type = "ability" },
            [2458]   = { soundName = "berserkerStance",       type = "ability" },
            [107570] = { soundName = "stormBolt",             type = "ability" },
            [107566] = { soundName = "staggeringShout",       type = "ability" },
            [118000] = { soundName = "dragonRoar",            type = "ability" },
            [114028] = { soundName = "massSpellReflection",   type = "ability" },
            [6552]   = { soundName = "pummel",                type = "kick"    },
            [102060] = { soundName = "disruptingShout",       type = "kick"    },
            [20511]  = { --[[Intimidating Shout]]             type = "display" },
            [97463]  = { --[[Rallying Cry]]                   type = "display" }
        }
    }
end

function GladiatorlosSA:GetFriendReflectedSound()
    return "reflected"
end

function GladiatorlosSA:GetEnemyReflectedSound()
    return "enemyReflected"
end

function GladiatorlosSA:GetEnemyInterruptedSuccessSound()
    return "interrupted"
end

function GladiatorlosSA:GetFriendInterruptedSuccessSound()
    return "Lockout"
end

function GladiatorlosSA:GetAuraDownSound()
    return "Down"
end

function GladiatorlosSA:GetCastSuccessSound()
    return "success"
end

function GladiatorlosSA:GetDrinkingSound()
    return "drinking"
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
