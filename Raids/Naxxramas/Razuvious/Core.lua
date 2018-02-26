------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.razuvious
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
--local understudy = AceLibrary("Babble-Boss-2.2")["Deathknight Understudy"]
local understudy = L["misc_understudy"]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = {understudy} -- adds which will be considered in CheckForEngage
module.toggleoptions = {"shout", "unbalance", "shieldwall", "bosskill"}


-- locals
module.timer = {
	firstShout = 20,
	shout = 25,
	noShoutDelay = 5,
	unbalance = 30,
	shieldwall = 20,
}
local timer = module.timer

module.icon = {
	shout = "Ability_Warrior_WarCry",
	unbalance = "Ability_Warrior_DecisiveStrike",
	shieldwall = "Ability_Warrior_ShieldWall",
}
local icon = module.icon

module.syncName = {
	shout = "RazuviousShout",
	shieldwall = "RazuviousShieldwall",
	unbalance = "RazuviousUnbalance"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.shout then
		self:Shout()
	elseif sync == syncName.shieldwall then
		self:Shieldwall()
	elseif sync == syncName.unbalance then
		self:Unbalance()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Shout()
	self:CancelScheduledEvent("bwrazuviousnoshout")
	self:ScheduleEvent("bwrazuviousnoshout", self.NoShout, timer.shout + timer.noShoutDelay, self)		
	
	if self.db.profile.shout then
		self:Message(L["msg_shoutNow"], "Attention", nil, "Alarm")
		self:DelayedMessage(timer.shout - 7, L["msg_shout7"], "Urgent")
		self:DelayedMessage(timer.shout - 3, L["msg_shout3"], "Urgent")
		self:Bar(L["bar_shout"], timer.shout, icon.shout)
	end
end

function module:Shieldwall()
	if self.db.profile.shieldwall then
		self:Bar(L["bar_shieldWall"], timer.shieldwall, icon.shieldwall)
	end
end

function module:Unbalance()
	if self.db.profile.unbalance then
		self:Message(L["msg_unbalanceNow"], "Urgent")
		self:DelayedMessage(timer.unbalance - 5, L["msg_unbalanceSoon"], "Urgent")
		self:Bar(L["bar_unbalance"], timer.unbalance, icon.unbalance)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:NoShout()	
	module:Unbalance()
	module:Shieldwall()
	module:Shout()
	
	module:BigWigs_RecvSync(syncName.shout)
	module:BigWigs_RecvSync(syncName.shieldwall)
	module:BigWigs_RecvSync(syncName.unbalance)
end
