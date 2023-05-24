--[[
    by Dorann
    Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again
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
    ["Onyxia Scale Cloak"] = true, -- plugin name
    ["onyxiaCloak"] = true, -- console command
    ["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."] = true,
    ["Active"] = true, -- option name
    ["Activate the plugin."] = true, -- option description
	["Onyxia Scale Cloak"] = true, -- item name
	["Could not find %s"] = true,
	["Equipping %s"] = true, 
	trigger_engage = "In this world where time is your enemy, it is my greatest ally.", -- nefarian yell before the fight starts
	["Nefarians Lair"] = true,
} end)

L:RegisterTranslations("ruRU", function() return {
	["Onyxia Scale Cloak"] = "Плащ из чешуи Ониксии", -- plugin name
	-- ["onyxiaCloak"] = "onyxiaCloak", -- console command
	["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."] = "Надевает плащ из чешуи Ониксии, когда вы входите в Логово Нефариана, и переключается обратно, когда вы снова покидаете область.", -- Логово Крыла Тьмы
	["Active"] = "Включить", -- option name
	["Activate the plugin."] = "Включить плагин", -- option description
	["Onyxia Scale Cloak"] = "Плащ из чешуи Ониксии", -- item name
	["Could not find %s"] = "Не могу найти %s",
	["Equipping %s"] = "Экипирую %s", 
	trigger_engage = "В этом мире, где время – ваш враг, оно – мой величайший союзник.", -- nefarian yell before the fight starts -- script_texts --vmangos\locales_broadcast_text\9907
	["Nefarians Lair"] = "Логово Нефариана",
} end)

L:RegisterTranslations("deDE", function() return {
    ["Onyxia Scale Cloak"] = "Onyxiaschuppenumhang", -- plugin name
    --["onyxiaCloak"] = true, -- console command
    ["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."] = "Zieht automatisch den Onyxiaschuppenumhang an sobald Nefarians Unterschlupf betreten wird und wechselt wieder zurück wenn das Gebiet verlassen wird.",
    ["Active"] = "Aktiv", -- option name
    ["Activate the plugin."] = "Aktiviert das Plugin.", -- option description
	["Onyxia Scale Cloak"] = "Onyxiaschuppenumhang", -- item name
	["Could not find %s"] = "Konnte %s nicht finden",
	["Equipping %s"] = "Ziehe %s an", 
	trigger_engage = "In dieser Welt, in der die Zeit Euer Feind ist", -- nefarian yell before the fight starts
	["Nefarians Lair"] = "Nefarians Unterschlupf",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------
BigWigsOnyxiaCloak = BigWigs:NewModule(L["Onyxia Scale Cloak"])
BigWigsOnyxiaCloak.revision = 20015
BigWigsOnyxiaCloak.external = true

BigWigsOnyxiaCloak.defaultDB = {
    active = true,
	defaultCloak = nil,
}
BigWigsOnyxiaCloak.consoleCmd = L["onyxiaCloak"]

BigWigsOnyxiaCloak.consoleOptions = {
	type = "group",
	name = L["Onyxia Scale Cloak"],
	desc = L["Equips Onyxia Scale Cloak when you enter Nefarians Lair and switches back when you leave the area again."],
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

BigWigsOnyxiaCloak.automaticallyEquipped = false

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

function BigWigsOnyxiaCloak:EquipOnyCloak()
	self.db.profile.defaultCloak = GetNameOfCurrentCloak()
	if GetNameOfCurrentCloak() ~= L["Onyxia Scale Cloak"] then
		EquipItem(L["Onyxia Scale Cloak"])
		BigWigsOnyxiaCloak.automaticallyEquipped = true
	end
end

function BigWigsOnyxiaCloak:UnequipOnyCloak()
	if GetNameOfCurrentCloak() == L["Onyxia Scale Cloak"] then
		if GetNameOfCurrentCloak() ~= self.db.profile.defaultCloak and BigWigsOnyxiaCloak.automaticallyEquipped then
			EquipItem(self.db.profile.defaultCloak)
			BigWigsOnyxiaCloak.automaticallyEquipped = false
		end
	end
end

------------------------------
--      Event Handlers      --
------------------------------
function BigWigsOnyxiaCloak:ZONE_CHANGED_NEW_AREA()
	BigWigs:DebugMessage("ZONE_CHANGED_NEW_AREA")
	if self.db.profile.active then
		if AceLibrary("Babble-Zone-2.2")["Blackwing Lair"] ~= GetZoneText() then
			BigWigs:DebugMessage("not Blackwing Lair")
			BigWigsOnyxiaCloak:UnequipOnyCloak()
		end
	end
end
function BigWigsOnyxiaCloak:ZONE_CHANGED()
	BigWigs:DebugMessage("ZONE_CHANGED")
	if self.db.profile.active then
		if AceLibrary("Babble-Zone-2.2")["Blackwing Lair"] ~= GetZoneText() then
			BigWigs:DebugMessage("not Blackwing Lair")
			BigWigsOnyxiaCloak:UnequipOnyCloak()
		end
	end
end
function BigWigsOnyxiaCloak:ZONE_CHANGED_INDOORS()
	BigWigs:DebugMessage("ZONE_CHANGED_INDOORS [" .. GetSubZoneText() .. "]")
	if self.db.profile.active then
        --if AceLibrary("Babble-Zone-2.2")["Nefarians Lair"] == GetSubZoneText() then -- some wierd bug??
		if (GetLocale() == "enUS" and string.find(GetSubZoneText(), "Nefarian.*Lair")) 
			or (L["Nefarians Lair"] == GetSubZoneText())
		then
            BigWigs:DebugMessage("Nefarians Lair")
			BigWigsOnyxiaCloak:EquipOnyCloak()
        else
			BigWigs:DebugMessage("not Nefarians Lair")
            BigWigsOnyxiaCloak:UnequipOnyCloak()
        end
    end
end

function BigWigsOnyxiaCloak:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.active and string.find(msg, L["trigger_engage"]) then
		BigWigsOnyxiaCloak:EquipOnyCloak()
	end
end
