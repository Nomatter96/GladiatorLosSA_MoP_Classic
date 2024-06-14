-- Initialize OptionTable with descrtiption
-- Open options->addons->GladiatorLosSA to see how it's look like

local GSA = GladiatorlosSA
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")

function GladiatorlosSA:InitializeOptionTable()
    local options = {
        name = "GladiatorlosSA",
        desc = L["PVP Voice Alert"],
        type = 'group',
        args = {
            creditdesc = {
                order = 1,
                type = "description",
                name = L["GladiatorlosSACredits"].."\n",
                cmdHidden = true
            },
            gsavers = {
                order = 2,
                type = "description",
                name = L["GSA_VERSION"],
                cmdHidden = true
            }
        },
    }
    options.args.load = {
        name = L["Load Configuration"],
        desc = L["Load Configuration Options"],
        type = 'execute',
        func = function()
            self:OnOptionCreate()
            options.args.load.disabled = true
            GameTooltip:Hide()
        end,
        handler = GSA,
    }

    LibStub("AceConfig-3.0"):RegisterOptionsTable("GladiatorlosSA_bliz", options)
	AceConfigDialog:AddToBlizOptions("GladiatorlosSA_bliz", "GladiatorlosSA")
end

