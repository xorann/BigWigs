------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.anubrekhan
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"locust", "enrage", "bosskill"}


-- locals
module.timer = {
	firstLocustSwarm = 89.7,
    locustSwarmInterval = 85, -- 85 - 95s
    locustSwarmDuration = 20,
    locustSwarmCastTime = 3, -- should be 3.25s
}
local timer = module.timer

module.icon = {
	locust = "Spell_Nature_InsectSwarm",
}
local icon = module.icon

module.syncName = {
	locustCast = "AnubLocustInc",
	locustGain = "AnubLocustSwarm",
	enrage = "AnubEnrage",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.locustCast then
		self:LocustCast()
	elseif sync == syncName.locustGain then
		self:LocustGain()
	elseif sync == syncName.enrage then
		self:Enrage()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
-- called when anub'rekhan casts locust swarm
function module:LocustCast()    
    --self:ScheduleEvent("bwanublocustinc", self.TriggerEvent, timer.locustSwarmCastTime, self, "BigWigs_SendSync", syncName.locustGain)
	if self.db.profile.locust then
        -- remove old bar
        self:RemoveBar(L["bar_locustSwarmNext"])
        
        -- add cast bar
		self:Message(L["msg_locustSwarmNow"], "Orange", nil, "Beware")
		self:WarningSign(icon.locust, timer.locustSwarmCastTime)
		self:Bar(L["bar_locustSwarmCast"], timer.locustSwarmCastTime, icon.locust )
	end
end

-- called when casting locust swarm is over and anub'rekhan gained the buff/aura
function module:LocustGain()
	--self:CancelScheduledEvent("bwanublocustinc")    
	if self.db.profile.locust then
		--self:WarningSign(icon.locust, 5)
		--self:DelayedMessage(timer.locustSwarmDuration, L["msg_locustSwarmGone"], "Important")
		self:Bar(L["bar_locustSwarmDuration"], timer.locustSwarmDuration, icon.locust)
		self:Message(L["msg_locustSwarmNext"], "Urgent")
		--self:DelayedMessage(timer.locustSwarmInterval - 10, L["msg_locustSwarmSoon"], "Important")
		self:Bar(L["bar_locustSwarmNext"], timer.locustSwarmInterval, icon.locust)
	end
end

function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important", nil, "Alarm")
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:LocustCast()
	module:LocustGain()
	
	module:BigWigs_RecvSync(syncName.locustCast)
	module:BigWigs_RecvSync(syncName.locustGain)
end
