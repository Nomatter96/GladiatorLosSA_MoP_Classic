local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")

function GSA:CreateSpellsOption()
    gsadb = self.db1.profile
    return {
        type = 'group',
        name = L["Abilities"],
        desc = L["Abilities options"],
        childGroups = "tab",
        order = -2,
        args = {
            spellTypeDisable   = GSA:CreateSpellTypeDisableGroup(),
            auraAppliedToggles = GSA:CreateTypeSpellsTab( L["Buff Applied"],              1, function() return not gsadb.isAuraAppliedEnable end, {"buff", "debuff"}  ),
            auraDownToggles    = GSA:CreateTypeSpellsTab( L["Buff Down"],                 2, function() return not gsadb.isAuraDownEnable end,    {"buff"}            ),
            castStartToggles   = GSA:CreateTypeSpellsTab( L["Cast Spell / Cast Success"], 3, function() return not gsadb.isCastStartEnable end,   {"cast"}            ),
            castSuccessToggles = GSA:CreateTypeSpellsTab( L["Simple Spells"],             4, function() return not gsadb.isCastSuccessEnable end, {"ability"}         ),
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
                name = L["Disable Buff Applied"],
                desc = L["Check this will disable alert for buff applied to hostile targets"],
                order = 1
            },
            isAuraDownEnable = {
                type = 'toggle',
                name = L["Disable Buff Down"],
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
        set = function(info, value) gsadb[info[#info]] = value end,
		get = function(info) return gsadb[info[#info]] end,
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
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetDrinkingSound()) end
				end
            },
            IsSoundSuccessCastEnable = {
                type = 'toggle',
                name = L["Alert Cast success"],
                order = 3,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetCastSuccessSound()) end
				end
            },
            pvpTrinket = {
                type = 'toggle',
                name = L["PvP Trinketed Class"],
                desc = L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"],
                order = 4,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then
						local _, engClass = GetPlayerInfoByGUID(UnitGUID("player"))
						self:PlaySound(self:GetClassTrinketSound(engClass))
					end
				end
            },
            IsEnemyUseInterruptEnable = {
                type = 'toggle',
                name = L["Enemy Use Interrupt"],
                order = 5,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetEnemyInterruptedSuccessSound()) end
				end
            },
            IsFriendUseInterruptSuccessEnable = {
                type = 'toggle',
                name = L["Friend use interrupt successful"],
                order = 6,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetFriendInterruptedSuccessSound()) end
				end
            },
            IsEnemyReflectedEnable = {
                type = 'toggle',
                name = L["Enemy Reflected"],
                desc = L["Enemy Reflected Desc"],
                order = 7,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetEnemyReflectedSound()) end
				end
            },
            IsFriendReflectedEnable = {
                type = 'toggle',
                name = L["Friend Reflected"],
                desc = L["Friend Reflected Desc"],
                order = 8,
				set = function(info, value)
					gsadb[info[#info]] = value
					if value then self:PlaySound(self:GetFriendReflectedSound()) end
				end
            }
        }
    }
end

local groups_options = {
	GENERAL     = { name = L["General Abilities"],        kind = "GENERAL",     order = 1  },
	RACIAL      = { name = L["Racials"],                  kind = "RACIAL",      order = 2  },
	DRUID       = { name = L["|cffFF7D0ADruid|r"],        kind = "DRUID",       order = 3  },
	HUNTER      = { name = L["|cffABD473Hunter|r"],       kind = "HUNTER",      order = 4  },
	MAGE        = { name = L["|cff69CCF0Mage|r"],         kind = "MAGE",        order = 5  },
	PALADIN     = { name = L["|cffF58CBAPaladin|r"],      kind = "PALADIN",     order = 6  },
	PRIEST      = { name = L["|cffFFFFFFPriest|r"],       kind = "PRIEST",      order = 7  },
	ROGUE       = { name = L["|cffFFF569Rogue|r"],        kind = "ROGUE",       order = 8  },
	SHAMAN      = { name = L["|cff0070daShaman|r"],       kind = "SHAMAN",      order = 9  },
	WARLOCK     = { name = L["|cff9482C9Warlock|r"],      kind = "WARLOCK",     order = 10 },
	WARRIOR     = { name = L["|cffC79C6EWarrior|r"],      kind = "WARRIOR",     order = 11 },
	DEATHKNIGHT = { name = L["|cffC41F3BDeath Knight|r"], kind = "DEATHKNIGHT", order = 12 }
}

local function CreateSpellTooltip(spellID)
	local _, _, _, castTime, minRange, maxRange, _ = GetSpellInfo(spellID)
	local cost = GetSpellPowerCost(spellID)
	local spellDesc = GetSpellDescription(spellID)

	if spellDesc == "" then
		spellDesc = "If you see this then use /reload please, because Blizzard's API doesn't work well"
	end
	local tooltip = ""
	if cost["cost"] then
		tooltip = tooltip .. cost["cost"] .. " " .. cost["name"] .. "|n"
	end
	if minRange ~= 0 or maxRange ~= 0 then
		tooltip = tooltip .. minRange .. "-" .. maxRange .. " yd range |n"
	end
	if castTime ~= 0 then
		tooltip = tooltip .. string.format("%.1f", castTime / 1000) .. " sec cast |n"
	end
	tooltip = tooltip .. "|cffFFF569" .. spellDesc .. "|r|n"
	tooltip = tooltip .. "|n|cffFFF569SpellID: " .. spellID .. "|r"
	return tooltip
end

local function CreateSpellToggle(number, spellID)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T" .. icon .. ":24\124t" .. spellname,			
			desc = CreateSpellTooltip(spellID),
			descStyle = "tooltip",
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
			gsadb[spellType][spellID] = value
			if value then
				GSA:PlaySound(currentSpell["soundName"])
				if spellType == "auraDownToggles" then
					C_Timer.After(currentSpell["durationSound"] - 0.1, function() self:PlaySound(self:GetAuraDownSound()) end)
				end
			end
		end,
		get = function(info, value)
			local spellType = info[2]
			local spellID = tonumber(info[#info])
			return gsadb[spellType][spellID]
		end,
		args = {
			GENERAL     = CreateClassSpellsGroup(filterType, groups_options["GENERAL"]),
			RACIAL      = CreateClassSpellsGroup(filterType, groups_options["RACIAL"]),
			DRUID       = CreateClassSpellsGroup(filterType, groups_options["DRUID"]),
			HUNTER      = CreateClassSpellsGroup(filterType, groups_options["HUNTER"]),
			MAGE        = CreateClassSpellsGroup(filterType, groups_options["MAGE"]),
			PALADIN     = CreateClassSpellsGroup(filterType, groups_options["PALADIN"]),
			PRIEST	    = CreateClassSpellsGroup(filterType, groups_options["PRIEST"]),
			ROGUE       = CreateClassSpellsGroup(filterType, groups_options["ROGUE"]),
			SHAMAN	    = CreateClassSpellsGroup(filterType, groups_options["SHAMAN"]),
			WARLOCK	    = CreateClassSpellsGroup(filterType, groups_options["WARLOCK"]),
			WARRIOR	    = CreateClassSpellsGroup(filterType, groups_options["WARRIOR"]),
			DEATHKNIGHT	= CreateClassSpellsGroup(filterType, groups_options["DEATHKNIGHT"])
		}
	}
end