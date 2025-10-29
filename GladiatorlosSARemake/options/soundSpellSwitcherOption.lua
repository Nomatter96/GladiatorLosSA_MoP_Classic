local GSA = GladiatorlosSA
local GSA_Settings
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

local function CreateSoundSelect(number, spellID)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'select',
			name = "\124T" .. icon .. ":24\124t" .. spellname,			
			desc = C_Spell.GetSpellDescription(spellID),
			tooltipHyperlink = C_Spell.GetSpellLink(spellID),
            values = GSA.GSA_LANGUAGE,
			order = number,
			hidden = function(info)
				local id = tonumber(info[#info])
				if not (GSA_Settings.auraAppliedToggles[id] or GSA_Settings.castStartToggles[id] or GSA_Settings.castSuccessToggles[id]) then
					return true
				end
				return false
			end,
            set = function(info, value) -- rewrite sounds path
                local id = tonumber(info[#info])
                GSA_Settings["spellSoundPaths"][id] = value
                local currentSpell = GSA:FindSpellByID(id)
                GSA:PlaySpell(id, currentSpell["soundName"])
            end,
            get = function(info)
				local id = tonumber(info[#info])
				
				
                
                return GSA_Settings["spellSoundPaths"][id]
            end
		}
	else
		GSA:log("spell id: " .. spellID .. " is invalid")
		return {
			type = 'select',
			name = "Unknown Spell; ID:" .. spellID,	
			order = number
		}
	end
end

local function CreateSoundLSelectList(spellList, spellTypes)
    local args = {}
	local n = 0
    for id, body in pairs(spellList) do
		for _, spellType in pairs(spellTypes) do
			if spellType == body["type"] then
				n = n + 1
				rawset (args, tostring(id), CreateSoundSelect(n, id))
			end
		end
	end
	return args
end

local function CreateClassSpellsGroup(spellTypes, groupOption)
	local spellList = CreateSoundLSelectList(GSA.spellList[groupOption["kind"]], spellTypes)
	return {
		type = 'group',
		inline = true,
		name = groupOption["name"],
		order = groupOption["order"],
		args = spellList,
		hidden = next(spellList) == nil
	}
end

local function CreateTypeSpellsSelectsTab(aName, aOrder, filterType)
	return {
		type = 'group',
		name = aName,
		order = aOrder,
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

function GSA:CreateSoundSpellSwitcherOption()
    GSA_Settings = self.db1.profile
    return {
        type = 'group',
        name = "Sound Abilities Switcher",
        childGroups = "tab",
        order = 1,
        args = {
            auraAppliedSelects = CreateTypeSpellsSelectsTab( L["Aura Applied"],              1, {"buff", "debuff"}  ),
            castStartSelects   = CreateTypeSpellsSelectsTab( L["Cast Spell / Cast Success"], 2, {"cast"}            ),
            castSuccessSelects = CreateTypeSpellsSelectsTab( L["Simple Spells"],             3, {"ability", "kick"} )
        }
    }
end