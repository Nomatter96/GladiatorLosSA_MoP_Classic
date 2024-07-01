GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local self, GSA, PlaySoundFile = GladiatorlosSA, GladiatorlosSA, PlaySoundFile
local GSA_TEXT = "|cff69CCF0GladiatorlosSARemake|r (|cffFFF569/gsa|r)"
local GSA_AUTHOR = " "
local gsadb
local soundz = {}
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local isCanPlaySound = false
local debugMode = 0
local opponentName = ""

local LSM_GSA_SOUNDFILES = {
    ["GSA-Demo"] = "Interface\\AddOns\\GladiatorlosSARemake\\Voice_Custom\\Will-Demo.ogg",
}

local GSA_LOCALEPATH = {
    enUS = "GladiatorlosSARemake\\Voice_enUS",
}
self.GSA_LOCALEPATH = GSA_LOCALEPATH

local GSA_LANGUAGE = {
    ["GladiatorlosSARemake\\Voice_enUS"] = L["English(female)"],
}
self.GSA_LANGUAGE = GSA_LANGUAGE

local GSA_EVENT = {
    SPELL_CAST_SUCCESS = L["Spell_CastSuccess"],
    SPELL_CAST_START   = L["Spell_CastStart"],
    SPELL_AURA_APPLIED = L["Spell_AuraApplied"],
    SPELL_AURA_REMOVED = L["Spell_AuraRemoved"],
    SPELL_INTERRUPT    = L["Spell_Interrupt"],
    SPELL_SUMMON       = L["Spell_Summon"],
    SPELL_MISSED       = L["SPELL_MISSED"]
}
self.GSA_EVENT = GSA_EVENT

local GSA_TYPE = {
    [COMBATLOG_FILTER_EVERYTHING]      = L["Any"],
    [COMBATLOG_FILTER_FRIENDLY_UNITS]  = L["Friendly"],
    [COMBATLOG_FILTER_HOSTILE_PLAYERS] = L["Hostile player"],
    [COMBATLOG_FILTER_HOSTILE_UNITS]   = L["Hostile unit"],
    [COMBATLOG_FILTER_NEUTRAL_UNITS]   = L["Neutral"],
    [COMBATLOG_FILTER_ME]              = L["Myself"],
    [COMBATLOG_FILTER_MINE]            = L["Mine"],
    [COMBATLOG_FILTER_MY_PET]          = L["My pet"],
    [COMBATLOG_FILTER_UNKNOWN_UNITS]   = "Unknown unit",
}
self.GSA_TYPE = GSA_TYPE

local dbDefaults = {
    profile = {
        all = false,
        arena = true,
        battleground = true,
        epicbattleground = false,
        field = false,
        path = GSA_LOCALEPATH[GetLocale()] or "GladiatorlosSARemake\\Voice_enUS",
        path_menu = GSA_LOCALEPATH[GetLocale()] or "GladiatorlosSARemake\\Voice_enUS",
        throttle = 0,
        smartDisable = false,
        outputUnlock = false,
        output_menu = "MASTER",
        
        isAuraAppliedEnable = true,
        isAuraDownEnable = true,
        isCastStartEnable = true,
        isCastSuccessEnable = true,

        auraAppliedToggles = {},
        auraDownToggles = {},
        castStartToggles = {},
        castSuccessToggles = {},

        onlyTargetFocus = false,
        drinking = false,
        pvpTrinket = false,
        IsEnemyUseInterruptEnable = true,
        IsFriendUseInterruptSuccessEnable = true,
        IsSoundSuccessCastEnable = true,
        IsEnemyReflectedEnable = true,
        IsFriendReflectedEnable = true
    }    
}

local waitTable = {};
local waitFrame = nil;
function GladiatorlosSA_wait(delay, func, ...)
  if(type(delay)~="number" or type(func)~="function") then
    return false;
  end
  if(waitFrame == nil) then
    waitFrame = CreateFrame("Frame","WaitFrame", UIParent);
    waitFrame:SetScript("onUpdate",function (self,elapse)
      local count = #waitTable;
      local i = 1;
      while(i<=count) do
        local waitRecord = tremove(waitTable,i);
        local d = tremove(waitRecord,1);
        local f = tremove(waitRecord,1);
        local p = tremove(waitRecord,1);
        if(d>elapse) then
          tinsert(waitTable,i,{d-elapse,f,p});
          i = i + 1;
        else
          count = count - 1;
          f(unpack(p));
        end
      end
    end);
  end
  tinsert(waitTable,{delay,func,{...}});
  return true;
end

 -- LSM BEGIN / inspired from MSBTMedia.lua
local function RegisterSound(soundName, soundPath)
    if (type(soundName) ~= "string" or type(soundPath) ~= "string") then return end
    if (soundName == "" or soundPath == "") then return end

    soundz[soundName] = soundPath
    LSM:Register("sound", soundName, soundPath)
end

for soundName, soundPath in pairs(LSM_GSA_SOUNDFILES) do RegisterSound(soundName, soundPath) end
for index, soundName in pairs(LSM:List("sound")) do soundz[soundName] = LSM:Fetch("sound", soundName) end

local function LSMRegistered(event, mediaType, name)
   if (mediaType == "sound") then
       soundz[name] = LSM:Fetch(mediaType, name)
   end
end
 -- LSM END

local function InitializeDBSpellList()
    if not self.spellList then
        self.spellList = self:GetSpellList()
    end
    for _,kind in pairs(self.spellList) do
        for id,body in pairs(kind) do
            -- Calling that for initialize spell description. First calling get empty desc, then it's work fine. Why? Idk, need ask blizzard wtf with their API
            GetSpellDescription(id)

            if body["type"] == "buff" then
                if dbDefaults.profile["auraAppliedToggles"][id] == nil then
                    dbDefaults.profile["auraAppliedToggles"][id] = true
                end
                if dbDefaults.profile["auraDownToggles"][id] == nil then
                    dbDefaults.profile["auraDownToggles"][id] = true
                end
            elseif body["type"] == "debuff" then
                if dbDefaults.profile["auraAppliedToggles"][id] == nil then
                    dbDefaults.profile["auraAppliedToggles"][id] = true
                end
            elseif body["type"] == "cast" then
                if dbDefaults.profile["castStartToggles"][id] == nil then
                    dbDefaults.profile["castStartToggles"][id] = true
                end
            else
                if dbDefaults.profile["castSuccessToggles"][id] == nil then
                    dbDefaults.profile["castSuccessToggles"][id] = true
                end
            end
        end
    end

    self.db1 = LibStub("AceDB-3.0"):New("GladiatorlosSADB",dbDefaults, "Default");
    self.db1.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
    self.db1.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
    self.db1.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
    gsadb = self.db1.profile
end

function GladiatorlosSA:log(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF22GladiatorlosSA|r: "..msg)
end

function GladiatorlosSA:OnInitialize()
    InitializeDBSpellList()
    self:InitializeOptionTable()
    self:RegisterChatCommand("gsa", "ShowConfig")
    LSM.RegisterCallback(LSM_GSA_SOUNDFILES, "LibSharedMedia_Registered", LSMRegistered)
    DEFAULT_CHAT_FRAME:AddMessage(GSA_TEXT .. L["GSA_VERSION"] .. GSA_AUTHOR);
end

function GladiatorlosSA:OnEnable()
    GladiatorlosSA:RegisterEvent("PLAYER_ENTERING_WORLD")
    GladiatorlosSA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    GladiatorlosSA:RegisterEvent("UNIT_AURA")
    if not GSA_LANGUAGE[gsadb.path] then gsadb.path = GSA_LOCALEPATH[GetLocale()] end
    self.throttled = {}
    self.smarter = 0
end

function GladiatorlosSA:PLAYER_ENTERING_WORLD()
    self:CheckCanPlaySound()
end

-- play sound by file name
function GSA:PlaySound(fileName)
    PlaySoundFile("Interface\\Addons\\" ..gsadb.path.. "\\"..fileName .. ".mp3", gsadb.output_menu)
end

function GladiatorlosSA:PlaySpell(spellName)
    if gsadb.throttle ~= 0 and self:Throttle("playspell",gsadb.throttle) then
        return
    end
    if gsadb.smartDisable then
        if (GetNumGroupMembers() or 0) > 20 then return end
        if self:Throttle("smarter",20) then
            self.smarter = self.smarter + 1
            if self.smarter > 30 then return end
        else 
            self.smarter = 0
        end
    end

    self:PlaySound(spellName)
end

function GSA:CheckCanPlaySound()
    local _,currentZoneType = IsInInstance()
    local _,_,_,_,_,_,_,instanceMapID = GetInstanceInfo()

    isCanPlaySound = gsadb.all or                                                                 -- Anywhere
        (currentZoneType == "none" and gsadb.field) or                                            -- World
        (currentZoneType == "pvp" and gsadb.battleground and not self:IsEpicBG(instanceMapID)) or -- Battleground
        (currentZoneType == "pvp" and gsadb.epicbattleground and self:IsEpicBG(instanceMapID)) or -- Epic Battleground
        (currentZoneType == "arena" and gsadb.arena)                                              -- Arena
end

local enemyFilter = bit.bor(COMBATLOG_FILTER_HOSTILE_PLAYERS, COMBATLOG_FILTER_HOSTILE_UNITS)
local friendFilter = bit.bor(COMBATLOG_FILTER_FRIENDLY_UNITS, COMBATLOG_FILTER_ME, COMBATLOG_FILTER_MY_PET)

function GladiatorlosSA:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
    if (GetZonePVPInfo() == "sanctuary") or (not isCanPlaySound) then
        return
    end

    -- Area check passed, fetch combat event payload.
    local _, event, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, typeParam = CombatLogGetCurrentEventInfo()

    if not GSA_EVENT[event] then return end

    -- if only target or focus then check
    if gsadb.onlyTargetFocus then
        local isTarget = UnitGUID("target") == destGUID or UnitGUID("target") == sourceGUID
        local isFocus = UnitGUID("focus") == destGUID or UnitGUID("focus") == sourceGUID
        if not isTarget and not isFocus then
            return
        end
    end

    -- Before spells check
    if CombatLog_Object_IsA(sourceFlags, enemyFilter) then
        --  check is PvPTrinket
        if event == "SPELL_AURA_APPLIED" and gsadb.pvpTrinket and self:IsPvPTrinket(spellID) then
            _, engClass, _, _, _, _, _ = GetPlayerInfoByGUID(sourceGUID)
            self:PlaySpell(engClass)
            return
        --  check is Reflected
        elseif event == "SPELL_MISSED" and typeParam == "REFLECT" and gsadb.IsFriendReflectedEnable then
            self:PlaySpell("reflected")
            return
        end
    elseif CombatLog_Object_IsA(sourceFlags, friendFilter) then
        --  check is Reflected
        if event == "SPELL_MISSED" and typeParam == "REFLECT" and gsadb.IsEnemyReflectedEnable then
            self:PlaySpell("enemyReflected")
            return
        end
    end

    -- get current spell
    local currentSpell = self:FindSpellByID(spellID)
    if currentSpell == nil then 
        return
    end

    -- check Source is Enemy
    if CombatLog_Object_IsA(sourceFlags, enemyFilter) then
        -- check event and (is spell's group enable in options) and (is spell enable in options)
        -- Check kick
        if event == "SPELL_CAST_SUCCESS" and gsadb.IsEnemyUseInterruptEnable and currentSpell["type"] == "kick" then
            self:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_INTERRUPT" and gsadb.IsEnemyUseInterruptEnable and currentSpell["type"] == "kick" then
            GladiatorlosSA_wait(currentSpell["durationSound"], function() self:PlaySpell("interrupted") end)
        
        -- Check buff and debuff
        elseif event == "SPELL_AURA_APPLIED" and gsadb.isAuraAppliedEnable and gsadb["auraAppliedToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_AURA_REMOVED" and gsadb.isAuraDownEnable and gsadb["auraDownToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
            GladiatorlosSA_wait(currentSpell["durationSound"] - 0.1, function() self:PlaySound("Down") end)
        
        -- Check cast spells
        elseif (event == "SPELL_CAST_START" or event == "SPELL_CAST_SUCCESS") and gsadb.isCastStartEnable and gsadb["castStartToggles"][spellID] then
            if event == "SPELL_CAST_START" then
                self:PlaySpell(currentSpell["soundName"])
            elseif gsadb.IsSoundSuccessCastEnable then
                if self:Throttle(tostring(spellID).."default", 0.05) then return end
                self:PlaySound("success")
            end

        -- Check simple spells without cast
        elseif event == "SPELL_CAST_SUCCESS" and gsadb.isCastSuccessEnable and gsadb["castSuccessToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        end
    
    -- Check Dest is enemy
    elseif CombatLog_Object_IsA(destFlags, enemyFilter) and (IsGUIDInGroup(sourceGUID) or sourceGUID == UnitGUID("player")) then
        if event == "SPELL_INTERRUPT" and gsadb.IsFriendUseInterruptSuccessEnable and currentSpell["type"] == "kick" then
            self:PlaySpell("Lockout")
        end

    -- Check Dest is friend or myself
    elseif CombatLog_Object_IsA(destFlags, friendFilter) and IsGUIDInGroup(destGUID) or destGUID == UnitGUID("player") then
        if event == "SPELL_AURA_APPLIED" and currentSpell["type"] == "debuff" and gsadb.isAuraAppliedEnable and gsadb["auraAppliedToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        end
    end
end

local function IsDrinkingAuraByName(name)
    return string.find(name, "Drink") ~= nil or string.find(name, "Food") ~= nil or string.find(name, "Refreshment") ~= nil
end

function GladiatorlosSA:UNIT_AURA(event, unitTarget, updateInfo)
    local _,currentZoneType = IsInInstance()

    if currentZoneType ~= "arena" or not UnitIsEnemy("player", unitTarget) then
        return
    end

    if gsadb.drinking then
        for i = 1, #updateInfo.addedAuras do
            if IsDrinkingAuraByName(updateInfo.addedAuras[i].name) then
                self:PlaySound("drinking")
            end
        end
    end


end


 function GladiatorlosSA:Throttle(key,throttle)
    if (not self.throttled) then
        self.throttled = {}
    end
    -- Throttling of Playing
    if (not self.throttled[key]) then
        self.throttled[key] = GetTime()+throttle
        return false
    elseif (self.throttled[key] < GetTime()) then
        self.throttled[key] = GetTime()+throttle
        return false
    else
        return true
    end
 end