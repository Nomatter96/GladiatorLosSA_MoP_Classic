local GSA = GladiatorlosSA
local GSALocale = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

local GSA_LOCALEPATH = {
    enUS = "Voice_enUS\\",
}
GSA.GSA_LOCALEPATH = GSA_LOCALEPATH

local GSA_LANGUAGE = {
    ["Voice_enUS\\"] = GSALocale["English(female)"],
    ["Voice_enUS_Short\\"] = GSALocale["English Short (female)"],
    ["Voice_zhCN\\"] = "中文 (empty folder)"
}
GSA.GSA_LANGUAGE = GSA_LANGUAGE

local GSA_EVENT = {
    SPELL_CAST_SUCCESS = GSALocale["Spell_CastSuccess"],
    SPELL_CAST_START   = GSALocale["Spell_CastStart"],
    SPELL_AURA_APPLIED = GSALocale["Spell_AuraApplied"],
    SPELL_AURA_REMOVED = GSALocale["Spell_AuraRemoved"],
    SPELL_INTERRUPT    = GSALocale["Spell_Interrupt"],
    SPELL_SUMMON       = GSALocale["Spell_Summon"],
    SPELL_MISSED       = GSALocale["SPELL_MISSED"]
}
GSA.GSA_EVENT = GSA_EVENT

local DefaultSettings = {
    profile = {
        -- Option's toggles zone sound alert enabled
        anywhereSAEnabled         = false,
        arenaSAEnabled            = true,
        battlegroundSAEnabled     = true,
        epicBattlegroundSAEnabled = false,
        worldSAEnabled            = false,

        -- Option's toggles
        displayEnemyBuffs   = true,
        displayPartyDebuffs = true,

        -- Option's select voice
        voiceLocalePath = GSA_LOCALEPATH[GetLocale()] or "Voice_enUS\\",
        spellSoundPaths = {},

        -- TODO need refactor
        throttle = 0,
        smartDisable = false,
        outputUnlock = false,
        output_menu = "MASTER",
        
        -- Option's toggles of groups spells
        isAuraAppliedEnable = true,
        isAuraDownEnable = true,
        isCastStartEnable = true,
        isCastSuccessEnable = true,

        -- Option's toggles of spells
        auraAppliedToggles = {},
        auraDownToggles = {},
        castStartToggles = {},
        castSuccessToggles = {},

        -- Option's toggles of extra functions
        onlyTargetFocus = false,
        drinking = false,
        pvpTrinket = false,
        IsEnemyUseInterruptEnable = true,
        IsFriendUseInterruptSuccessEnable = true,
        IsSoundSuccessCastEnable = true,
        IsEnemyReflectedEnable = true,
        IsFriendReflectedEnable = true,

        -- auras bar settings
        aurasBarMovable = false,
        sizeIconAuraBar = nil,
        offsetBetweenIconsAuraBar = nil,
        offsetAuraBar_Y = nil,
        defaultOffsetDebuffFrames_Y = nil,
        buffsBarSettings = nil,
        debuffsBarSettings = nil,
        -- Option's toggle of auras bar
        aurasBarMoveable = true
    }    
}
GSA.DefaultSettings = DefaultSettings

local DebugDisplaySpells = {
    addedAuras = {
        -- Recklessness
        {
            spellId        = 1719,
            isHelpful      = true,
            isHarmful      = false,
            auraInstanceID = 0,
            duration       = 12
        },
        -- Shadow Dance
        {
            spellId        = 51713,
            isHelpful      = true,
            isHarmful      = false,
            auraInstanceID = 1,
            duration       = 6
        },
        -- Fear Ward
        {
            spellId        = 6346,
            isHelpful      = true,
            isHarmful      = false,
            auraInstanceID = 1,
            duration       = 180
        },
        -- Sap
        {
            spellId        = 6770,
            isHelpful      = false,
            isHarmful      = true,
            auraInstanceID = 0,
            duration       = 8
        },
        -- Repentance
        {
            spellId        = 20066,
            isHelpful      = false,
            isHarmful      = true,
            auraInstanceID = 1,
            duration       = 8
        }
    }
}
GSA.DebugDisplaySpells = DebugDisplaySpells

local groups_options = {
	GENERAL     = { name = GSALocale["General Abilities"],        kind = "GENERAL",     order = 1  },
	RACIAL      = { name = GSALocale["Racials"],                  kind = "RACIAL",      order = 2  },
	DRUID       = { name = GSALocale["|cffFF7D0ADruid|r"],        kind = "DRUID",       order = 3  },
	HUNTER      = { name = GSALocale["|cffABD473Hunter|r"],       kind = "HUNTER",      order = 4  },
	MAGE        = { name = GSALocale["|cff69CCF0Mage|r"],         kind = "MAGE",        order = 5  },
	PALADIN     = { name = GSALocale["|cffF58CBAPaladin|r"],      kind = "PALADIN",     order = 6  },
	PRIEST      = { name = GSALocale["|cffFFFFFFPriest|r"],       kind = "PRIEST",      order = 7  },
	ROGUE       = { name = GSALocale["|cffFFF569Rogue|r"],        kind = "ROGUE",       order = 8  },
	SHAMAN      = { name = GSALocale["|cff0070daShaman|r"],       kind = "SHAMAN",      order = 9  },
	WARLOCK     = { name = GSALocale["|cff9482C9Warlock|r"],      kind = "WARLOCK",     order = 10 },
	WARRIOR     = { name = GSALocale["|cffC79C6EWarrior|r"],      kind = "WARRIOR",     order = 11 },
	DEATHKNIGHT = { name = GSALocale["|cffC41F3BDeath Knight|r"], kind = "DEATHKNIGHT", order = 12 },
	MONK        = { name = GSALocale["|cFF558A84Monk|r"],         kind = "MONK",        order = 13 }
}
GSA.groups_options = groups_options