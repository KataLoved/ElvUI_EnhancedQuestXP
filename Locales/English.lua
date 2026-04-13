local AceLocale = LibStub:GetLibrary("AceLocale-3.0-ElvUI")
local L = AceLocale:NewLocale("ElvUI", "enUS", true, true)
if not L then return end

L["Enhanced Quest XP"] = true
L["General"] = true
L["ENABLED"] = "Enable"
L["ENABLED_DESC"] = "Enable Enhanced Quest XP calculation"

L["SERVER_MULTIPLIER"] = "Server Multiplier"
L["SERVER_MULTIPLIER_AUTO"] = "Auto-detect"
L["SERVER_MULTIPLIER_AUTO_DESC"] = "Automatically detect server multiplier from realm name"
L["SERVER_MULTIPLIER_MANUAL"] = "Manual multiplier"
L["SERVER_MULTIPLIER_MANUAL_DESC"] = "Manually set server XP multiplier (x1 - x5)"
L["SERVER_DETECTED"] = "Detected: x%d"

L["BONUS_TRACKING"] = "Bonus Tracking"
L["BONUS_TRACKING_ENABLED"] = "Auto-detect bonuses"
L["BONUS_TRACKING_ENABLED_DESC"] = "Automatically detect and apply all XP bonuses (Premium, Holiday events, Potions, Heirloom items)"

L["STATUS_PREMIUM"] = "Premium +%d%%"
L["STATUS_CHRISTMAS"] = "Holiday +%d%%"
L["STATUS_POTION"] = "Potion +%d%%"
L["STATUS_FAMILY"] = "Heirlooms +%d%% (%d items)"

L["CURRENT_STATUS"] = "Current Status"
L["STATUS_SERVER"] = "Server: x%d"
L["STATUS_NO_BONUSES"] = "No active bonuses detected"

L["DEBUG_MODE"] = "Debug Mode"
L["DEBUG_MODE_DESC"] = "Show debug messages in chat"

L["XP_DISABLED_DETECTED"] = "XP gain is disabled. Quest XP bar adjustments suspended."
L["XP_DISABLED_CHANGED"] = "XP gain has been disabled. Quest XP bar adjustments suspended."
L["XP_ENABLED_CHANGED"] = "XP gain has been enabled. Quest XP bar adjustments resumed."