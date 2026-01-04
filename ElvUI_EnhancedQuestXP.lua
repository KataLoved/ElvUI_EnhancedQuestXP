local E, L, V, P, G = unpack(ElvUI)
local EQX = E:GetModule("EnhancedQuestXP")
local EP = LibStub("LibElvUIPlugin-1.0")

local C_Timer = _G.C_Timer

local addonName = ...
function EQX:Initialize()
    EP:RegisterPlugin(addonName, self.InsertOptions)

    self.Detection:DetectServerMultiplier()
    self.Detection:UpdateAll()

    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "OnEquipmentChange")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("QUEST_LOG_UPDATE", "OnQuestLogUpdate")
    self:RegisterEvent("DISABLE_XP_GAIN", "OnXPGainDisabled")
    self:RegisterEvent("ENABLE_XP_GAIN", "OnXPGainEnabled")
    self:RegisterEvent("PLAYER_XP_UPDATE", "OnXPUpdate")
    self:RegisterEvent("UNIT_AURA", "OnAuraChange")

    self:HookDataBars()
    self:CheckInitialXPStatus()
end

function EQX:CheckInitialXPStatus()
    local isDisabled = self.Utils:GetXPDisabledState()
    if isDisabled then
        self.Utils:NotifyXPStatus(true, true)
    end
end

function EQX:OnAuraChange(event, unit)
    if unit == "player" then
        if self.Utils:GetXPDisabledState() then return end
        self.Detection:UpdateAll()
        self:ForceUpdateQuestXP()
    end
end

function EQX:OnEquipmentChange()
    if self.Utils:GetXPDisabledState() then return end
    self.Detection:DetectFamilyItems()
    self:ForceUpdateQuestXP()
end

function EQX:OnPlayerEnteringWorld()
    ---@diagnostic disable-next-line
    C_Timer:After(2, function()
        local isDisabled = EQX.Utils:GetXPDisabledState()
        if isDisabled then return end

        EQX.Detection:UpdateAll()
        self:ForceUpdateQuestXP()
    end)
end

function EQX:OnXPGainDisabled()
    self.Utils.xpDisabledCache = true
    self.Utils:NotifyXPStatus(true, false)
    self:ResetQuestXPBar()
end

function EQX:OnXPGainEnabled()
    self.Utils.xpDisabledCache = false
    self.Utils:NotifyXPStatus(false, false)
    self.Detection:UpdateAll()
    self:ForceUpdateQuestXP()
end

function EQX:OnXPUpdate()
    if self.Utils:GetXPDisabledState() then return end
    self:ForceUpdateQuestXP()
end

function EQX:OnQuestLogUpdate()
    if self.Utils:GetXPDisabledState() then return end
    self:ForceUpdateQuestXP()
end

function EQX:UpdateSettings()
    self.Detection:UpdateAll()

    if not E.db.enhanceQuestXP.enabled then
        self:ResetQuestXPBar()
    else
        self:ForceUpdateQuestXP()
    end
end

function EQX:ResetQuestXPBar()
    local DataBars = E:GetModule("DataBars")
    if DataBars and DataBars.ExperienceBar_QuestXPUpdate then
        DataBars:ExperienceBar_QuestXPUpdate()
    end
end

function EQX:ForceUpdateQuestXP()
    if not E.db.enhanceQuestXP.enabled then return end
    if self.Utils.IsMaxLevel("player") then return end
    if self.Utils:GetXPDisabledState() then return end

    local DataBars = E:GetModule("DataBars")
    if DataBars and DataBars.ExperienceBar_QuestXPUpdate then
        DataBars:ExperienceBar_QuestXPUpdate()
    end
end

function EQX:HookDataBars()
    local DataBars = E:GetModule("DataBars")
    if not DataBars then return end

    self.questXPCache = { modified = nil }

    self:SecureHook(DataBars, "ExperienceBar_QuestXPUpdate", function(mod)
        if not E.db.enhanceQuestXP.enabled then return end
        if EQX.Utils.IsMaxLevel("player") then return end

        if mod.questTotalXP and mod.questTotalXP > 0 then
            if self.questXPCache.modified and mod.questTotalXP == self.questXPCache.modified then
                return
            end

            local originalXP = mod.questTotalXP
            local multiplier = self.Calculator:GetXPMultiplier()
            local modifiedXP = math.floor(originalXP * multiplier)

            self.questXPCache.modified = modifiedXP
            mod.questTotalXP = modifiedXP

            if mod.expBar and mod.expBar.questBar and mod.expBar.maxExp and mod.expBar.maxExp > 0 then
                mod.expBar.questBar:SetMinMaxValues(0, mod.expBar.maxExp)
                mod.expBar.questBar:SetValue(math.min(mod.expBar.curExp + mod.questTotalXP, mod.expBar.maxExp))
            end

            self.Utils:Debug("Quest XP updated:", originalXP, ">", mod.questTotalXP, "| Multiplier:", string.format("%.2f", multiplier))
        else
            self.questXPCache.modified = nil
        end
    end)
end

local function InitializeCallback()
    EQX:Initialize()
end

E:RegisterModule(EQX:GetName(), InitializeCallback)