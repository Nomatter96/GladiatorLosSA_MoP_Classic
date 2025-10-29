local GSA = GladiatorlosSA
local GSA_Settings
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

function GSA:CreateGeneralOption()
    GSA_Settings = self.db1.profile
    return {
        type = 'group',
        name = L["General"],
        order = 1,
        args = {
            enableArea    = GSA:CreateEnableAreaGroup(),
            displaySpells = GSA:CreateDisplaySpellsGroup(),
            voice         = GSA:CreateVoiceGroup(),
            advance       = GSA:CreateAdvanceGroup()
        }
    }
end

function GSA:CreateEnableAreaGroup()
    return {
        type = 'group',
        inline = true,
        name = L["Enable area"],
        order = 1,
        args = {
            anywhereSAEnabled = {
                type = 'toggle',
                name = L["Anywhere"],
                desc = L["Alert works anywhere"],
                order = 1
            },
            NewLine1 = {
                type= 'description',
                order = 2,
                name= ''
            },
            arenaSAEnabled = {
                type = 'toggle',
                name = L["Arena"],
                desc = L["Alert only works in arena"],
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 3
            },
            battlegroundSAEnabled = {
                type = 'toggle',
                name = L["Battleground"],
                desc = L["Alert only works in BG"],
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 4
            },
            epicBattlegroundSAEnabled = {
                type = 'toggle',
                name = L["epicbattleground"],
                desc = L["epicbattlegroundDesc"],
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 5
            },
            NewLine2 = {
                type= 'description',
                order = 6,
                name= ''
            },
            worldSAEnabled = {
                type = 'toggle',
                name = L["World"],
                desc = L["Alert works anywhere else then anena, BG, dungeon instance"],
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 7
            }
        }
    }
end

function GSA:CreateDisplaySpellsGroup()
    return {
        type = 'group',
        inline = true,
        name = "Display Spells (Only work on arena. First implementation)",
        order = 2,
        args = {
            displayEnemyBuffs = {
                type = 'toggle',
                name = "Enemy Buffs",
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 1
            },
            displayPartyDebuffs = {
                type = 'toggle',
                name = "Party Debuffs",
                disabled = function() return GSA_Settings.anywhereSAEnabled end,
                order = 2
            },
            executeTest = {
                name = "Execute Test",
                desc = "",
                type = 'execute',
                func = function()
                    GSA:ParseAuras("arena1", GSA.DebugDisplaySpells)
                    GSA:ParseAuras("party1", GSA.DebugDisplaySpells)
                end,
                handler = GSA,
                order = 3
            },
            NewLine1 = {
                type= 'description',
                name= '',
                order = 4
            },
            aurasBarMovable = {
                name = "Move bars",
                desc = "",
                type = 'toggle',
                set  = function(info, val)
                    GSA_Settings.aurasBarMovable = val
                    GSA:SetAurasBarMoveable(val)
                end,
                order = 5
            }
        }
    }
end

function GSA:CreateVoiceGroup()
    return {
        type = 'group',
        inline = true,
        name = L["Voice config"],
        order = 3,
        args = {
            voiceLocalePath = {
                type = 'select',
                name = L["Default / Female voice"] .. " READ DESCRIPTION",
                desc = "ATTENTION! If you change preset then all sounds in Sound Abilities Switcher will reset",
                values = self.GSA_LANGUAGE,
                set = function(info, value) -- rewrite sounds path for all spells
                    GSA_Settings[info[#info]] = value
                    for id, soundPath in pairs(GSA_Settings["spellSoundPaths"]) do
                        GSA_Settings["spellSoundPaths"][id] = value
                    end
                end,
                order = 1
            },
            volume = {
                type = 'range',
                max = 1,
                min = 0,
                step = 0.1,
                name = L["Master Volume"],
                desc = L["adjusting the voice volume(the same as adjusting the system master sound volume)"],
                set = function (info, value) SetCVar ("Sound_MasterVolume",tostring (value)) end,
                get = function () return tonumber (GetCVar ("Sound_MasterVolume")) end,
                order = 6
            }
        }
    }
end

local GSA_OUTPUT = {["MASTER"] = L["Master"],["SFX"] = L["SFX"],["AMBIENCE"] = L["Ambience"],["MUSIC"] = L["Music"],["DIALOG"] = L["Dialog"]}

function GSA:CreateAdvanceGroup()
    return {
        type = 'group',
        inline = true,
        name = L["Advance options"],
        order = 4,
        args = {
            smartDisable = {
                type = 'toggle',
                name = L["Smart disable"],
                desc = L["Disable addon for a moment while too many alerts comes"],
                order = 1
            },
            throttle = {
                type = 'range',
                max = 5,
                min = 0,
                step = 0.1,
                name = L["Throttle"],
                desc = L["The minimum interval of each alert"],
                disabled = function() return not GSA_Settings.smartDisable end,
                order = 2
            },
            NewLineOutput = {
                type= 'description',
                order = 3,
                name= ''
            },
            outputUnlock = {
                type = 'toggle',
                name = L["Change Output"],
                desc = L["Unlock the output options"],
                order = 8,
                confirm = true,
                confirmText = L["Are you sure?"]
            },
            output_menu = {
                type = 'select',
                name = L["Output"],
                desc = L["Select the default output"],
                values = GSA_OUTPUT,
                order = 10,
                disabled = function() return not GSA_Settings.outputUnlock end
            }
        }
    }
end