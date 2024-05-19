local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local options_created = false -- ***** @

local GSA_OUTPUT = {["MASTER"] = L["Master"],["SFX"] = L["SFX"],["AMBIENCE"] = L["Ambience"],["MUSIC"] = L["Music"],["DIALOG"] = L["Dialog"]}

local groups_options = {
	general = { name = L["General Abilities"],        kind = "general", order = 30  },
	druid =   { name = L["|cffFF7D0ADruid|r"],        kind = "druid",   order = 70  },
	hunter =  { name = L["|cffABD473Hunter|r"],       kind = "hunter",  order = 80  },
	mage =    { name = L["|cff69CCF0Mage|r"],         kind = "mage",    order = 90  },
	paladin = { name = L["|cffF58CBAPaladin|r"],      kind = "paladin", order = 100 },
	priest =  { name = L["|cffFFFFFFPriest|r"],       kind = "priest",  order = 110 },
	rogue =   { name = L["|cffFFF569Rogue|r"],        kind = "rogue",   order = 120 },
	shaman =  { name = L["|cff0070daShaman|r"],       kind = "shaman",  order = 130 },
	warlock = { name = L["|cff9482C9Warlock|r"],      kind = "warlock", order = 140 },
	warrior = { name = L["|cffC79C6EWarrior|r"],      kind = "warrior", order = 150 },
	dk =      { name = L["|cffC41F3BDeath Knight|r"], kind = "dk",      order = 160 },
	races =   { name = L["Racials"],                  kind = "races",   order = 170 },
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

local function setOption(info, value)
	local name = info[#info]
	gsadb[name] = value
	if value then
		GSA:PlaySound(name)
	end
	GSA:CanTalkHere()
end

local function getOption(info)
	local name = info[#info]
	return gsadb[name]
end

local function spellOption(order, spellID, ...)
	local spellname, _, icon = GetSpellInfo(spellID)	
	if (spellname ~= nil) then
		return {
			type = 'toggle',
			name = "\124T" .. icon .. ":24\124t" .. spellname,			
			desc = function ()
				GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
				GameTooltip:SetHyperlink(GetSpellLink(spellID))
				--GameTooltip:SetSpellByID(spellID)
				GameTooltip:Show()
				--print(GetSpellInfo((spellID)))
			end, -- https://i.imgur.com/ChzUb.jpg
			-- why are you reading this disaster, go away this is embarrassing
			descStyle = "custom",
					order = order,
		}
	else
		GSA.log("spell id: " .. spellID .. " is invalid")
		return {
			type = 'toggle',
			name = "Unknown Spell; ID:" .. spellID,	
			order = order,
		}
	end
end

local function listOption(spellList, ...)
	local args = {}
	local n = 0
	for id, name in pairs(spellList) do
		n = n + 1
		rawset (args, name, spellOption(n, id))
		GameTooltip:Hide()
	end
	return args
end

local function MakeGroupOption(category_name, group_option)
	return {
		type = 'group',
		inline = true,
		name = group_option["name"],
		order = group_option["order"],					      		
		args = listOption(GSA.spellList[category_name][group_option["kind"]]),
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
							--onlyflagged = {
							--	type = 'toggle',
							--	name = L["OnlyIfPvPFlagged"],
							--	desc = L["OnlyIfPvPFlaggedDesc"],
							--	disabled = function() return not gsadb.field or gsadb.all end,
							--	order = 20,
							--},
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
							},
						},
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
								order = 1,
							},
						},
				},
				spellGeneral = {
						type = 'group',
						name = L["Disable options"],
						desc = L["Disable abilities by type"],
						inline = true,
						order = -2,
						args = {
							aruaApplied = {
								type = 'toggle',
								name = L["Disable Buff Applied"],
								desc = L["Check this will disable alert for buff applied to hostile targets"],
								order = 1,
							},
							aruaRemoved = {
								type = 'toggle',
								name = L["Disable Buff Down"],
								desc = L["Check this will disable alert for buff removed from hostile targets"],
								order = 2,
							},
							castStart = {
								type = 'toggle',
								name = L["Disable Spell Casting"],
								desc = L["Chech this will disable alert for spell being casted to friendly targets"],
								order = 3,
							},
							castSuccess = {
								type = 'toggle',
								name = L["Disable special abilities"],
								desc = L["Check this will disable alert for instant-cast important abilities"],
								order = 4,
							},
							interrupt = {
								type = 'toggle',
								name = L["Disable friendly interrupt"],
								desc = L["Check this will disable alert for successfully-landed friendly interrupting abilities"],
								order = 6,
							},
							interruptedfriendly = {
								type = 'toggle',
								name = L["FriendlyInterrupted"],
								desc = L["FriendlyInterruptedDesc"],
								order = 7,
							},
						},
					},
					spellAuraApplied = {
						type = 'group',
						--inline = true,
						name = L["Buff Applied"],
						disabled = function() return gsadb.aruaApplied end,
						order = 1,
						args = {
							aonlyTF = {	-- AuraApplied
								type = 'toggle',
								name = L["Target and Focus Only"],
								desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
								order = 10,
							},
							drinking = { -- AuraApplied 
								type = 'toggle',
								name = L["Alert Drinking"],
								desc = L["In arena, alert when enemy is drinking"],
								order = 20,
							},
							-- MakeGroupOption("auraApplied", groups_options["general"])
							generalaura = MakeGroupOption("auraApplied", groups_options["general"]),
							druid =       MakeGroupOption("auraApplied", groups_options["druid"]),
							hunter =      MakeGroupOption("auraApplied", groups_options["hunter"]),
							mage =        MakeGroupOption("auraApplied", groups_options["mage"]),
							paladin =     MakeGroupOption("auraApplied", groups_options["paladin"]),
							priest	=     MakeGroupOption("auraApplied", groups_options["priest"]),
							rogue =       MakeGroupOption("auraApplied", groups_options["rogue"]),
							shaman	=     MakeGroupOption("auraApplied", groups_options["shaman"]),
							warlock	=     MakeGroupOption("auraApplied", groups_options["warlock"]),
							warrior	=     MakeGroupOption("auraApplied", groups_options["warrior"]),
							dk	=         MakeGroupOption("auraApplied", groups_options["dk"]),
						},
					},
					spellAuraRemoved = {
						type = 'group',
						--inline = true,
						name = L["Buff Down"],
						disabled = function() return gsadb.aruaRemoved end,
						order = 2,
						args = {
							ronlyTF = { -- AuraRemoved
								type = 'toggle',
								name = L["Target and Focus Only"],
								desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
								order = 10,
							},
							generalauradown = MakeGroupOption("auraRemoved", groups_options["general"]),
							druid =           MakeGroupOption("auraRemoved", groups_options["druid"]),
							hunter =          MakeGroupOption("auraRemoved", groups_options["hunter"]),
							mage =            MakeGroupOption("auraRemoved", groups_options["mage"]),
							paladin =         MakeGroupOption("auraRemoved", groups_options["paladin"]),
							priest	=         MakeGroupOption("auraRemoved", groups_options["priest"]),
							rogue =           MakeGroupOption("auraRemoved", groups_options["rogue"]),
							shaman	=         MakeGroupOption("auraRemoved", groups_options["shaman"]),
							warlock =         MakeGroupOption("auraRemoved", groups_options["warlock"]),
							warrior	=         MakeGroupOption("auraRemoved", groups_options["warrior"]),
							dk =              MakeGroupOption("auraRemoved", groups_options["dk"]),
							racials =         MakeGroupOption("auraRemoved", groups_options["races"]),
						},
					},
					spellCastStart = {
						type = 'group',
						--inline = true,
						name = L["Spell Casting"],
						disabled = function() return gsadb.castStart end,
						order = 2,
						args = {
							conlyTF = { -- CastStart
								type = 'toggle',
								name = L["Target and Focus Only"],
								desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
								order = 1,
							},
							resurrection = { -- CastStart
								type = 'toggle',
								name = L["Resurrection"],
								desc = L["Resurrection_Desc"],
								order = 20,
							},
--[[							bigHeal = { -- CastStart
								type = 'toggle',
								name = L["BigHeal"],
								desc = L["BigHeal_Desc"],
								order = 30,
							},]]
							druid =   MakeGroupOption("castStart", groups_options["druid"]),
							hunter =  MakeGroupOption("castStart", groups_options["hunter"]),
							mage =    MakeGroupOption("castStart", groups_options["mage"]),
							paladin = MakeGroupOption("castStart", groups_options["paladin"]),
							priest	= MakeGroupOption("castStart", groups_options["priest"]),
							rogue =   MakeGroupOption("castStart", groups_options["rogue"]),
							shaman	= MakeGroupOption("castStart", groups_options["shaman"]),
							warlock = MakeGroupOption("castStart", groups_options["warlock"]),
							warrior	= MakeGroupOption("castStart", groups_options["warrior"]),
						},
					},
					spellCastSuccess = {
						type = 'group',
						--inline = true,
						name = L["Special Abilities"],
						disabled = function() return gsadb.castSuccess end,
						order = 3,
						args = {
							sonlyTF = { -- CastSuccess
								type = 'toggle',
								name = L["Target and Focus Only"],
								desc = L["Alert works only when your current target or focus gains the buff effect or use the ability"],
								order = 10,
							},
							class = { -- CastSuccess
								type = 'toggle',
								name = L["PvP Trinketed Class"],
								desc = L["Also announce class name with trinket alert when hostile targets use PvP trinket in arena"],
								--disabled = function() return not gsadb.trinket end,
								order = 13,
							},
							success = { -- CastSuccess
								type = 'toggle',
								name = L["CastingSuccess"],
								desc = L["CastingSuccess_Desc"],
								--disabled = function() return gsadb.castStart end,
								order = 15,
							},
							connected = { -- CastSuccess
								type = 'toggle',
								name = L["Connected"],
								desc = L["Connected_Desc"],
								--disabled = function() return gsadb.castStart end,
								order = 17,
							},
--[[							cure = { -- CastSuccess
								type = 'toggle',
								name = L["DPSDispel"],
								desc = L["DPSDispel_Desc"],
								order = 20,
							},]]
--[[							dispel = { -- CastSuccess
								type = 'toggle',
								name = L["HealerDispel"],
								desc = L["HealerDispel_Desc"],
								order = 24,
							},]]
--[[							purge = { -- CastSuccess
								type = 'toggle',
								name = L["Purge"],
								desc = L["PurgeDesc"],
								order = 26,
							},]]
--[[							general = { -- CastSuccess
								type = 'group',
								inline = true,
								name = L["General Abilities"],
								order = 30,
								args = listOption({},"castSuccess"),
							},]]
--[[							enemyInterrupts = { -- CastSuccess
								type = 'group',
								inline = true,
								name = L["EnemyInterrupts"],
								order = 35,
								args = listOption({},"castSuccess"),
							},]]
							druid =   MakeGroupOption("castSuccess", groups_options["druid"]),
							hunter =  MakeGroupOption("castSuccess", groups_options["hunter"]),
							mage =    MakeGroupOption("castSuccess", groups_options["mage"]),
							paladin = MakeGroupOption("castSuccess", groups_options["paladin"]),
							priest	= MakeGroupOption("castSuccess", groups_options["priest"]),
							rogue =   MakeGroupOption("castSuccess", groups_options["rogue"]),
							shaman	= MakeGroupOption("castSuccess", groups_options["shaman"]),
							warlock = MakeGroupOption("castSuccess", groups_options["warlock"]),
							warrior	= MakeGroupOption("castSuccess", groups_options["warrior"]),
							dk =      MakeGroupOption("castSuccess", groups_options["dk"]),
							racials = MakeGroupOption("castSuccess", groups_options["races"]),
						},
					},
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