--[[

Big Wigs Strategy Module for Loatheb in Naxxramas.
Adds warning messages, whispers and raid icons for the groups that are next in line to get Spore

visit us at http://www.caelum.ws

Rework by Dorann
https://github.com/xorann/BigWigs

]]


local myname = "Loatheb Tactical"
local bossName = "Loatheb"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..myname)
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local module = BigWigs:NewModule(myname)
module.bossSync = myname
module.synctoken = myname
module.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
module.translatedName = boss
module.external = true


----------------------------------
--      Module Declaration      --
----------------------------------

--local module, L = BigWigs:ModuleDeclaration("Loatheb Tactical", "Naxxramas")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "BigWigsLoathebTactical",
	
	noconsumable_cmd = "consumable",
	noconsumable_name = "Do NOT warn raid to use consumables (A)",
	noconsumable_desc = "When checked does NOT warn raid to use consumables over raidwarn. Requires Assistance (A)",
	
	nospore_cmd = "spore",
	nospore_name = "Do NOT warn for Spores (A)",
	nospore_desc = "When checked does NOT mark players to get the spore buff. Requires Assistance (A)",
	
	doomtrigger = "afflicted by Inevitable Doom.",
	
	shadowpot = "Drink Shadow Protection Potion!",
	bandage = "Use your bandages!",
	healthstone = "Healthstone or Whipper Root Tuber!",
	shadowpotandbandage = "Drink Shadow Protection Potion and use a Bandage!",
	noconsumable = "No Consumable at this time!",
	
	groupspore = "Spore for Group %s",
	
	enablewarning = "|cffff8888BigWigs Loatheb Tactical|r - Announces recommended consumable usage and marks groups for spores with raid icons beginning with group 2. Both options have to be activated manually.",
	
	["Greater Shadow Protection Potion"] = true,
	["Heavy Runecloth Bandage"] = true,
	["Greater Healthstone"] = true,
    ["Could not find %s in your inventory."] = true,
} end )

L:RegisterTranslations("deDE", function() return {
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20011 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"noconsumable", "nospore"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false


-- locals
local timer = {
	consumable = 5,
	firstSpore = 8,
	spore = 12,
	sporeMark = 12,
	doom = 10,
}
local icon = {
	pot = "INV_Potion_23",
	bandage = "INV_Misc_Bandage_12",
	healthstone = "INV_Stone_04",
}
local syncName = {
	doom = "LoathebTacticalDoom",
}

local numDoom = 0
local numSpore = 0

-- timing -------------------2:10-------------2:40------------3:10---------3:40--------------4:10---------------4:40--------------5:10-----------5:25-------------5:40
-- after 5 minutes doom comes every 15seconds
local consumablelist = {
	L["Greater Shadow Protection Potion"],
	nil,
	L["Heavy Runecloth Bandage"],
	L["Greater Healthstone"],
	L["Greater Shadow Protection Potion"],
	nil,
	L["Heavy Runecloth Bandage"],
	nil,
	L["Greater Healthstone"],
}

local warninglist = {
	L["shadowpot"],				-- 1. 2:10
	L["noconsumable"],			-- 2. 2:40
	L["bandage"],				-- 3. 3:10
	L["healthstone"],			-- 4. 3:40
	L["shadowpotandbandage"],	-- 5. 4:10
	L["noconsumable"],			-- 6. 4:40
	L["bandage"],				-- 7. 5:10
	L["noconsumable"],			-- 8. 5:25
	L["healthstone"]			-- 9. 5:40
}

local iconlist = {
	icon.pot,
	nil,
	icon.bandage,
	icon.healthstone,
	icon.pot,
	nil,
	icon.bandage,
	nil,
	icon.healthstone
}

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "DoomEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "DoomEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "DoomEvent")
	
	BigWigs:Print(L["enablewarning"])
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	numDoom = 0
	numSpore = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:ScheduleEvent("bwloathebtacticalspore", self.Spore, timer.firstSpore, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers	    --
------------------------------

function module:DoomEvent(msg)
	if string.find(msg, L["doomtrigger"]) then
		self:Sync(syncName.doom .. " " .. tostring(numDoom + 1))
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.doom then
		self:Doom(rest)
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Doom(syncNumDoom)
	syncNumDoom = tonumber(syncNumDoom)
    
	if syncNumDoom then
		if syncNumDoom == (numDoom + 1) then
			numDoom = numDoom + 1
			self:ConsumableWarning(numDoom)
			--self:ScheduleEvent("bwloathebtacticaldoom", self.ConsumableWarning, timer.doom, self, numDoom)
		end
	end
end

------------------------------
--      Utility	Functions   --
------------------------------

function module:ConsumableWarning(numDoom)
	if not self.db.profile.noconsumable then
		if warninglist[numDoom] then
			self:Message(warninglist[numDoom], "Important")
			--self:Say(warninglist[numDoom])
		end
		
		if iconlist[numDoom] then
			self:WarningSign(iconlist[numDoom], timer.consumable)
			self:WarningSignOnClick(self.UseConsumable, numDoom)
		end
	end
end

function module:Spore()
	numSpore = numSpore + 1
	local iconnumber = 2
    
	if not self.db.profile.nospore then
		local group = math.mod(numSpore, 8) + 1 -- begin with group 2
		
		-- warning
		self:Message(string.format(L["groupspore"], group), "Positive")
		
		-- mark players
		for i = 1, GetNumRaidMembers(), 1 do
			local name, _, subgroup = GetRaidRosterInfo(i)
			if subgroup == group then
				self:Icon(name, iconnumber, timer.sporeMark)
				iconnumber = iconnumber + 1
			end
		end
	end
	
	self:ScheduleEvent("bwloathebtacticalspore", self.Spore, timer.sporeMark, self)
end

function module:UseContainerItemByName(name)
	local function GetUnitId()
		local player = UnitName("player")
		local unitId = nil
		
		for i = 1, GetNumRaidMembers(), 1 do
			unitId = "Raid" .. i
			if UnitName(unitId) == player then
				break;
			end
		end
		
		return unitId
	end	
    
    local used = false
    for bag = 0,4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = GetContainerItemLink(bag, slot)
            if item and string.find(item, name) then
                if name == L["Heavy Runecloth Bandage"] then
                    -- avoid changing target. otherwise rogues lose their combo points
                    if UnitIsFriend("player", "target") then
                        UseContainerItem(bag, slot, 1)
                    else
                        UseContainerItem(bag, slot)
                        if SpellIsTargeting() then
                            local unitId = GetUnitId()
                            if unitId then
                                SpellTargetUnit(unitId)
                                used = true
                            end
                        end
                    end
                else 
                    UseContainerItem(bag, slot)
                    used = true
                end
                break
            end
        end
        if used then 
            break
        end
    end
    
    if not used then
        BigWigs:Print(string.format(L["Could not find %s in your inventory."], name))
end
function module:UseConsumable()
	--[[local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bagID, slotID)
	local ItemLink = GetContainerItemLink(bagID, slotID)
	local numberOfSlots = GetContainerNumSlots(bagID)
	UseContainerItem(bagID, slot[, onSelf])]]
    
	local consumable = consumablelist[numDoom]
	if consumable then
		module:UseContainerItemByName(consumable)
	end
end

----------------------------------
--      Module Test Function    --
----------------------------------

-- /run local m=BigWigs:GetModule("Loatheb Tactical");m.core:EnableModule(m:ToString())m:TestConsumables()
function module:TestConsumables()
	local consumable = timer.consumable
	local doom = timer.doom
    local firstSpore = timer.firstSpore
	timer.consumable = 0.8
	timer.doom = 1
    timer.firstSpore = 99
	
	local function triggerDoom()
		self:DoomEvent(L["doomtrigger"])
	end
	local function deactivate()
        BigWigs:Print(self:ToString().."Test deactivated")
        self.core:DisableModule(self:ToString())
		timer.consumable = consumable
		timer.doom = doom
        timer.firstSpore = firstSpore
    end
    
	BigWigs:Print(self:ToString() .. " TestConsumables started")
    BigWigs:Print("  doom every 2s")
    BigWigs:Print("  deactivate after 20s")
	
    -- immitate CheckForEngage
    self:SendEngageSync()
	
	-- doom every 2s
	self:ScheduleRepeatingEvent(self:ToString().."Test_doom", triggerDoom, 1, self)
	
    -- reset after 15s
    self:ScheduleEvent(self:ToString().."Test_deactivate", deactivate, 10, self)
end

-- /run local m=BigWigs:GetModule("Loatheb Tactical");m.core:EnableModule(m:ToString());m:TestSpore()
function module:TestSpore()
	local firstSpore = timer.firstSpore
	local sporeMark = timer.sporeMark
	timer.firstSpore = 1
	timer.sporeMark = 3
	
	local function deactivate()
        self.core:DisableModule(self:ToString())
		timer.firstSpore = firstSpore
		timer.sporeMark = sporeMark
        BigWigs:Print(self:ToString().."Test deactivated")
    end
	
	BigWigs:Print(self:ToString() .. " TestSpore started")
    BigWigs:Print("  deactivate after 15s")
	
	-- immitate CheckForEngage
    self:SendEngageSync()
	
	-- reset after 15s
    self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 15, self)
end