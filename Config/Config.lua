local E, L, V, P, G = unpack(ElvUI)
local EQX = E:GetModule("EnhancedQuestXP")

local function ColorizeSettingName(name)
    return format("|cff1784d1%s|r", name)
end

function EQX:InsertOptions()
    E.Options.args.enhanceQuestXP = {
        order = 53,
        type = "group",
        childGroups = "tab",
        name = ColorizeSettingName("Enhanced Quest XP"),
        get = function(info) return E.db.enhanceQuestXP[info[#info]] end,
        set = function(info, value)
            E.db.enhanceQuestXP[info[#info]] = value
            EQX:UpdateSettings()
        end,
        args = {
            header = {
                order = 1,
                type = "header",
                name = L["Enhanced Quest XP"],
            },
            general = {
                order = 2,
                type = "group",
                name = L["General"],
                args = {
                    enabled = {
                        order = 1,
                        type = "toggle",
                        name = L["ENABLED"],
                        desc = L["ENABLED_DESC"],
                        width = "full",
                    },
                    spacer1 = {
                        order = 2,
                        type = "description",
                        name = "",
                    },

                    serverHeader = {
                        order = 10,
                        type = "header",
                        name = L["SERVER_MULTIPLIER"],
                    },
                    serverMultiplierAuto = {
                        order = 11,
                        type = "toggle",
                        name = L["SERVER_MULTIPLIER_AUTO"],
                        desc = L["SERVER_MULTIPLIER_AUTO_DESC"],
                        width = "full",
                    },
                    serverMultiplier = {
                        order = 12,
                        type = "range",
                        name = L["SERVER_MULTIPLIER_MANUAL"],
                        desc = L["SERVER_MULTIPLIER_MANUAL_DESC"],
                        min = 1, max = 5, step = 1,
                        disabled = function() return E.db.enhanceQuestXP.serverMultiplierAuto end,
                    },
                    serverDetected = {
                        order = 13,
                        type = "description",
                        name = function()
                            local detected = 1
                            if EQX.Detection and EQX.Detection.DetectServerMultiplier then
                                detected = EQX.Detection:DetectServerMultiplier() or 1
                            end
                            return "|cff00ff00" .. format(L["SERVER_DETECTED"], detected) .. "|r"
                        end,
                        hidden = function() return not E.db.enhanceQuestXP.serverMultiplierAuto end,
                    },
                },
            },

            bonusTracking = {
                order = 3,
                type = "group",
                name = L["BONUS_TRACKING"],
                args = {
                    bonusHeader = {
                        order = 1,
                        type = "header",
                        name = L["BONUS_TRACKING"],
                    },
                    bonusTrackingEnabled = {
                        order = 2,
                        type = "toggle",
                        name = L["BONUS_TRACKING_ENABLED"],
                        desc = L["BONUS_TRACKING_ENABLED_DESC"],
                        width = "full",
                    },

                    statusHeader = {
                        order = 10,
                        type = "header",
                        name = L["CURRENT_STATUS"],
                    },
                    statusDisplay = {
                        order = 11,
                        type = "description",
                        name = function()
                            if not EQX.Detection then
                                return "|cff888888" .. L["STATUS_NO_BONUSES"] .. "|r"
                            end
                            EQX.Detection:UpdateAll()
                            local status = EQX.Detection:GetStatusText()
                            if not status or status == "" then
                                return "|cff888888" .. L["STATUS_NO_BONUSES"] .. "|r"
                            end
                            return "|cff00ff00" .. status .. "|r"
                        end,
                        fontSize = "medium",
                    },
                },
            },

            debug = {
                order = 99,
                type = "group",
                name = "Debug",
                args = {
                    debugMode = {
                        order = 1,
                        type = "toggle",
                        name = L["DEBUG_MODE"],
                        desc = L["DEBUG_MODE_DESC"],
                    },
                },
            },
        },
    }
end