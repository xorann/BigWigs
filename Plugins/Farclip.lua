--[[
    by Dorann
    Reduces farclip (terrain distance) to a minimum in naxxramas to avoid screen freezes
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsFarclip")
local minFarclip = 177
----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Farclip"] = true,
    ["farclip"] = true,
    ["Reduces the terrain distance to the minimum in Naxxramas to avoid screen freezes."] = true,
    ["Active"] = true,
    ["Activate the plugin."] = true,
} end)

L:RegisterTranslations("ruRU", function() return {
	["Farclip"] = "Дальность отрисовки",
	--["farclip"] = "farclip",
	["Reduces the terrain distance to the minimum in Naxxramas to avoid screen freezes."] = "Уменьшает дальность отрисовки на минимум в Наксрамасе, чтобы избежать подвисания экрана.",
	["Active"] = "Включен",
	["Activate the plugin."] = "Активировать плагин",
} end)

--[[L:RegisterTranslations("deDE", function() return {
    
} end)
]]
----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFarclip = BigWigs:NewModule(L["Farclip"])
BigWigsFarclip.revision = 20011
BigWigsFarclip.external = true

BigWigsFarclip.defaultDB = {
    active = true,
	defaultFarclip = 777,
}
BigWigsFarclip.consoleCmd = L["farclip"]

BigWigsFarclip.consoleOptions = {
	type = "group",
	name = L["Farclip"],
	desc = L["Reduces the terrain distance to the minimum in Naxxramas to avoid screen freezes."],
	args   = {
        active = {
			type = "toggle",
			name = L["Active"],
			desc = L["Activate the plugin."],
			order = 1,
			get = function() return BigWigsFarclip.db.profile.active end,
			set = function(v) BigWigsFarclip.db.profile.active = v end,
			--passValue = "reverse",
		}
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsFarclip:OnEnable()
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end

function BigWigsFarclip:ZONE_CHANGED_NEW_AREA()
    if self.db.profile.active then
        if AceLibrary("Babble-Zone-2.2")["Naxxramas"] == GetRealZoneText() then
			if minFarclip ~= tonumber(GetCVar("farclip")) then
				self.db.profile.defaultFarclip = GetCVar("farclip")
				SetCVar("farclip", minFarclip) -- http://wowwiki.wikia.com/wiki/CVar_farclip
			end
        else
            if tonumber(GetCVar("farclip")) == minFarclip then
                SetCVar("farclip", self.db.profile.defaultFarclip)
            end
        end
    end
end
