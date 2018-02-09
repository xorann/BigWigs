--[[
    by Dorann
    Equips Onyxias Cloak when you enter Nefarian's Lair and switches back when you leave the area again
--]]


assert( BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------
local L = AceLibrary("AceLocale-2.2"):new("BigWigsOnyxiaCloak")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
    ["Onyxias Cloak"] = true, -- plugin name
    ["onyxiaCloak"] = true, -- console command
    ["Equips Onyxias Cloak when you enter Nefarian's Lair and switches back when you leave the area again."] = true,
    ["Active"] = true, -- option name
    ["Activate the plugin."] = true, -- option description
	["Onyxia Scale Cloak"] = true, -- item name
	["Could not find %s"] = true,
	["Equipping %s"] = true, 
	trigger_engage = "In this world where time is your enemy, it is my greatest ally.", -- nefarian yell before the fight starts
} end)

L:RegisterTranslations("deDE", function() return {
    ["Onyxias Cloak"] = "Onyxiaschuppenumhang", -- plugin name
    --["onyxiaCloak"] = true, -- console command
    ["Equips Onyxias Cloak when you enter Nefarian's Lair and switches back when you leave the area again."] = "Zieht automatisch den Onyxiaschuppenumhang an sobald Nefarian's Lair betreten wird und wechselt wieder zurück wenn das Gebiet verlassen wird.",
    ["Active"] = "Aktiv", -- option name
    ["Activate the plugin."] = "Aktiviert das Plugin.", -- option description
	["Onyxia Scale Cloak"] = "Onyxiaschuppenumhang", -- item name
	["Could not find %s"] = "Konnte %s nicht finden",
	["Equipping %s"] = "Ziehe %s an", 
	trigger_engage = "In dieser Welt, in der die Zeit Euer Feind ist", -- nefarian yell before the fight starts
} end)

----------------------------------
--      Module Declaration      --
----------------------------------
BigWigsOnyxiaCloak = BigWigs:NewModule(L["Onyxias Cloak"])
BigWigsOnyxiaCloak.revision = 20015
BigWigsOnyxiaCloak.external = true

BigWigsOnyxiaCloak.defaultDB = {
    active = true,
	defaultCloak = nil,
}
BigWigsOnyxiaCloak.consoleCmd = L["onyxiaCloak"]

BigWigsOnyxiaCloak.consoleOptions = {
	type = "group",
	name = L["Onyxias Cloak"],
	desc = L["Equips Onyxias Cloak when you enter Nefarian's Lair and switches back when you leave the area again."],
	args   = {
        active = {
			type = "toggle",
			name = L["Active"],
			desc = L["Activate the plugin."],
			order = 1,
			get = function() return BigWigsOnyxiaCloak.db.profile.active end,
			set = function(v) BigWigsOnyxiaCloak.db.profile.active = v end,
			--passValue = "reverse",
		}
	}
}


------------------------------
--      Initialization      --
------------------------------
function BigWigsOnyxiaCloak:OnEnable()
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    self:RegisterEvent("ZONE_CHANGED")
    self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local function IdFromLink(itemlink)
	if itemlink then
		local _,_,id = string.find(itemlink, "|Hitem:([^:]+)%:")
		return tonumber(id)
	end
	
	return nil	
end

local function GetItemInfo(pItemLink)
	if pItemLink then
		local vStartIndex, vEndIndex, color, itemId, enchantCode, itemSubId, unknownCode, itemName = 
			strfind(pItemLink, "|(%x+)|Hitem:(%d+):(%d+):(%d+):(%d+)|h%[([^%]]+)%]|h|r");
			
		local itemInfo = {
			color = color,
			itemId = itemId,
			enchantCode = enchantCode,
			itemSubId = itemSubId,
			name = itemName,
		}
	
		return itemInfo
	end
	
	return nil
end

local function GetNameOfCurrentCloak()
	local pItemLink = GetInventoryItemLink("player", 15)
	local itemInfo = GetItemInfo(pItemLink)
	
	if itemInfo then
		return itemInfo.name
	end
	
	return nil
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local ecTooltip
local function IsSoulbound(bag, slot)
	-- don't initialize twice
	ecTooltip = ecTooltip or CreateFrame( "GameTooltip", "ecTooltip", nil, 
		"GameTooltipTemplate" )
	ecTooltip:AddFontStrings(
		ecTooltip:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
		ecTooltip:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" ), 
		ecTooltip:CreateFontString( "$parentTextLeft2", nil, "GameTooltipText" ),
		ecTooltip:CreateFontString( "$parentTextRight2", nil, "GameTooltipText" ) 
	);	
	-- make tooltip "hidden"
	ecTooltip:SetOwner( WorldFrame, "ANCHOR_NONE" );

	ecTooltip:ClearLines()
	ecTooltip:SetBagItem(bag, slot)		
		
	return (ecTooltipTextLeft2:GetText() == ITEM_SOULBOUND)
end

-- https://github.com/Numielle/EasyCloak/blob/master/EasyCloakMain.lua
local function FindItem(name)
	local bagIdx, slotIdx 
	
	for bag = 0, 4 do		
		for slot = 1,GetContainerNumSlots(bag) do			
			local itemLink = GetContainerItemLink(bag, slot)		
			local itemInfo = GetItemInfo(itemLink)
			
			if itemInfo and itemInfo.name == name then				
				if IsSoulbound(bag, slot) then 
					-- this is definitely the right item
					return bag, slot
				else 
					-- keep looking for soulbound cloak, store values
					bagIdx, slotIdx = bag, slot
				end				
			end				
		end
	end
		
	return bagIdx, slotIdx
end

local function EquipItem(itemName)
	if itemName then
		local bag, slot = FindItem(itemName)
	
		if not (bag and slot) then
			BigWigs:Print(string.format(L["Could not find %s"], itemName))
			return
		end
		
		-- put previously selected item back
		if CursorHasItem() then 
			ClearCursor()
		end 
		
		-- pickup and equip ony scale cloak
		PickupContainerItem(bag, slot)
		AutoEquipCursorItem()
		
		BigWigs:Print(string.format(L["Equipping %s"], itemName))
	end
end
------------------------------
--      Event Handlers      --
------------------------------
function BigWigsOnyxiaCloak:ZONE_CHANGED_NEW_AREA()
	BigWigs:DebugMessage("ZONE_CHANGED_NEW_AREA")
end
function BigWigsOnyxiaCloak:ZONE_CHANGED()
	BigWigs:DebugMessage("ZONE_CHANGED")
end
function BigWigsOnyxiaCloak:ZONE_CHANGED_INDOORS()
	BigWigs:DebugMessage("ZONE_CHANGED_INDOORS")
	if self.db.profile.active then
        if AceLibrary("Babble-Zone-2.2")["Nefarian's Lair"] == GetSubZoneText() then
            BigWigs:DebugMessage("Nefarian's Lair")
			self.db.profile.defaultCloak = GetNameOfCurrentCloak()
            EquipItem(L["Onyxia Scale Cloak"])
        else
			BigWigs:DebugMessage("not Nefarian's Lair")
            if GetNameOfCurrentCloak() == L["Onyxia Scale Cloak"] then
                EquipItem(self.db.profile.defaultCloak)
            end
        end
    end
end

function BigWigsOnyxiaCloak:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.active and string.find(msg, L["trigger_engage"]) then
		local currentCloak = GetNameOfCurrentCloak()
		if currentCloak ~= L["Onyxia Scale Cloak"] then
			self.db.profile.defaultCloak = currentCloak
			EquipItem(L["Onyxia Scale Cloak"])
		end
	end
end
