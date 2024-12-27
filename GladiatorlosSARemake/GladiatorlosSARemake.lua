GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")
local GSA = GladiatorlosSA -- just short name
local GSALocale = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Init Start
local GSA_Settings
local function InitializeDBSpellList()
    if not GSA.spellList then
        GSA.spellList = GSA:GetSpellList()
    end
    for _,kind in pairs(GSA.spellList) do
        for id,body in pairs(kind) do
            -- Calling that for initialize spell description. First calling get empty desc, then it's work fine. Why? Idk, need ask blizzard wtf with their API
            GetSpellDescription(id)

            if body["type"] == "buff" then
                if GSA.DefaultSettings.profile["auraAppliedToggles"][id] == nil then
                    GSA.DefaultSettings.profile["auraAppliedToggles"][id] = true
                end
                if GSA.DefaultSettings.profile["auraDownToggles"][id] == nil then
                    GSA.DefaultSettings.profile["auraDownToggles"][id] = true
                end
            elseif body["type"] == "debuff" then
                if GSA.DefaultSettings.profile["auraAppliedToggles"][id] == nil then
                    GSA.DefaultSettings.profile["auraAppliedToggles"][id] = true
                end
            elseif body["type"] == "cast" then
                if GSA.DefaultSettings.profile["castStartToggles"][id] == nil then
                    GSA.DefaultSettings.profile["castStartToggles"][id] = true
                end
            elseif body["type"] == "ability" or body["type"] == "kick" then
                if GSA.DefaultSettings.profile["castSuccessToggles"][id] == nil then
                    GSA.DefaultSettings.profile["castSuccessToggles"][id] = true
                end
            end
        end
    end

    GSA.db1 = LibStub("AceDB-3.0"):New("GladiatorlosSADB",GSA.DefaultSettings, "Default");
    GSA.db1.RegisterCallback(GSA, "OnProfileChanged", "ChangeProfile")
    GSA.db1.RegisterCallback(GSA, "OnProfileCopied", "ChangeProfile")
    GSA.db1.RegisterCallback(GSA, "OnProfileReset", "ChangeProfile")
    GSA_Settings = GSA.db1.profile
end

function GladiatorlosSA:OnInitialize()
    InitializeDBSpellList()
    GSA:InitializeOptionTable()
    GSA:InitAurasBar()
    GSA:RegisterChatCommand("gsa", "ShowConfig")
    DEFAULT_CHAT_FRAME:AddMessage("|cff69CCF0GladiatorlosSARemake|r (|cffFFF569/gsa|r)" .. GSALocale["GSA_VERSION"]);
end

function GladiatorlosSA:OnEnable()
    GSA:RegisterEvent("PLAYER_ENTERING_WORLD")
    GSA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    GSA:RegisterEvent("UNIT_AURA")
    if not GSA.GSA_LANGUAGE[GSA_Settings.voiceLocalePath] then GSA_Settings.voiceLocalePath = GSA.GSA_LOCALEPATH[GetLocale()] end
    GSA.throttled = {}
    GSA.smarter = 0
end

function GladiatorlosSA:PLAYER_ENTERING_WORLD()
    GSA:CheckZoneSoundAlertEnabled()
    GSA:ClearAurasBar()
end
-- Init End
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function GladiatorlosSA:log(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cFF33FF22GladiatorlosSA|r: "..msg)
end

-- play sound by file name
function GladiatorlosSA:PlaySound(fileName)
    local isPlaying = PlaySoundFile("Interface\\Addons\\" ..GSA_Settings.voiceLocalePath.. "\\"..fileName .. ".ogg", GSA_Settings.output_menu)
    if not isPlaying then
        isPlaying = PlaySoundFile("Interface\\Addons\\" ..GSA_Settings.voiceLocalePath.. "\\"..fileName .. ".mp3", GSA_Settings.output_menu)
        if not isPlaying then
            print("Sound files " .. fileName .. " .mp3 or .ogg are not exist")
        end
    end
end

-- TODO need refactor (at least function name)
function GladiatorlosSA:PlaySpell(spellName)
    if GSA_Settings.throttle ~= 0 and GSA:Throttle("playspell",GSA_Settings.throttle) then
        return
    end
    if GSA_Settings.smartDisable then
        if (GetNumGroupMembers() or 0) > 20 then return end
        if GSA:Throttle("smarter",20) then
            GSA.smarter = GSA.smarter + 1
            if GSA.smarter > 30 then return end
        else 
            GSA.smarter = 0
        end
    end

    GSA:PlaySound(spellName)
end

local isCanPlaySound = false
function GSA:CheckZoneSoundAlertEnabled()
    local _,currentZoneType,_,_,_,_,_,instanceMapID = GetInstanceInfo()

    isCanPlaySound = GSA_Settings.anywhereSAEnabled or
        ((currentZoneType == nil or currentZoneType == "none") and GSA_Settings.worldSAEnabled) or
        (currentZoneType == "pvp" and GSA_Settings.battlegroundSAEnabled and not GSA:IsEpicBG(instanceMapID)) or 
        (currentZoneType == "pvp" and GSA_Settings.epicBattlegroundSAEnabled and GSA:IsEpicBG(instanceMapID)) or
        (currentZoneType == "arena" and GSA_Settings.arenaSAEnabled)
end

local function CheckGUIDInGroup(guid)
    if guid == "" then
        return false
    end 
    return IsInGroup() and (IsGUIDInGroup(guid, LE_PARTY_CATEGORY_HOME) or IsGUIDInGroup(guid, LE_PARTY_CATEGORY_INSTANCE))
end

local enemyFilter = bit.bor(COMBATLOG_FILTER_HOSTILE_PLAYERS, COMBATLOG_FILTER_HOSTILE_UNITS)
local friendFilter = bit.bor(COMBATLOG_FILTER_FRIENDLY_UNITS, COMBATLOG_FILTER_ME, COMBATLOG_FILTER_MY_PET)
function GladiatorlosSA:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
    if (GetZonePVPInfo() == "sanctuary") or (not isCanPlaySound) then
        return
    end

    -- get current combat event info
    local _, event, _, sourceGUID, sourceName, sourceFlags, _, destGUID, destName, destFlags, _, spellID, spellName, _, typeParam = CombatLogGetCurrentEventInfo()

    -- check if event is not correct
    if not GSA.GSA_EVENT[event] then return end

    -- check target/focus settings
    if GSA_Settings.onlyTargetFocus then
        local isTarget = UnitGUID("target") == destGUID or UnitGUID("target") == sourceGUID
        local isFocus = UnitGUID("focus") == destGUID or UnitGUID("focus") == sourceGUID
        if not isTarget and not isFocus then
            return
        end
    end

    local isSourceEnemy  = CombatLog_Object_IsA(sourceFlags, enemyFilter)
    local isSourceFriend = CombatLog_Object_IsA(sourceFlags, friendFilter)
    local isDestEnemy    = CombatLog_Object_IsA(destFlags, enemyFilter) and (CheckGUIDInGroup(sourceGUID) or sourceGUID == UnitGUID("player"))
    local isDestFriend   = CombatLog_Object_IsA(destFlags, friendFilter) and (CheckGUIDInGroup(destGUID) or destGUID == UnitGUID("player"))

    -- Before spells check
    if isSourceEnemy then
        --  check is PvPTrinket
        if event == "SPELL_AURA_APPLIED" and GSA_Settings.pvpTrinket and GSA:IsPvPTrinket(spellID) then
            _, engClass, _, _, _, _, _ = GetPlayerInfoByGUID(sourceGUID)
            GSA:PlaySpell(engClass)
            return
        --  check is Reflected
        elseif event == "SPELL_MISSED" and typeParam == "REFLECT" and GSA_Settings.IsFriendReflectedEnable then
            GSA:PlaySpell(GSA:GetFriendReflectedSound())
            return
        end
    elseif isSourceFriend then
        --  check is Reflected
        if event == "SPELL_MISSED" and typeParam == "REFLECT" and GSA_Settings.IsEnemyReflectedEnable then
            GSA:PlaySpell(GSA:GetEnemyReflectedSound())
            return
        end
    end

    -- get current spell
    local currentSpell = GSA:FindSpellByID(spellID)
    if currentSpell == nil then 
        return
    end

    -- check Source is Enemy
    if isSourceEnemy then
        -- check event and (is spell's group enable in options) and (is spell enable in options)
        -- Check kick
        if event == "SPELL_CAST_SUCCESS" and GSA_Settings.IsEnemyUseInterruptEnable and currentSpell["type"] == "kick" then
            GSA:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_INTERRUPT" and GSA_Settings.IsEnemyUseInterruptEnable and currentSpell["type"] == "kick" then
            C_Timer.After(currentSpell["durationSound"], function() GSA:PlaySpell(GSA:GetEnemyInterruptedSuccessSound()) end)
        
        -- Check buff and debuff
        elseif event == "SPELL_AURA_APPLIED" and GSA_Settings.isAuraAppliedEnable and GSA_Settings["auraAppliedToggles"][spellID] then
            GSA:PlaySpell(currentSpell["soundName"])
        elseif event == "SPELL_AURA_REMOVED" and GSA_Settings.isAuraDownEnable and GSA_Settings["auraDownToggles"][spellID] then
            GSA:PlaySpell(currentSpell["soundName"])
            C_Timer.After(currentSpell["durationSound"] - 0.1, function() GSA:PlaySound(GSA:GetAuraDownSound()) end)
        
        -- Check cast spells
        elseif (event == "SPELL_CAST_START" or event == "SPELL_CAST_SUCCESS") and GSA_Settings.isCastStartEnable and GSA_Settings["castStartToggles"][spellID] then
            if event == "SPELL_CAST_START" then
                GSA:PlaySpell(currentSpell["soundName"])
            elseif GSA_Settings.IsSoundSuccessCastEnable then
                if GSA:Throttle(tostring(spellID).."default", 0.05) then return end
                GSA:PlaySound(GSA:GetCastSuccessSound())
            end

        -- Check simple spells without cast
        elseif event == "SPELL_CAST_SUCCESS" and GSA_Settings.isCastSuccessEnable and GSA_Settings["castSuccessToggles"][spellID] then
            GSA:PlaySpell(currentSpell["soundName"])
        end
    
    -- Check Dest is enemy
    elseif isDestEnemy then
        if event == "SPELL_INTERRUPT" and GSA_Settings.IsFriendUseInterruptSuccessEnable and currentSpell["type"] == "kick" then
            GSA:PlaySpell(GSA:GetFriendInterruptedSuccessSound())
        end

    -- Check Dest is friend or myself
    elseif isDestFriend then
        if event == "SPELL_AURA_APPLIED" and currentSpell["type"] == "debuff" and GSA_Settings.isAuraAppliedEnable and GSA_Settings["auraAppliedToggles"][spellID] then
            GSA:PlaySpell(currentSpell["soundName"])
        end
    end
end

local function IsDrinkingAuraByName(name)
    return string.find(name, "Drink") ~= nil or string.find(name, "Food") ~= nil or string.find(name, "Refreshment") ~= nil
end

function GladiatorlosSA:UNIT_AURA(event, unitTarget, updateInfo)
    local _,currentZoneType = IsInInstance()

    if currentZoneType ~= "arena" then
        return
    end

    GSA:ParseAuras(unitTarget, updateInfo)

    if GSA_Settings.drinking and updateInfo.addedAuras ~= nil and UnitIsEnemy("player", unitTarget) then
        for i = 1, #updateInfo.addedAuras do
            if IsDrinkingAuraByName(updateInfo.addedAuras[i].name) then
                GSA:PlaySound(GSA:GetDrinkingSound())
            end
        end
    end
end


 function GladiatorlosSA:Throttle(key,throttle)
    if (not GSA.throttled) then
        GSA.throttled = {}
    end
    -- Throttling of Playing
    if (not GSA.throttled[key]) then
        GSA.throttled[key] = GetTime()+throttle
        return false
    elseif (GSA.throttled[key] < GetTime()) then
        GSA.throttled[key] = GetTime()+throttle
        return false
    else
        return true
    end
 end