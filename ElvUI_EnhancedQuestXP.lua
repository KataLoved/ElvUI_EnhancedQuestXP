local E, L, V, P, G = unpack(ElvUI)
local EQX = E:GetModule("EnhancedQuestXP")
local EP = LibStub("LibElvUIPlugin-1.0")

local addonName = ...
function EQX:Initialize()
    EP:RegisterPlugin(addonName, self.InsertOptions)

    self.Detection:DetectServerMultiplier()
    self.Detection:UpdateAll()

    self:RegisterEvent("UNIT_AURA", "OnAuraChange")
    self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED", "OnEquipmentChange")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("PLAYER_XP_UPDATE", "OnXPUpdate")
    self:RegisterEvent("QUEST_LOG_UPDATE", "OnQuestLogUpdate")

    self:HookDataBars()
end

function EQX:OnAuraChange(event, unit)
    if unit == "player" then
        self.Detection:UpdateAll()
        self:ForceUpdateQuestXP()
    end
end

function EQX:OnEquipmentChange()
    self.Detection:DetectFamilyItems()
    self:ForceUpdateQuestXP()
end

function EQX:OnPlayerEnteringWorld()
    C_Timer.After(2, function()
        self.Detection:UpdateAll()
        self:ForceUpdateQuestXP()
    end)
end

function EQX:OnXPUpdate()
    self:ForceUpdateQuestXP()
end

function EQX:OnQuestLogUpdate()
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

    local DataBars = E:GetModule("DataBars")
    if DataBars and DataBars.ExperienceBar_QuestXPUpdate then
        DataBars:ExperienceBar_QuestXPUpdate()
    end
end

function EQX:HookDataBars()
    local DataBars = E:GetModule("DataBars")
    if not DataBars then return end

    self:SecureHook(DataBars, "ExperienceBar_QuestXPUpdate", function(mod)
        if not E.db.enhanceQuestXP.enabled then return end

        if mod.questTotalXP and mod.questTotalXP > 0 then
            local multiplier = self.Calculator:GetXPMultiplier()
            mod.questTotalXP = math.floor(mod.questTotalXP * multiplier)

            if mod.expBar and mod.expBar.questBar and mod.expBar.maxExp then
                mod.expBar.questBar:SetMinMaxValues(0, mod.expBar.maxExp)
                mod.expBar.questBar:SetValue(math.min(mod.expBar.curExp + mod.questTotalXP, mod.expBar.maxExp))
            end

            self.Utils:Debug("Quest XP updated:", mod.questTotalXP, "| Multiplier:", string.format("%.2f", multiplier))
        end
    end)
end

local function InitializeCallback()
    EQX:Initialize()
end

E:RegisterModule(EQX:GetName(), InitializeCallback)