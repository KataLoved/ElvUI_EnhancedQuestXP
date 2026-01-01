local E, L, V, P, G = unpack(ElvUI)
local EFL = E:NewModule("EnhancedQuestXP", "AceHook-3.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local LSM = LibStub("LibSharedMedia-3.0", true)
local addonName = ...

local unpack, pairs, ipairs = unpack, pairs, ipairs
local format = format

EFL.totalXpMultiplier = 1

function EFL:UpdateSettings()
	self.db = E.db.enhanceQuestXP
	if not self.db then return end

	if self.db.questXpEnabled then
		local questMultiplier = self.db.questXpMultiplier or 1
		local selfMultiplier = self.db.selfXpMultiplier or 0
	
		self.totalXpMultiplier = questMultiplier * (1 + selfMultiplier / 100)
	else
		self.totalXpMultiplier = 1
	end

	self:SetQuestXPMultiplier()
end

function EFL:SetQuestXPMultiplier()
	local DataBars = E:GetModule("DataBars")
	if DataBars and DataBars.ExperienceBar_QuestXPUpdate then
		DataBars:ExperienceBar_QuestXPUpdate()
	end
end

function EFL:Initialize()
	EP:RegisterPlugin(addonName, self.InsertOptions)

	if not EnhancedQuestXpDB then
		EnhancedQuestXpDB = {}
	end

	self:UpdateSettings()
	self:SetQuestXPMultiplier()

	local DataBars = E:GetModule("DataBars")
	if DataBars then
		self:SecureHook(DataBars, "ExperienceBar_QuestXPUpdate", function(mod)
			if mod.questTotalXP and mod.questTotalXP > 0 then
				mod.questTotalXP = math.floor(mod.questTotalXP * self.totalXpMultiplier)

				if mod.expBar and mod.expBar.questBar and mod.expBar.maxExp then
					mod.expBar.questBar:SetMinMaxValues(0, mod.expBar.maxExp)
					mod.expBar.questBar:SetValue(math.min(mod.expBar.curExp + mod.questTotalXP, mod.expBar.maxExp))
				end
			end
		end)
	end
end

local function InitializeCallback()
	EFL:Initialize()
end

E:RegisterModule(EFL:GetName(), InitializeCallback)