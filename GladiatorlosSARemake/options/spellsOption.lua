local GSA = GladiatorlosSA
local GSA_Settings
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

function GSA:CreateSpellsOption()
    GSA_Settings = self.db1.profile
    return {
        type = 'group',
        name = L["Abilities"],
        desc = L["Abilities options"],
        childGroups = "tab",
        order = -2,
        args = {
            spellTypeDisable   = GSA:CreateSpellTypeDisableGroup(),
            auraAppliedToggles = GSA:CreateTypeSpellsTab( L["Aura Applied"],              1, function() return not GSA_Settings.isAuraAppliedEnable end, {"buff", "debuff"}  ),
            auraDownToggles    = GSA:CreateTypeSpellsTab( L["Aura Down"],                 2, function() return not GSA_Settings.isAuraDownEnable end,    {"buff"}            ),
            castStartToggles   = GSA:CreateTypeSpellsTab( L["Cast Spell / Cast Success"], 3, function() return not GSA_Settings.isCastStartEnable end,   {"cast"}            ),
            castSuccessToggles = GSA:CreateTypeSpellsTab( L["Simple Spells"],             4, function() return not GSA_Settings.isCastSuccessEnable end, {"ability", "kick"} ),
            extraFunctions     = GSA:CreateExtraFunctionsGroup()
        }
    }
end

function GSA:CreateSpellTypeDisableGroup()
    return {
        type = 'group',
        name = L["Disable options"],
        desc = L["Disable abilities by type"],
        inline = true,
        order = -2,
        args = {
            isAuraAppliedEnable = {
                type = 'toggle',
                name = L["Disable Aura Applied"],
                desc = L["Check this will disable alert for buff applied to hostile targets"],
                order = 1
            },
            isAuraDownEnable = {
                type = 'toggle',
                name = L["Disable Aura Down"],
                desc = L["Check this will disable alert for buff removed from hostile targets"],
                order = 2
            },
            isCastStartEnable = {
                type = 'toggle',
                name = L["Disable Spell Casting"],
                desc = L["Chech this will disable alert for spell being casted to friendly targets"],
                order = 3
            },
            isCastSuccessEnable = {
                type = 'toggle',
                name = L["Disable special abilities"],
                desc = L["Check this will disable alert for instant-cast important abilities"],
                order = 4
            }
        }
    }
end

function GSA:CreateExtraFunctionsGroup()
    return {
        type = 'group',
        name = L["Spell Extra Functions"],
        order = 5,
        set = function(info, value) GSA_Settings[info[#info]] = value end,
		get = function(info) return GSA_Settings[info[#info]] end,
        args = {
            onlyTargetFocus = {
                type = 'toggle',
                name = L["Target and Focus Only"],
                desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
                order = 1
            },
            drinking = {
                type = 'toggle',
                name = L["Alert Drinking"],
                desc = L["In arena, alert when enemy is drinking"],
                order = 2,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetDrinkingSound()) end
				end
            },
            IsSoundSuccessCastEnable = {
                type = 'toggle',
                name = L["Alert Cast success"],
                order = 3,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetCastSuccessSound()) end
				end
            },
            pvpTrinket = {
                type = 'toggle',
                name = L["PvP Trinketed Class"],
                desc = L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"],
                order = 4,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then
						local _, engClass = GetPlayerInfoByGUID(UnitGUID("player"))
						self:PlaySound(GSA_Settings.voiceLocalePath .. engClass)
					end
				end
            },
            IsEnemyUseInterruptEnable = {
                type = 'toggle',
                name = L["Enemy Use Interrupt"],
                order = 5,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetEnemyInterruptedSuccessSound()) end
				end
            },
            IsFriendUseInterruptSuccessEnable = {
                type = 'toggle',
                name = L["Friend use interrupt successful"],
                order = 6,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetFriendInterruptedSuccessSound()) end
				end
            },
            IsEnemyReflectedEnable = {
                type = 'toggle',
                name = L["Enemy Reflected"],
                desc = L["Enemy Reflected Desc"],
                order = 7,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetEnemyReflectedSound()) end
				end
            },
            IsFriendReflectedEnable = {
                type = 'toggle',
                name = L["Friend Reflected"],
                desc = L["Friend Reflected Desc"],
                order = 8,
				set = function(info, value)
					GSA_Settings[info[#info]] = value
					if value then self:PlaySound(GSA_Settings.voiceLocalePath .. self:GetFriendReflectedSound()) end
				end
            }
        }
    }
end

local function CreateSpellToggle(number, spellID)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T" .. icon .. ":24\124t" .. spellname,			
			desc = C_Spell.GetSpellDescription(spellID),
			tooltipHyperlink = C_Spell.GetSpellLink(spellID),
			order = number
		}
	else
		GSA:log("spell id: " .. spellID .. " is invalid")
		return {
			type = 'toggle',
			name = "Unknown Spell; ID:" .. spellID,	
			order = number
		}
	end
end

local function CreateSpellListToggle(spellList, spellTypes)
	local args = {}
	local n = 0
	for id, body in pairs(spellList) do
		for _, spellType in pairs(spellTypes) do
			if spellType == body["type"] then
				n = n + 1
				rawset (args, tostring(id), CreateSpellToggle(n, id))
			end
		end
	end
	return args
end

local function CreateClassSpellsGroup(spellTypes, groupOption)
	local spellList = CreateSpellListToggle(GSA.spellList[groupOption["kind"]], spellTypes)
	return {
		type = 'group',
		inline = true,
		name = groupOption["name"],
		order = groupOption["order"],
		args = spellList,
		hidden = next(spellList) == nil
	}
end

function GSA:CreateTypeSpellsTab(aName, aOrder, disabledFunction, filterType)
	return {
		type = 'group',
		name = aName,
		disabled = disabledFunction,
		order = aOrder,
		set = function(info, value)
			local spellType = info[2]
			local spellID = tonumber(info[#info])
			local currentSpell = GSA:FindSpellByID(spellID)
			GSA_Settings[spellType][spellID] = value
			if value then
				if spellType == "auraDownToggles" then
					GSA:PlaySpell(spellID, currentSpell["soundName"].."Down")
				else
					GSA:PlaySpell(spellID, currentSpell["soundName"])
				end
			end
		end,
		get = function(info, value)
			local spellType = info[2]
			local spellID = tonumber(info[#info])
			return GSA_Settings[spellType][spellID]
		end,
		args = {
			GENERAL     = CreateClassSpellsGroup(filterType, GSA["groups_options"]["GENERAL"]),
			RACIAL      = CreateClassSpellsGroup(filterType, GSA["groups_options"]["RACIAL"]),
			DRUID       = CreateClassSpellsGroup(filterType, GSA["groups_options"]["DRUID"]),
			HUNTER      = CreateClassSpellsGroup(filterType, GSA["groups_options"]["HUNTER"]),
			MAGE        = CreateClassSpellsGroup(filterType, GSA["groups_options"]["MAGE"]),
			PALADIN     = CreateClassSpellsGroup(filterType, GSA["groups_options"]["PALADIN"]),
			PRIEST	    = CreateClassSpellsGroup(filterType, GSA["groups_options"]["PRIEST"]),
			ROGUE       = CreateClassSpellsGroup(filterType, GSA["groups_options"]["ROGUE"]),
			SHAMAN	    = CreateClassSpellsGroup(filterType, GSA["groups_options"]["SHAMAN"]),
			WARLOCK	    = CreateClassSpellsGroup(filterType, GSA["groups_options"]["WARLOCK"]),
			WARRIOR	    = CreateClassSpellsGroup(filterType, GSA["groups_options"]["WARRIOR"]),
			DEATHKNIGHT	= CreateClassSpellsGroup(filterType, GSA["groups_options"]["DEATHKNIGHT"]),
			MONK	    = CreateClassSpellsGroup(filterType, GSA["groups_options"]["MONK"])
		}
	}
end