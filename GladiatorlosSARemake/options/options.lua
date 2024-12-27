local GSA = GladiatorlosSA
local gsadb
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

function GSA:OnOptionCreate()
	gsadb = self.db1.profile
	self.options = {
		type = "group",
		name = GetAddOnMetadata("GladiatorlosSA", "Title"),
		set = function(info, value)
			local name = info[#info]
			gsadb[name] = value
			GSA:CheckZoneSoundAlertEnabled()
		end,
		get = function(info)
			local name = info[#info]
			return gsadb[name]
		end,
		args = {
			general = GSA:CreateGeneralOption(),
			spells  = GSA:CreateSpellsOption()
		}
	}

	AceConfig:RegisterOptionsTable("GladiatorlosSA", self.options)
	self:AddOption(L["General"], "general")
	self.options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db1)
	self.options.args.profiles.order = -1
	
	self:AddOption(L["Abilities"], "spells")
	self:AddOption(L["Profiles"], "profiles")
end

function GSA:AddOption(name, keyName)
	return AceConfigDialog:AddToBlizOptions("GladiatorlosSA", name, "GladiatorlosSA", keyName)
end

function GSA:ChangeProfile()
	gsadb = self.db1.profile
	for k,v in GladiatorlosSA:IterateModules() do
		if type(v.ChangeProfile) == 'function' then
			v:ChangeProfile()
		end
	end
end