local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")

function GSA:CreateGeneralOption()
    gsadb = self.db1.profile
    return {
        type = 'group',
        name = L["General"],
        order = 1,
        args = {
            enableArea = GSA:CreateEnableAreaGroup(),
            voice      = GSA:CreateVoiceGroup(),
            advance    = GSA:CreateAdvanceGroup()
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
            all = {
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
            arena = {
                type = 'toggle',
                name = L["Arena"],
                desc = L["Alert only works in arena"],
                disabled = function() return gsadb.all end,
                order = 3
            },
            battleground = {
                type = 'toggle',
                name = L["Battleground"],
                desc = L["Alert only works in BG"],
                disabled = function() return gsadb.all end,
                order = 4
            },
            epicbattleground = {
                type = 'toggle',
                name = L["epicbattleground"],
                desc = L["epicbattlegroundDesc"],
                disabled = function() return gsadb.all end,
                order = 5
            },
            NewLine2 = {
                type= 'description',
                order = 6,
                name= ''
            },
            field = {
                type = 'toggle',
                name = L["World"],
                desc = L["Alert works anywhere else then anena, BG, dungeon instance"],
                disabled = function() return gsadb.all end,
                order = 7
            }
        }
    }
end

function GSA:CreateVoiceGroup()
    return {
        type = 'group',
        inline = true,
        name = L["Voice config"],
        order = 2,
        args = {
            path = {
                type = 'select',
                name = L["Default / Female voice"],
                desc = L["Select the default voice pack of the alert"],
                values = self.GSA_LANGUAGE,
                order = 1
            },
            volumn = {
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
        order = 3,
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
                disabled = function() return not gsadb.smartDisable end,
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
                disabled = function() return not gsadb.outputUnlock end
            }
        }
    }
end