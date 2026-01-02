local AceLocale = LibStub:GetLibrary("AceLocale-3.0-ElvUI")
local L = AceLocale:NewLocale("ElvUI", "ruRU")
if not L then return end

L["Enhanced Quest XP"] = "Enhanced Quest XP"
L["General"] = "Общие"
L["ENABLED"] = "Включить"
L["ENABLED_DESC"] = "Включить расчёт улучшенного опыта за задания"

L["SERVER_MULTIPLIER"] = "Множитель сервера"
L["SERVER_MULTIPLIER_AUTO"] = "Автоопределение"
L["SERVER_MULTIPLIER_AUTO_DESC"] = "Автоматически определять множитель сервера по названию реалма"
L["SERVER_MULTIPLIER_MANUAL"] = "Ручной множитель"
L["SERVER_MULTIPLIER_MANUAL_DESC"] = "Вручную установить множитель опыта сервера (x1 - x5)"
L["SERVER_DETECTED"] = "Определено: x%d"

L["BONUS_TRACKING"] = "Отслеживание бонусов"
L["BONUS_TRACKING_ENABLED"] = "Автоопределение бонусов"
L["BONUS_TRACKING_ENABLED_DESC"] = "Автоматически определять и применять все бонусы опыта (Премиум, Праздники, Зелья, Фамильные предметы)"

L["STATUS_PREMIUM"] = "Премиум +%d%%"
L["STATUS_CHRISTMAS"] = "Праздник +%d%%"
L["STATUS_POTION"] = "Зелье +%d%%"
L["STATUS_FAMILY"] = "Фамильные +%d%% (%d предм.)"

L["CURRENT_STATUS"] = "Текущий статус"
L["STATUS_SERVER"] = "Сервер: x%d"
L["STATUS_NO_BONUSES"] = "Активные бонусы не обнаружены"

L["DEBUG_MODE"] = "Режим отладки"
L["DEBUG_MODE_DESC"] = "Показывать отладочные сообщения в чате"