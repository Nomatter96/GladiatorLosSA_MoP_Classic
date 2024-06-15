local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local options_created = false -- ***** @

local GSA_OUTPUT = {["MASTER"] = L["Master"],["SFX"] = L["SFX"],["AMBIENCE"] = L["Ambience"],["MUSIC"] = L["Music"],["DIALOG"] = L["Dialog"]}

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

function GSA:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(GladiatorlosSA)
end

function GSA:ChangeProfile()
	gsadb = self.db1.profile
	for k,v in GladiatorlosSA:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
end

function GSA:AddOption(name, keyName)
	return AceConfigDialog:AddToBlizOptions("GladiatorlosSA", name, "GladiatorlosSA", keyName)
end

-- TODO
local function setOption(info, value)
	if info[2] == "auraAppliedToggles" or info[2] == "auraDownToggles" or info[2] == "castStartToggles" or info[2] == "castSuccessToggles" then
		local spellType = info[2]
		local kind = info[3]
		local spellID = tonumber(info[#info])
		gsadb[spellType][spellID] = value
		if value then
			GSA:PlaySound(GSA.spellList[kind][spellID]["soundName"])
		end
	else
		local name = info[#info]
		gsadb[name] = value
		if value then
			GSA:PlaySound(name)
		end
	end
	GSA:CheckCanPlaySound()
end

local function getOption(info)
	if info[2] == "auraAppliedToggles" or info[2] == "auraDownToggles" or info[2] == "castStartToggles" or info[2] == "castSuccessToggles" then
		local spellType = info[2]
		local spellID = tonumber(info[#info])
		return gsadb[spellType][spellID]
	else
		local name = info[#info]
		return gsadb[name]
	end
end

local function CreateSpellTooltip(spellID)
	local _, _, _, castTime, minRange, maxRange, _ = GetSpellInfo(spellID)
	local cost = GetSpellPowerCost(spellID)
	local spell  = Spell:CreateFromSpellID(spellID)
	local spellDesc = ""
	spell:ContinueWithCancelOnSpellLoad(function()
		spellDesc = GetSpellDescription(spell:GetSpellID())
	end)
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
		GSA.log("spell id: " .. spellID .. " is invalid")
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

local function CreateTypeSpellsGroup(aName, aOrder, disabledFunction, filterType)
	return {
		type = 'group',
		name = aName,
		disabled = disabledFunction,
		order = aOrder,
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
	
function GSA:OnOptionCreate()
	gsadb = self.db1.profile
	options_created = true -- ***** @
	self.options = {
		type = "group",
		name = GetAddOnMetadata("GladiatorlosSA", "Title"),
		args = {
			general = {
				type = 'group',
				name = L["General"],
				desc = L["General options"],
				set = setOption,
				get = getOption,
				order = 1,
				args = {
					enableArea = {
						type = 'group',
						inline = true,
						name = L["Enable area"],
						order = 1,
						args = {
							all = {
								type = 'toggle',
								name = L["Anywhere"],
								desc = L["Alert works anywhere"],
								order = 10,
							},
							NewLine1 = {
								type= 'description',
								order = 30,
								name= '',
							},
							arena = {
								type = 'toggle',
								name = L["Arena"],
								desc = L["Alert only works in arena"],
								disabled = function() return gsadb.all end,
								order = 40,
							},
							battleground = {
								type = 'toggle',
								name = L["Battleground"],
								desc = L["Alert only works in BG"],
								disabled = function() return gsadb.all end,
								order = 50,
							},
							epicbattleground = {
								type = 'toggle',
								name = L["epicbattleground"],
								desc = L["epicbattlegroundDesc"],
								disabled = function() return gsadb.all end,
								order = 60,
							},
							NewLine2 = {
								type= 'description',
								order = 70,
								name= '',
							},
							field = {
								type = 'toggle',
								name = L["World"],
								desc = L["Alert works anywhere else then anena, BG, dungeon instance"],
								disabled = function() return gsadb.all end,
								order = 80,
							}
						}
					},
					voice = {
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
								order = 1,
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
								order = 6,
							},
						},
					},
					advance = {
						type = 'group',
						inline = true,
						name = L["Advance options"],
						order = 3,
						args = {
							smartDisable = {
								type = 'toggle',
								name = L["Smart disable"],
								desc = L["Disable addon for a moment while too many alerts comes"],
								order = 1,
							},
							throttle = {
								type = 'range',
								max = 5,
								min = 0,
								step = 0.1,
								name = L["Throttle"],
								desc = L["The minimum interval of each alert"],
								disabled = function() return not gsadb.smartDisable end,
								order = 2,
							},
							NewLineOutput = {
								type= 'description',
								order = 3,
								name= '',
							},
							outputUnlock = {
								type = 'toggle',
								name = L["Change Output"],
								desc = L["Unlock the output options"],
								order = 8,
								confirm = true,
								confirmText = L["Are you sure?"],
							},
							output_menu = {
								type = 'select',
								name = L["Output"],
								desc = L["Select the default output"],
								values = GSA_OUTPUT,
								order = 10,
								disabled = function() return not gsadb.outputUnlock end,
							},
						},
					},
				},
			},
			spells = {
				type = 'group',
				name = L["Abilities"],
				desc = L["Abilities options"],
				set = setOption,
				get = getOption,
				childGroups = "tab",
				order = -2,
				args = {
					menu_voice = {
						type = 'group',
						inline = true,
						name = L["Voice menu config"], 
						order = -3,
						args = {
							path_menu = {
								type = 'select',
								name = L["Choose a test voice pack"],
								desc = L["Select the menu voice pack alert"], 
								values = self.GSA_LANGUAGE,
								order = 1
							}
						}
					},
					spellDisable = {
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
								order = 1,
							},
							isAuraDownEnable = {
								type = 'toggle',
								name = L["Disable Buff Down"],
								desc = L["Check this will disable alert for buff removed from hostile targets"],
								order = 2,
							},
							isCastStartEnable = {
								type = 'toggle',
								name = L["Disable Spell Casting"],
								desc = L["Chech this will disable alert for spell being casted to friendly targets"],
								order = 3,
							},
							isCastSuccessEnable = {
								type = 'toggle',
								name = L["Disable special abilities"],
								desc = L["Check this will disable alert for instant-cast important abilities"],
								order = 4,
							}
							--interruptedfriendly = {
							--	type = 'toggle',
							--	name = L["FriendlyInterrupted"],
							--	desc = L["FriendlyInterruptedDesc"],
							--	order = 5,
							--}
						}
					},
					generalOptions = {
						type = 'group',
						name = L["General options"],
						inline = true,
						order = -1,
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
								order = 2
							},
							resurrection = {
								type = 'toggle',
								name = L["Resurrection"],
								desc = L["Resurrection_Desc"],
								order = 3
							},
							pvpTrinket = {
								type = 'toggle',
								name = L["PvP Trinketed Class"],
								desc = L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"],
								order = 4
							},
							isInterruptEnable = {
								type = 'toggle',
								name = L["Enable interrupt"],
								order = 5,
							}
						}
					},
					auraAppliedToggles = CreateTypeSpellsGroup( L["Buff Applied"],      1, function() return not gsadb.isAuraAppliedEnable end, {"buff", "debuff"}  ),
					auraDownToggles    = CreateTypeSpellsGroup( L["Buff Down"],         2, function() return not gsadb.isAuraDownEnable end,    {"buff"}            ),
					castStartToggles   = CreateTypeSpellsGroup( L["Spell Cast"],        3, function() return not gsadb.isCastStartEnable end,   {"cast", "success"} ),
					castSuccessToggles = CreateTypeSpellsGroup( L["Special Abilities"], 4, function() return not gsadb.isCastSuccessEnable end, {"success"}         )
				},
			}
		}
	}

	AceConfig:RegisterOptionsTable("GladiatorlosSA", self.options)
	self:AddOption(L["General"], "general")
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1)
	self.options.args.profiles.order = -1
	
	self:AddOption(L["Abilities"], "spells")
	self:AddOption(L["Profiles"], "profiles")
end