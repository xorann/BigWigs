--[[
    by LYQ(Virose / MOUZU)
    https://github.com/MOUZU/BigWigs
    
    Oh, so you did find your way to this creepy place.

    In case you're really modifying my version I trust in
    your respect that you will not touch this one.

    The footage analysis and core changes took a lot of
    time I could've spent with earning money irl or ig,
    so If you really want me to keep improving and adjusting
    this AddOn for future content releases on Nostalrius
    I'd appreciate you leaving this.

    This plugin is displaying a message once per character, if the
    character is not a member of Endurance to contribute gold to
    the Author of the Nostalrius edit which is me, LYQ.

    In addition to that, this plugin will notify the player on
    unsupported content usage. What I mean by that is, if the
    player uses the first release which has only MC/ONY/BWL/ZG
    support since more content wasn't released yet and the player
    is currently going AQ or NAXX.
    OR if AQ is released but a new adjusted AQ version of
    BigWigs is not out yet, so the player will be notified
    once per login to contribute footage for analyzing purpose
    to me, LYQ - which would help the process and speed things up.
--]]

------------------------------
--      Are you local?      --
------------------------------
local name = "Contribute"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local listOfRaidZones   = {
    "Molten Core",
    "Onyxia's Lair",
    "Blackwing Lair",
    "Zul'Gurub",
    "Ruins of Ahn'Qiraj",
    "Ahn'Qiraj",
    "Naxxramas"
}
local unsupportedRaids  = {
    -- this is a list of unsupported raids in this version
    -- needs to be updated on future content and AddOn releases
    "Molten Core",
    "Onyxia's Lair",
    "Blackwing Lair",
    "Zul'Gurub",
    "Ruins of Ahn'Qiraj",
    "Ahn'Qiraj",
    "Naxxramas"
}
local footageRequested  	= false
local BigWigsContributeFlag = false
local prefix            	= "|cf75DE52f[BigWigs]|r - ";


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["This |cf75DE52fClassic-WoW|r Version was made by |cff7f7fffDorann|r."] = true,
	["This addon is still work in progress and content is adjusted by |cff7f7fffDorann|r. Check for Updates or help by providing twitch/youtube footage on https://github.com/xorann/BigWigs/releases "] = true,
    ["This version of BigWigs is |cffff0000not intended for your realm|r. Please be aware that |cffff0000timers might be wrong or not working at all|r."] = true
} end)

L:RegisterTranslations("deDE", function() return {
    ["This |cf75DE52fClassic-WoW|r Version was made by |cff7f7fffDorann|r."] = "Diese |cf75DE52fClassic-WoW|r Version wurde von |cff7f7fffDorann|r erstellt.",
	["This addon is still work in progress and content is adjusted by |cff7f7fffDorann|r. Check for Updates or help by providing twitch/youtube footage on https://github.com/xorann/BigWigs/releases "] = "Dieses Addon befindet sich noch in Arbeit und der Inhalt wird von |cff7f7fffDorann|r angepasst. Besucht https://github.com/xorann/BigWigs/releases für Updates oder um die Entwicklung mit twitch/youtube Aufnahmen zu unterstützen.",
    ["This version of BigWigs is |cffff0000not intended for your realm|r. Please be aware that |cffff0000timers might be wrong or not working at all|r."] = "Diese Version von BigWigs ist |cffff0000nicht für Deinen Realm vorgesehen|r. Sei Dir bitte bewusst, dass |cffff0000Timer falsch sein können oder gar nicht funktionieren|r."
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsContribute               = BigWigs:NewModule(name)
BigWigsContribute.toggleoptions = {"footage"}

------------------------------
--      Initialization      --
------------------------------

function BigWigsContribute:OnEnable()
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    
    -- this will deactivate the footage Request on unsupported content
    if self.db.profile.footage == false then
        footageRequested = true
    end
end

function BigWigsContribute:ZONE_CHANGED_NEW_AREA()
    -- this will trigger the donation message once per character if not in Endurance
    if not BigWigsContributeFlag then
        for i=1, table.getn(listOfRaidZones) do
            local area = AceLibrary("Babble-Zone-2.2")[listOfRaidZones[i]]
            if area and area == GetRealZoneText() then
                --if (GetGuildInfo("player") == nil) or (not GetGuildInfo("player") == "improved") then
                    BigWigs:Print(L["This |cf75DE52fClassic-WoW|r Version was made by |cff7f7fffDorann|r."])
                --end
                if "Nefarian" ~= GetRealmName() then
                    BigWigs:Print(L["This version of BigWigs is |cffff0000not intended for your realm|r. Please be aware that |cffff0000timers might be wrong or not working at all|r."])    
                end
                
                BigWigsContributeFlag = true
				break
            end
        end
    end
    
    -- check for unsupported raids
    if not footageRequested then
        for i=1, table.getn(unsupportedRaids) do
            local area = AceLibrary("Babble-Zone-2.2")[unsupportedRaids[i]]
            if area and area == GetRealZoneText() then
                BigWigs:Print(L["This addon is still work in progress and content is adjusted by |cff7f7fffDorann|r. Check for Updates or help by providing twitch/youtube footage on https://github.com/xorann/BigWigs/releases "])
                footageRequested = true
				break
            end
        end
    end
end