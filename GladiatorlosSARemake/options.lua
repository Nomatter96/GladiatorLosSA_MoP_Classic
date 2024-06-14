local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local options_created = false -- ***** @

local GSA_OUTPUT = {["MASTER"] = L["Master"],["SFX"] = L["SFX"],["AMBIENCE"] = L["Ambience"],["MUSIC"] = L["Music"],["DIALOG"] = L["Dialog"]}

local groups_options = {
	general =     { name = L["General Abilities"],        kind = "general",     order = 30  },
	DRUID =       { name = L["|cffFF7D0ADruid|r"],        kind = "DRUID",       order = 70  },
	HUNTER =      { name = L["|cffABD473Hunter|r"],       kind = "HUNTER",      order = 80  },
	MAGE =        { name = L["|cff69CCF0Mage|r"],         kind = "MAGE",        order = 90  },
	PALADIN =     { name = L["|cffF58CBAPaladin|r"],      kind = "PALADIN",     order = 100 },
	PRIEST =      { name = L["|cffFFFFFFPriest|r"],       kind = "PRIEST",      order = 110 },
	ROGUE =       { name = L["|cffFFF569Rogue|r"],        kind = "ROGUE",       order = 120 },
	SHAMAN =      { name = L["|cff0070daShaman|r"],       kind = "SHAMAN",      order = 130 },
	WARLOCK =     { name = L["|cff9482C9Warlock|r"],      kind = "WARLOCK",     order = 140 },
	WARRIOR =     { name = L["|cffC79C6EWarrior|r"],      kind = "WARRIOR",     order = 150 },
	DEATHKNIGHT = { name = L["|cffC41F3BDeath Knight|r"], kind = "DEATHKNIGHT", order = 160 },
	races =       { name = L["Racials"],                  kind = "races",       order = 170 },
}

function GSA:ShowConfig()
	for i=1,2 do InterfaceOptionsFrame_OpenToCategory(GetAddOnMetadata("GladiatorlosSA2", "Title")) end -- ugly fix

end

function GSA:ShowConfig2() -- ***** @
	if options_created == false then
		self:OnOptionCreate()
	end
	AceConfigDialog:Open("GladiatorlosSA2")
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

local function spellOption(number, spellID)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T" .. icon .. ":24\124t" .. spellname,			
			desc = function ()
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
				GameTooltip:SetHyperlink(GetSpellLink(spellID))
				GameTooltip:Show()
			end,
			descStyle = "custom",
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

local function listOption(spellList, spellTypes)
	local args = {}
	local n = 0
	for id, body in pairs(spellList) do
		for _, spellType in pairs(spellTypes) do
			if spellType == body["type"] then
				n = n + 1
				rawset (args, tostring(id), spellOption(n, id))
				GameTooltip:Hide()
			end
		end
	end
	return args
end

local function MakeGroupOption(spellTypes, groupOption)
	return {
		type = 'group',
		inline = true,
		name = groupOption["name"],
		order = groupOption["order"],
		args = listOption(GSA.spellList[groupOption["kind"]], spellTypes),
	}
end

local function MakeGroupsSpells(aName)
	return {
		type = 'group',
		name = aName
	}
end

function GSA:MakeCustomOption(key)
	local options = self.options.args.custom.args
	local db = gsadb.custom
	options[key] = {
		type = 'group',
		name = function() return db[key].name end,
		set = function(info, value) local name = info[#info] db[key][name] = value end,
		get = function(info) local name = info[#info] return db[key][name] end,
		order = db[key].order,
		args = {
			name = {
				name = L["name"],
				type = 'input',
				set = function(info, value)
					if db[value] then GSA.log(L["same name already exists"]) return end
					db[value] = db[key]
					db[value].name = value
					db[value].order = #db + 1
					db[value].soundfilepath = "Interface\\AddOns\\GladiatorlosSA2\\Voice_Custom\\"..value..".ogg"
					db[key] = nil
					options[value] = options[key]
					options[key] = nil
					key = value
				end,
				order = 10,
			},
			spellid = {
				name = L["spellid"],
				type = 'input',
				order = 20,
				pattern = "%d+$",
			},
			remove = {
				type = 'execute',
				order = 25,
				name = L["Remove"],
				confirm = true,
				confirmText = L["Are you sure?"],
				func = function() 
					db[key] = nil
					options[key] = nil
				end,
			},
			existingsound = {
				name = L["Use existing sound"],
				type = 'toggle',
				order = 41,
			},
			soundfilepath = {
				name = L["file path"],
				type = 'input',
				width = 'double',
				order = 26,
				disabled = function() return db[key].existingsound end,
			},
			test = {
				type = 'execute',
				order = 28,
				name = L["Test"],
				disabled = function() return db[key].existingsound end,
				func = function() PlaySoundFile(db[key].soundfilepath, "Master") end,
			},
			NewLinetest = {
					type= 'description',
					order = 29,
					name= '',
			},
			existinglist = {
				name = L["choose a sound"],
				type = 'select',
				dialogControl = 'LSM30_Sound',
				values =  LSM:HashTable("sound"),
				disabled = function() return not db[key].existingsound end,
				order = 40,
			},
			NewLine3 = {
				type= 'description',
				order = 45,
				name= '',
			},
			eventtype = {
				type = 'multiselect',
				order = 50,
				name = L["event type"],
				values = self.GSA_EVENT,
				get = function(info, k) return db[key].eventtype[k] end,
				set = function(info, k, v) db[key].eventtype[k] = v end,
			},
			sourcetypefilter = {
				type = 'select',
				order = 59,
				name = L["Source type"],
				values = self.GSA_TYPE,
			},
			desttypefilter = {
				type = 'select',
				order = 60,
				name = L["Dest type"],
				values = self.GSA_TYPE,
			},
			sourceuidfilter = {
				type = 'select',
				order = 61,
				name = L["Source unit"],
				values = self.GSA_UNIT,
			},
			sourcecustomname = {
				type= 'input',
				order = 62,
				name= L["Custom unit name"],
				disabled = function() return not (db[key].sourceuidfilter == "custom") end,
			},
			destuidfilter = {
				type = 'select',
				order = 65,
				name = L["Dest unit"],
				values = self.GSA_UNIT,
			},
			destcustomname = {
				type= 'input',
				order = 68,
				name = L["Custom unit name"],
				disabled = function() return not (db[key].destuidfilter == "custom") end,
			},
			--[[NewLine5 = {
				type = 'header',
				order = 69,
				name = "",
			},]]
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
				auraAppliedToggles = {
					type = 'group',
					name = L["Buff Applied"],
					disabled = function() return not gsadb.isAuraAppliedEnable end,
					order = 1,
					args = {
						--generalaura = MakeGroupOption({"buff", "debuff"}, groups_options["general"]),
						DRUID       = MakeGroupOption({"buff", "debuff"}, groups_options["DRUID"]),
						HUNTER      = MakeGroupOption({"buff", "debuff"}, groups_options["HUNTER"]),
						MAGE        = MakeGroupOption({"buff", "debuff"}, groups_options["MAGE"]),
						PALADIN     = MakeGroupOption({"buff", "debuff"}, groups_options["PALADIN"]),
						PRIEST	    = MakeGroupOption({"buff", "debuff"}, groups_options["PRIEST"]),
						ROGUE       = MakeGroupOption({"buff", "debuff"}, groups_options["ROGUE"]),
						SHAMAN	    = MakeGroupOption({"buff", "debuff"}, groups_options["SHAMAN"]),
						WARLOCK	    = MakeGroupOption({"buff", "debuff"}, groups_options["WARLOCK"]),
						WARRIOR	    = MakeGroupOption({"buff", "debuff"}, groups_options["WARRIOR"]),
						DEATHKNIGHT	= MakeGroupOption({"buff", "debuff"}, groups_options["DEATHKNIGHT"]),
					},
				},
				auraDownToggles = {
						type = 'group',
						name = L["Buff Down"],
						disabled = function() return not gsadb.isAuraDownEnable end,
						order = 2,
						args = {
							--generalauradown = MakeGroupOption({"buff"}, groups_options["general"]),
							DRUID       = MakeGroupOption({"buff"}, groups_options["DRUID"]),
							HUNTER      = MakeGroupOption({"buff"}, groups_options["HUNTER"]),
							MAGE        = MakeGroupOption({"buff"}, groups_options["MAGE"]),
							PALADIN     = MakeGroupOption({"buff"}, groups_options["PALADIN"]),
							PRIEST	    = MakeGroupOption({"buff"}, groups_options["PRIEST"]),
							ROGUE       = MakeGroupOption({"buff"}, groups_options["ROGUE"]),
							SHAMAN	    = MakeGroupOption({"buff"}, groups_options["SHAMAN"]),
							WARLOCK     = MakeGroupOption({"buff"}, groups_options["WARLOCK"]),
							WARRIOR	    = MakeGroupOption({"buff"}, groups_options["WARRIOR"]),
							DEATHKNIGHT = MakeGroupOption({"buff"}, groups_options["DEATHKNIGHT"]),
							--racials =         MakeGroupOption({"buff"}, groups_options["races"]),
						},
					},
					castStartToggles = {
						type = 'group',
						name = L["Spell Cast"],
						disabled = function() return not gsadb.isCastStartEnable end,
						order = 2,
						args = {
							DRUID       = MakeGroupOption({"cast", "success", "pet"}, groups_options["DRUID"]),
							HUNTER      = MakeGroupOption({"cast", "success", "pet"}, groups_options["HUNTER"]),
							MAGE        = MakeGroupOption({"cast", "success", "pet"}, groups_options["MAGE"]),
							PALADIN     = MakeGroupOption({"cast", "success", "pet"}, groups_options["PALADIN"]),
							PRIEST	    = MakeGroupOption({"cast", "success", "pet"}, groups_options["PRIEST"]),
							ROGUE       = MakeGroupOption({"cast", "success", "pet"}, groups_options["ROGUE"]),
							SHAMAN	    = MakeGroupOption({"cast", "success", "pet"}, groups_options["SHAMAN"]),
							WARLOCK     = MakeGroupOption({"cast", "success", "pet"}, groups_options["WARLOCK"]),
							WARRIOR	    = MakeGroupOption({"cast", "success", "pet"}, groups_options["WARRIOR"]),
							DEATHKNIGHT = MakeGroupOption({"cast", "success", "pet"}, groups_options["DEATHKNIGHT"]),
						},
					},
					castSuccessToggles = {
						type = 'group',
						name = L["Special Abilities"],
						disabled = function() return not gsadb.isCastSuccessEnable end,
						order = 3,
						args = {
							DRUID       = MakeGroupOption({"success"}, groups_options["DRUID"]),
							HUNTER      = MakeGroupOption({"success"}, groups_options["HUNTER"]),
							MAGE        = MakeGroupOption({"success"}, groups_options["MAGE"]),
							PRIEST	    = MakeGroupOption({"success"}, groups_options["PRIEST"]),
							SHAMAN	    = MakeGroupOption({"success"}, groups_options["SHAMAN"]),
							WARLOCK     = MakeGroupOption({"success"}, groups_options["WARLOCK"]),
							WARRIOR	    = MakeGroupOption({"success"}, groups_options["WARRIOR"]),
							DEATHKNIGHT = MakeGroupOption({"success"}, groups_options["DEATHKNIGHT"]),
							--racials = MakeGroupOption("castSuccess", groups_options["races"]),
						}
					}
				},
			},
			custom = {
				type = 'group',
				name = L["Custom"],
				desc = L["Custom Spell"],
				--set = function(info, value) local name = info[#info] gsadb.custom[name] = value end,
				--get = function(info) local name = info[#info]	return gsadb.custom[name] end,
				order = 4,
				args = {
					newalert = {
						type = 'execute',
						name = L["New Sound Alert"],
						order = -1,
						--[[args = {
							newname = {
								type = 'input',
								name = "name",
								set = function(info, value) local name = info[#info] if gsadb.custom[vlaue] then log("name already exists") return end gsadb.custom[vlaue]={} end,			
							}]]
						func = function()
							gsadb.custom[L["New Sound Alert"]] = {
								name = L["New Sound Alert"],
								soundfilepath = "Interface\\AddOns\\GladiatorlosSA2\\Voice_Custom\\Will-Demo.ogg",--"..L["New Sound Alert"]..".ogg",
								sourceuidfilter = "any",
								destuidfilter = "any",
								eventtype = {
									SPELL_CAST_SUCCESS = true,
									SPELL_CAST_START = false,
									SPELL_AURA_APPLIED = false,
									SPELL_AURA_REMOVED = false,
									SPELL_INTERRUPT = false,
								},
								sourcetypefilter = COMBATLOG_FILTER_EVERYTHING,
								desttypefilter = COMBATLOG_FILTER_EVERYTHING,
								order = 0,
							}
							self:MakeCustomOption(L["New Sound Alert"])
						end,
						disabled = function()
							if gsadb.custom[L["New Sound Alert"]] then
								return true
							else
								return false
							end
						end,
					}
				}
			}
		}
	}

	for k, v in pairs(gsadb.custom) do
		self:MakeCustomOption(k)
	end	
	AceConfig:RegisterOptionsTable("GladiatorlosSA", self.options)
	self:AddOption(L["General"], "general")
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1)
	self.options.args.profiles.order = -1
	
	self:AddOption(L["Abilities"], "spells")
	self:AddOption(L["Custom"], "custom")
	self:AddOption(L["Profiles"], "profiles")
end