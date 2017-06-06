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
    ["Options for the farclip plugin."] = true,
    ["Active"] = true,
    ["Activate the plugin."] = true,
} end)

--[[L:RegisterTranslations("deDE", function() return {
    
} end)
]]
----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFarclip = BigWigs:NewModule(L["Farclip"])
BigWigsFarclip.revision = 20010
BigWigsFarclip.defaultDB = {
    active = true,
	defaultFarclip = 777,
}
BigWigsFarclip.consoleCmd = L["farclip"]

BigWigsFarclip.consoleOptions = {
	type = "group",
	name = L["Farclip"],
	desc = L["Options for the farclip plugin."],
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
    self:DebugMessage(1)
    if self.db.profile.active then
        self:DebugMessage(2)
        if AceLibrary("Babble-Zone-2.2")["Naxxramas"] == GetRealZoneText() then
            self.db.profile.defaultFarclip = GetCVar("farclip")
            SetCVar("farclip", minFarclip) -- http://wowwiki.wikia.com/wiki/CVar_farclip
        else
            self:DebugMessage(3)
            if tonumber(GetCVar("farclip")) == minFarclip then
                self:DebugMessage(4)
                SetCVar("farclip", self.db.profile.defaultFarclip)
            end
        end
    end
end
