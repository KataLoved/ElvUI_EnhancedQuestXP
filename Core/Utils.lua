local E, L, V, P, G = unpack(ElvUI)
local EQX = E:GetModule("EnhancedQuestXP")

function EQX.Utils:ColorizeText(text, color)
    color = color or "ff8000"
    return format("|cff%s%s|r", color, text)
end

function EQX.Utils.IsMaxLevel(player)
	return UnitLevel(player) >= 80
end

function EQX.Utils:HasBuffById(unit, searchSpellId)
    local i = 1
    while true do
        local name, _, _, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i)
        if not name then return false, nil end
        if spellId == searchSpellId then return true, i end
        i = i + 1
    end
end

function EQX.Utils:HasDebuffById(unit, searchSpellId)
    local i = 1
    while true do
        local name, _, _, _, _, _, _, _, _, _, spellId = UnitDebuff(unit, i)
        if not name then return false, nil end
        if spellId == searchSpellId then return true, i end
        i = i + 1
    end
end

function EQX.Utils:ParseBuffPercentage(unit, buffIndex)
    if not buffIndex then return 0 end

    if not EQX.ScanTooltip then
        EQX.ScanTooltip = CreateFrame("GameTooltip", "EQXScanTooltip", nil, "GameTooltipTemplate")
        EQX.ScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local tooltip = EQX.ScanTooltip
    tooltip:ClearLines()
    tooltip:SetUnitBuff(unit, buffIndex)

    for i = 1, tooltip:NumLines() do
        local line = _G["EQXScanTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                for _, pattern in ipairs(EQX.Constants.Patterns.ExpBonus) do
                    local percent = text:match(pattern)
                    if percent then
                        return tonumber(percent) or 0
                    end
                end
            end
        end
    end

    return 0
end

function EQX.Utils:ParseDebuffPercentage(unit, debuffIndex)
    if not debuffIndex then return 0 end

    if not EQX.ScanTooltip then
        EQX.ScanTooltip = CreateFrame("GameTooltip", "EQXScanTooltip", nil, "GameTooltipTemplate")
        EQX.ScanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    end

    local tooltip = EQX.ScanTooltip
    tooltip:ClearLines()
    tooltip:SetUnitDebuff(unit, debuffIndex)

    for i = 1, tooltip:NumLines() do
        local line = _G["EQXScanTooltipTextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                for _, pattern in ipairs(EQX.Constants.Patterns.ExpBonus) do
                    local percent = text:match(pattern)
                    if percent then
                        return tonumber(percent) or 0
                    end
                end
            end
        end
    end

    return 0
end

function EQX.Utils:ParseServerMultiplier()
    local realmName = GetRealmName() or ""
    local multiplier = realmName:match(EQX.Constants.Patterns.ServerMultiplier)
    return tonumber(multiplier) or EQX.Constants.Defaults.ServerMultiplier
end

function EQX.Utils:GetEquippedItemId(slot)
    local itemLink = GetInventoryItemLink("player", slot)
    if itemLink then
        local itemId = itemLink:match("item:(%d+)")
        return tonumber(itemId)
    end
    return nil
end

function EQX.Utils:Round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

function EQX.Utils:Debug(...)
    if E.db.enhanceQuestXP and E.db.enhanceQuestXP.debugMode then
        print("|cff1784d1[EQX Debug]|r", ...)
    end
end
