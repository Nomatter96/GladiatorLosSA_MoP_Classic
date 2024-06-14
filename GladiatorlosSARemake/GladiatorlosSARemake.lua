GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
local LSM = LibStub("LibSharedMedia-3.0")
local self, GSA, PlaySoundFile = GladiatorlosSA, GladiatorlosSA, PlaySoundFile
local GSA_TEXT = "|cff69CCF0GladiatorlosSA2|r (|cffFFF569/gsa|r)"
local GSA_TEST_BRANCH = ""
local GSA_AUTHOR = " "
local gsadb
local soundz,sourcetype,sourceuid,desttype,destuid = {},{},{},{},{}
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
    ["GladiatorlosSA2\\Voice_enUS"] = L["English(female)"],
}
self.GSA_LANGUAGE = GSA_LANGUAGE

local GSA_EVENT = {
    SPELL_CAST_SUCCESS = L["Spell_CastSuccess"],
    SPELL_CAST_START   = L["Spell_CastStart"],
    SPELL_AURA_APPLIED = L["Spell_AuraApplied"],
    SPELL_AURA_REMOVED = L["Spell_AuraRemoved"],
    SPELL_INTERRUPT    = L["Spell_Interrupt"],
    SPELL_SUMMON       = L["Spell_Summon"],
    --UNIT_AURA = "Unit aura changed",
}
self.GSA_EVENT = GSA_EVENT

local GSA_UNIT = {
    any       = L["Any"],
    player    = L["Player"],
    target    = L["Target"],
    focus     = L["Focus"],
    mouseover = L["Mouseover"],
    custom    = L["Custom"], 
}
self.GSA_UNIT = GSA_UNIT

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
        isInterruptEnable = true,

        auraAppliedToggles = {},
        auraDownToggles = {},
        castStartToggles = {},
        castSuccessToggles = {},

        onlyTargetFocus = false,
        drinking = false,
        pvpTrinket = false,
        interruptedfriendly = true,
        
        custom = {},
    }    
}

 GSA.log = function(msg) DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF22GladiatorlosSA|r: "..msg) end

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
            elseif body["type"] == "success" then
                if dbDefaults.profile["castStartToggles"][id] == nil then
                    dbDefaults.profile["castStartToggles"][id] = true
                end
                if dbDefaults.profile["castSuccessToggles"][id] == nil then
                    dbDefaults.profile["castSuccessToggles"][id] = true
                end
            else
                if dbDefaults.profile["castStartToggles"][id] == nil then
                    dbDefaults.profile["castStartToggles"][id] = true
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

function GladiatorlosSA:OnInitialize()
    InitializeDBSpellList()
    self:InitializeOptionTable()
    self:RegisterChatCommand("gsa", "ShowConfig")
    LSM.RegisterCallback(LSM_GSA_SOUNDFILES, "LibSharedMedia_Registered", LSMRegistered)
    DEFAULT_CHAT_FRAME:AddMessage(GSA_TEXT .. L["GSA_VERSION"] .. GSA_AUTHOR .." "..GSA_TEST_BRANCH);
 end

 function GladiatorlosSA:OnEnable()
    GladiatorlosSA:RegisterEvent("PLAYER_ENTERING_WORLD")
    GladiatorlosSA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    GladiatorlosSA:RegisterEvent("UNIT_AURA")
    if not GSA_LANGUAGE[gsadb.path] then gsadb.path = GSA_LOCALEPATH[GetLocale()] end
    self.throttled = {}
    self.smarter = 0
 end

 function GladiatorlosSA:OnDisable()
    -- why is this here
 end

-- play sound by file name
 function GSA:PlaySound(fileName)
     PlaySoundFile("Interface\\Addons\\" ..gsadb.path.. "\\"..fileName .. ".ogg", gsadb.output_menu)
 end

 function GladiatorlosSA:PLAYER_ENTERING_WORLD()
     self:CheckCanPlaySound()
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
        gsadb.field or                                                                            -- World
        (currentZoneType == "pvp" and gsadb.battleground and not self:IsEpicBG(instanceMapID)) or -- Battleground
        (currentZoneType == "pvp" and gsadb.epicbattleground and self:IsEpicBG(instanceMapID)) or -- Epic Battleground
        (currentZoneType == "arena" and gsadb.arena)                                              -- Arena
end

 function GSA:SpammyDebug()
     -- This shouldn't be used 99.9% of the time.
     print(sourceName,sourceGUID,destName,destGUID,destFlags,"|cffFF7D0A" .. event.. "|r",spellName,"|cffFF7D0A" .. spellID.. "|r")
     print("|cffff0000timestamp|r",timestamp,"|cffff0000event|r",event,"|cffff0000hideCaster|r",hideCaster,"|cffff0000sourceGUID|r",sourceGUID,"|cffff0000sourceName|r",sourceName,"|cffff0000sourceFlags|r",sourceFlags,"|cffff0000sourceFlags2|r",sourceFlags2,"|cffff0000destGUID|r",destGUID,"|cffff0000destName|r",destName,"|cffff0000destFlags|r",destFlags,"|cffff0000destFlags2|r",destFlags2,"|cffff0000spellID|r",spellID,"|cffff0000spellName|r",spellName)
 end
    

function GladiatorlosSA:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
    if (GetZonePVPInfo() == "sanctuary") or (not isCanPlaySound) then
        return
    end

    -- Area check passed, fetch combat event payload.
    local _, event, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, t = CombatLogGetCurrentEventInfo()
    
    if not GSA_EVENT[event] then return end

    if (destFlags) then
        for k in pairs(GSA_TYPE) do
            desttype[k] = CombatLog_Object_IsA(destFlags,k)
            --print("desttype:"..k.."="..(desttype[k] or "nil"))
        end
    else
        for k in pairs(GSA_TYPE) do
            desttype[k] = nil
        end
    end
    if (destGUID) then
        for k in pairs(GSA_UNIT) do
            destuid[k] = (UnitGUID(k) == destGUID)
            --print("destuid:"..k.."="..(destuid[k] and "true" or "false"))
        end
    else
        for k in pairs(GSA_UNIT) do
            destuid[k] = nil
            --print("destuid:"..k.."="..(destuid[k] and "true" or "false"))
        end
    end
    destuid.any = true
    if (sourceFlags) then
        for k in pairs(GSA_TYPE) do
            sourcetype[k] = CombatLog_Object_IsA(sourceFlags,k)
            --print("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
        end
    else
        for k in pairs(GSA_TYPE) do
            sourcetype[k] = nil
            --print("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
        end
    end
    if (sourceGUID) then
        for k in pairs(GSA_UNIT) do
            sourceuid[k] = (UnitGUID(k) == sourceGUID)
            --print("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
        end
    else
        for k in pairs(GSA_UNIT) do
            sourceuid[k] = nil
            --print("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
        end
    end
    sourceuid.any = true

    -- check isEnemy and target/focus settings
    if (sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.onlyTargetFocus or destuid.target or destuid.focus)) then
        local unitType = strsplit("-", sourceGUID)
        if unitType ~= "Player" and unitType ~= "Pet" then
            return
        end
        -- Try get class by pet or it is player
        local engClass = self:GetClassByPet(sourceGUID)
        if engClass == nil then
            _, engClass, _, _, _, _, _ = GetPlayerInfoByGUID(sourceGUID)
        end

        
        local currentSpell = nil
        -- Try find class spell
        if self.spellList[engClass][spellID] ~= nil then
            currentSpell = self.spellList[engClass][spellID]
        -- Is pvp trinket?
        elseif event == "SPELL_AURA_APPLIED" and gsadb.pvpTrinket and self:IsPvPTrinket(spellID) then
            self:PlaySpell(engClass)
            return
        -- Try find racial spell
        elseif self.spellList["RACIAL"][spellID] ~= nil then
            currentSpell = self.spellList["RACIAL"][spellID]
        -- Try find general spell
        elseif self.spellList["GENERAL"][spellID] ~= nil then
            currentSpell = self.spellList["GENERAL"][spellID]
        else
            -- nothing found then quit
            return
        end

        -- check event and (is spell's group enable in options) and (is spell enable in options)
        if event == "SPELL_INTERRUPT " and gsadb.isInterruptEnable and currentSpell["type"] == "kick" then
            self:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_AURA_APPLIED" and gsadb.isAuraAppliedEnable and gsadb["auraAppliedToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_AURA_REMOVED" and gsadb.isAuraDownEnable and gsadb["auraDownToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"] .. "Down")
        elseif event == "SPELL_CAST_START" and gsadb.isCastStartEnable and gsadb["castStartToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_CAST_SUCCESS" and gsadb.isCastSuccessEnable and gsadb["castSuccessToggles"][spellID] then
            if self:Throttle(tostring(spellID).."default", 0.05) then return end
            self:PlaySpell("success")
        end
    elseif ((desttype[COMBATLOG_FILTER_FRIENDLY_UNITS] and IsGUIDInGroup(destGUID)) or (destGUID == UnitGUID("player"))) then
        -- get current spell
        local currentSpell = self:FindSpellByID(spellID)
        if currentSpell == nil then 
            return
        end

        if event == "SPELL_AURA_APPLIED" and currentSpell["type"] == "debuff" and gsadb.isAuraAppliedEnable and gsadb["auraAppliedToggles"][spellID] then
            self:PlaySpell(currentSpell["soundName"])
        end
    else
        -- play custom spells
        for k, css in pairs (gsadb.custom) do
            if css.destuidfilter == "custom" and destName == css.destcustomname then
                destuid.custom = true
            else
                destuid.custom = false
            end
            if css.sourceuidfilter == "custom" and sourceName == css.sourcecustomname then
                sourceuid.custom = true
            else
                sourceuid.custom = false
            end

            if css.eventtype[event] and destuid[css.destuidfilter] and desttype[css.desttypefilter] and sourceuid[css.sourceuidfilter] and sourcetype[css.sourcetypefilter] and spellID == tonumber(css.spellid) then
                if self:Throttle(tostring(spellID)..css.name, 0.1) then return end
                --PlaySoundFile(css.soundfilepath, "Master")

                if css.existingsound then -- Added to 2.3.3
                    if (css.existinglist ~= nil and css.existinglist ~= ('')) then
                        local soundz = LSM:Fetch('sound', css.existinglist)
                        PlaySoundFile(soundz, gsadb.output_menu)
                    else
                        GSA.log (L["No sound selected for the Custom alert : |cffC41F4B"] .. css.name .. "|r.")
                    end
                else
                    PlaySoundFile(css.soundfilepath, gsadb.output_menu)
                end
            end
        end
    end
end

-- play drinking in arena
function GladiatorlosSA:UNIT_AURA(event,uid)
    local _,currentZoneType = IsInInstance()

    --if gsadb.drinking then--if uid:find("arena") and gsadb.drinking then 
    if UnitIsEnemy("player", uid) and gsadb.drinking then
        if (AuraUtil.FindAuraByName("Drinking",uid) or AuraUtil.FindAuraByName("Food",uid) or AuraUtil.FindAuraByName("Refreshment",uid) or AuraUtil.FindAuraByName("Drink",uid)) and currentZoneType == "arena" then
            if self:Throttle(tostring(104270) .. uid, 4) then return end
        self:PlaySound("drinking")
        end
    end
    --end
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