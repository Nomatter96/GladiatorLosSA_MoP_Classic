local GSA = GladiatorlosSA
local GSA_Settings

local isBarMovingNow = false
local aurasBar = {
    buffs,
    debuffs
}

local aurasFrame = {
    buffs   = {},
    debuffs = {}
}

local lastActiveAuraOrder = {
    buffs   = 0,
    debuffs = 0
}

local function CreateBar(aurasBarSettings)
    local bar = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    bar:SetPoint(aurasBarSettings.point, UIParent, aurasBarSettings.relativePoint, aurasBarSettings.offsetX, aurasBarSettings.offsetY)
    bar:SetMovable(true)
    bar:SetSize(20, 20)
    bar:SetClampedToScreen(true)
    bar:Show()
    return bar
end

local function GetTypeAura(aura)
    if aura == nil then
        return nil
    end
    if aura.isHelpful then
        return "buffs"
    elseif aura.isHarmful then
        return "debuffs"
    else
        return nil
    end
end

function GladiatorlosSA:ClearAurasBar()
    for _,typeAuraData in pairs(aurasFrame) do
        for _,unitTargetData in pairs(typeAuraData) do
            for _,auraData in pairs(unitTargetData) do
                if auraData.active then
                    auraData.deactivate()
                end
            end
        end
    end
end

function GladiatorlosSA:InitAurasBar()
    GSA_Settings = GSA.db1.profile

    if GSA_Settings.buffsBarSettings == nil or GSA_Settings.debuffsBarSettings == nil then
        GSA:SetDefaultAurasBarSettings()
    end

    aurasBar["buffs"]   = CreateBar(GSA_Settings.buffsBarSettings)
    aurasBar["debuffs"] = CreateBar(GSA_Settings.debuffsBarSettings)
end

function GladiatorlosSA:SetDefaultAurasBarSettings()
    GSA_Settings.sizeIconAuraBar = 45
    GSA_Settings.offsetBetweenIconsAuraBar = 5
    GSA_Settings.offsetAuraBar_Y = 25 * (-1)
    GSA_Settings.defaultOffsetDebuffFrames_Y = GSA_Settings.offsetAuraBar_Y + (GSA_Settings.sizeIconAuraBar * 1.5 + 5) * (-1)
    GSA_Settings.buffsBarSettings = { point = "CENTER", relativePoint = "TOP", offsetX = 0, offsetY = 0 }
    GSA_Settings.debuffsBarSettings = { point = "CENTER", relativePoint = "TOP", offsetX = 0, offsetY = GSA_Settings.defaultOffsetDebuffFrames_Y }
end

local isArenaUnit = false
local isPartyUnit = false
function GladiatorlosSA:ParseAuras(unitTarget, updateInfo)
    isArenaUnit = false
    isPartyUnit = false
    for i = 1, 5 do
        if unitTarget == ("arena" .. i) then
            isArenaUnit = true
        elseif unitTarget == ("party" .. i) then
            isPartyUnit = true
        end
    end

    if not isArenaUnit and not isPartyUnit then
        return
    end

    if updateInfo.addedAuras ~= nil then
        for i = 1, #updateInfo.addedAuras do
            GSA:DisplayAuraFrame(unitTarget, updateInfo.addedAuras[i])
        end
    end
    if updateInfo.updatedAuraInstanceIDs ~= nil then
        for i = 1, #updateInfo.updatedAuraInstanceIDs do
            local updatedAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unitTarget, updateInfo.updatedAuraInstanceIDs[i])
            GSA:UpdateAuraFrame(unitTarget, updatedAura)
        end
    end
    if updateInfo.removedAuraInstanceIDs ~= nil then
        for i = 1, #updateInfo.removedAuraInstanceIDs do
            GSA:RemoveAuraFrame(unitTarget, updateInfo.removedAuraInstanceIDs[i])
        end
    end
end

function GladiatorlosSA:DisplayAuraFrame(unitTarget, aura)
    local currentSpell = GSA:FindSpellByID(aura.spellId)
    if currentSpell == nil or (GSA_Settings["auraAppliedToggles"][aura.spellId] ~= true and currentSpell["type"] ~= "display") then
        return
    end

    local typeAura = GetTypeAura(aura)
    local isPartyUnitBuff   = typeAura == "buffs" and isPartyUnit
    local isArenaUnitDebuff = typeAura == "debuffs" and isArenaUnit
    if typeAura == nil or isPartyUnitBuff or isArenaUnitDebuff or 
        (typeAura == "buffs" and not GSA_Settings.displayEnemyBuffs) or 
        (typeAura == "debuffs" and not GSA_Settings.displayPartyDebuffs) then
        return
    end

    GSA:CreateAura(unitTarget, aura.spellId, typeAura)
    local curSpell = aurasFrame[typeAura][unitTarget][aura.spellId]
    curSpell.auraInstanceID = aura.auraInstanceID
    curSpell.duration = aura.duration
    curSpell.activate()
end

function GladiatorlosSA:UpdateAuraFrame(unitTarget, updatedAura)
    local typeAura = GetTypeAura(updatedAura)
    if typeAura == nil then
        return
    end

    if aurasFrame[typeAura][unitTarget] ~= nil and aurasFrame[typeAura][unitTarget][updatedAura.spellId] ~= nil then
        aurasFrame[typeAura][unitTarget][updatedAura.spellId].duration = updatedAura.duration
        aurasFrame[typeAura][unitTarget][updatedAura.spellId].activate()
    end
end

function GladiatorlosSA:RemoveAuraFrame(unitTarget, removedAuraInstanceID)
    for typeAuraName,_ in pairs(aurasFrame) do
        if aurasFrame[typeAuraName][unitTarget] ~= nil then
            for _, aura in pairs(aurasFrame[typeAuraName][unitTarget]) do
                if aura.auraInstanceID == removedAuraInstanceID and aura.active then
                    aura.deactivate()
                    return
                end
            end
        end
    end
end

local function SpellDuration_OnUpdate(self)
    if self.timer.isEnd then
        self.deactivate()
    end
end

local function SpellDuration_OnCooldownDone(self)
    self.isEnd = true
end

local function ReOrderAurasFrame(typeAura)
    for _, units in pairs(aurasFrame[typeAura]) do
        for _, aura in pairs(units) do
            if aura.active then
                local offsetX = (aura.order - 1) * GSA_Settings.sizeIconAuraBar + (aura.order - 1) * GSA_Settings.offsetBetweenIconsAuraBar
                local offsetY = GSA_Settings.offsetAuraBar_Y
                if typeAura == "debuffs" then
                    offsetY = GSA_Settings.offsetAuraBar_Y
                end
                aura:SetPoint("CENTER", aurasBar[typeAura], "CENTER", offsetX, offsetY)
            end
        end
    end

    if isBarMovingNow then return end

    local aurasBarSettings
    if typeAura == "debuffs" then
        aurasBarSettings = GSA_Settings.debuffsBarSettings
    else
        aurasBarSettings = GSA_Settings.buffsBarSettings
    end
    local lastOrder = lastActiveAuraOrder[typeAura]
    offsetX = aurasBarSettings.offsetX
    if lastOrder > 1 then
        lastOrder = lastOrder - 1
        offsetX = aurasBarSettings.offsetX + (lastOrder * GSA_Settings.sizeIconAuraBar + lastOrder * GSA_Settings.offsetBetweenIconsAuraBar) / 2 * (-1)
    end
    aurasBar[typeAura]:SetPoint(aurasBarSettings.point, UIParent, aurasBarSettings.relativePoint, offsetX, aurasBarSettings.offsetY)
end

local function ShiftLeftAurasFrame(startOrder, typeAura)
    for _, units in pairs(aurasFrame[typeAura]) do
        for _, aura in pairs(units) do
            if aura.active and startOrder < aura.order then
                aura.order = aura.order - 1
            end
        end
    end
    lastActiveAuraOrder[typeAura] = lastActiveAuraOrder[typeAura] - 1
end

local function CreateTimer(widget)
    if widget.timer ~= nil then
        widget.timer:Clear()
    end
    
    local timer = CreateFrame("Cooldown",nil,widget, "CooldownFrameTemplate")
    timer.noomnicc = false
    timer.noCooldownCount = false
    timer:SetAllPoints(true)
    timer:SetReverse(true)
    timer:SetFrameStrata("MEDIUM")
    timer:Hide()
    widget.timer = timer
end

function GladiatorlosSA:CreateAura(unitTarget, spellID, typeAura)
    if aurasFrame[typeAura][unitTarget] == nil then
        aurasFrame[typeAura][unitTarget] = {}
    end
    if aurasFrame[typeAura][unitTarget][spellID] ~= nil then
        CreateTimer(aurasFrame[typeAura][unitTarget][spellID])
        return
    end

    local btn = CreateFrame("Frame",nil,aurasBar[typeAura])
    btn:SetWidth(GSA_Settings.sizeIconAuraBar)
    btn:SetHeight(GSA_Settings.sizeIconAuraBar)
    btn:SetFrameStrata("LOW")

    CreateTimer(btn)

    local texture = btn:CreateTexture(nil,"BACKGROUND")
    texture:SetAllPoints(true)
    texture:SetTexture(GetSpellTexture(spellID))
    texture:SetTexCoord(0.07,0.9,0.07,0.90)

    local unitName = btn:CreateFontString(nil, "ARTWORK")
    unitName:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    unitName:SetTextColor(1, 1, 0, 1)
    unitName:SetPoint("CENTER", btn, "TOP", 0.0, 10.0)
    unitName:SetText(string.upper(string.sub(unitTarget,1,1)) .. string.sub(unitTarget,string.len(unitTarget), string.len(unitTarget)))

    btn.texture = texture
    btn.unitName = unitName
    btn.typeAura = typeAura
    btn.spellID = spellID

    btn.activate = function()
        if not btn.active then
            btn:Show()
            btn.timer:Show()
            btn.active = true
            btn.order = lastActiveAuraOrder[typeAura] + 1
            lastActiveAuraOrder[typeAura] = btn.order
            ReOrderAurasFrame(btn.typeAura)
        end
        btn.start = GetTime()
        btn.timer:SetCooldown(GetTime(), btn.duration)
        btn.start = GetTime()
        btn:SetScript("OnUpdate", SpellDuration_OnUpdate)
        btn.timer:SetScript("OnCooldownDone", SpellDuration_OnCooldownDone)
    end

    btn.deactivate = function()
        btn.timer:Hide()
        btn:Hide()
        btn:SetScript("OnUpdate", nil)
        btn.timer:SetScript("OnCooldownDone", nil)
        btn.active = false
        ShiftLeftAurasFrame(btn.order, btn.typeAura)
        ReOrderAurasFrame(btn.typeAura)
    end

    aurasFrame[typeAura][unitTarget][spellID] = btn
end

local backdropInfo =
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
 	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
 	tile = true,
 	tileEdge = true,
 	tileSize = 8,
 	edgeSize = 8,
 	insets = { left = 1, right = 1, top = 1, bottom = 1 },
}

function GladiatorlosSA:SetAurasBarMoveable(isMoveable)
    for _,barData in pairs(aurasBar) do
        if isMoveable then
            barData:SetBackdrop(backdropInfo)
            barData:SetScript("OnMouseDown", function(self,button)
                if button == "LeftButton" then
                    self:StartMoving()
                    isBarMovingNow = true
                end
            end)
            barData:SetScript("OnMouseUp", function(self,button)
                if button == "LeftButton" then
                    self:StopMovingOrSizing()
                    GSA:SaveAurasBarPosition()
                    isBarMovingNow = false
                end
            end)
        else
            barData:SetBackdrop(nil)
            barData:SetScript("OnMouseDown", nil)
            barData:SetScript("OnMouseUp", nil)
        end
    end
end

function GladiatorlosSA:SaveAurasBarPosition()
    GSA_Settings.buffsBarSettings.point, _, GSA_Settings.buffsBarSettings.relativePoint, GSA_Settings.buffsBarSettings.offsetX, GSA_Settings.buffsBarSettings.offsetY = aurasBar["buffs"]:GetPoint()
    GSA_Settings.debuffsBarSettings.point, _, GSA_Settings.debuffsBarSettings.relativePoint, GSA_Settings.debuffsBarSettings.offsetX, GSA_Settings.debuffsBarSettings.offsetY = aurasBar["debuffs"]:GetPoint()
end
