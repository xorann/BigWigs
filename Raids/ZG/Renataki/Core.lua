------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.renataki
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"vanish", "enraged", "bosskill"}


-- locals
module.timer = {
	vanishSoon = 22,
	unvanish = 30,
}
local timer = module.timer

module.icon = {
	vanish = "Ability_Stealth",
}
local icon = module.icon

module.syncName = {
	unvanish = "RenatakiUnvanish",
	enrage = "RenatakiEnrage",
	enrageSoon = "RenatakiEnrageSoon",
}
local syncName = module.syncName


module.enrageannounced = nil
module.vanished = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.enrageSoon and self.db.profile.enraged then
		self:Message(L["msg_enrageSoon"], "Urgent")
	elseif sync == syncName.enrage and self.db.profile.enraged then
		self:Message(L["msg_enrageNow"], "Attention")
	elseif sync == syncName.unvanish then
		module.vanished = nil
		if self.db.profile.vanish then
			self:RemoveBar(L["bar_vanish"])
			self:Message(L["msg_unvanish"], "Attention")
			self:DelayedMessage(timer.vanishSoon, L["msg_vanishSoon"], "Urgent")
		end
		self:ScheduleRepeatingEvent("renatakivanishcheck", self.VanishCheck, 2, self)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------


------------------------------
--      Utility	Functions   --
------------------------------
function module:IsVanished()
	module.vanished = true
	self:CancelScheduledEvent("renatakivanishcheck")
	if self.db.profile.vanish then
		self:Message(L["msg_vanishNow"], "Attention")
		self:Bar(L["bar_vanish"], timer.unvanish, icon.vanish)
	end
	self:ScheduleRepeatingEvent("renatakiunvanishcheck", self.UnvanishCheck, 2, self)
	self:ScheduleEvent(syncName.unvanish, self.Unvanish, timer.unvanish, self)
end

function module:UnvanishCheck()
	if UnitExists("target") and UnitName("target") == "Renataki" and UnitExists("targettarget") then
		if module.vanished then
			module.vanished = nil
			self:Unvanish()
			return
		end
	end
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitName(raidUnit) == "Renataki" and UnitExists(raidUnit.."target") then
			if module.vanished then
				module.vanished = nil
				self:Unvanish()
				return
			end
		end
	end
end

function module:VanishCheck()
	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitClassification(raidUnit) == "worldboss" and UnitName(raidUnit) == self.translatedName and UnitExists(raidUnit.."target") then
			if module.vanished then
				module.vanished = nil
			end
			return
		end
	end
	self:IsVanished()
end

function module:Unvanish()
	self:CancelScheduledEvent("renatakiunvanishcheck")
	self:CancelScheduledEvent("renatakiunvanish")
	self:Sync(syncName.unvanish)
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.enrageSoon)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.unvanish)
end
