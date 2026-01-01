local E, L, V, P, G = unpack(ElvUI)
local EFL = E:GetModule("EnhancedQuestXP")

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function EFL:InsertOptions()
	E.Options.args.enhanceQuestXP = {
		order = 53,
		type = "group",
		childGroups = "tab",
		name = ColorizeSettingName("Enhanced Quest XP"),
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Enhanced Quest XP"]
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				get = function(info) return E.db.enhanceQuestXP[ info[#info] ] end,
				set = function(info, value) E.db.enhanceQuestXP[ info[#info] ] = value; EFL:UpdateSettings(); end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = L["General"],
					},
					questXpEnabled = {
						order = 1,
						type = "toggle",
						name = L["QUEST_XP_ENABLED"]
					},
					questXpOptions = {
						order = 2,
						type = "group",
						name = L["QUEST_XP_OPTIONS"],
						get = function(info) return E.db.enhanceQuestXP[ info[#info] ] end,
						set = function(info, value) E.db.enhanceQuestXP[ info[#info] ] = value; EFL:UpdateSettings(); end,
						args = {
							questXpMultiplier = {
								order = 1,
								type = "range",
								name = L["QUEST_XP_MULTIPLIER"],
								min = 1, max = 5, step = 1
							},
							selfXpMultiplier = {
								order = 2,
								type = "range",
								name = L["SELF_XP_MULTIPLIER"],
								desc = L["SELF_XP_MULTIPLIER_DESC"],
								min = 0, max = 300, step = 1
							}
						}
					}
				}
			}
		}
	}
end