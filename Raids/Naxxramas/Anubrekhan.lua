
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Anub'Rekhan", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Anubrekhan",

	locust_cmd = "locust",
	locust_name = "Locust Swarm Alert",
	locust_desc = "Warn for Locust Swarm",

	enrage_cmd = "enrage",
	enrage_name = "Crypt Guard Enrage Alert",
	enrage_desc = "Warn for Enrage",

	starttrigger1 = "Just a little taste...",
	starttrigger2 = "Yes, run! It makes the blood pump faster!",
	starttrigger3 = "There is no way out.",
	engagewarn = "Anub'Rekhan engaged. First Locust Swarm in ~60 sec",
	
	etrigger = "gains Enrage.",
	enragewarn = "Crypt Guard Enrage - Stun + Traps!",
	
	gaintrigger = "Anub'Rekhan gains Locust Swarm.",
	gainendwarn = "Locust Swarm ended!",
	gainnextwarn = "Next Locust Swarm in ~60 sec",
	gainwarn10sec = "~10 Seconds until Locust Swarm",
	gainincbar = "Next Locust Swarm",
	gainbar = "Locust Swarm",

	casttrigger = "Anub'Rekhan begins to cast Locust Swarm.",
	castwarn = "Incoming Locust Swarm!",

} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"locust", "enrage", "bosskill"}


-- locals
local timer = {
	firstLocustSwarm = 75,
    locustSwarmInterval = 60,
    locustSwarmDuration = 20,
    locustSwarmCastTime = 3.25,
}
local icon = {
	locust = "Spell_Nature_InsectSwarm",
}
local syncName = {
	locustCast = "AnubLocustInc",
	locustGain = "AnubLocustSwarm",
}

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["starttrigger1"])
module:RegisterYellEngage(L["starttrigger2"])
module:RegisterYellEngage(L["starttrigger3"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "LocustCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "LocustCast")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")

	self:ThrottleSync(10, syncName.locustCast)
	self:ThrottleSync(10, syncName.locustGain)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
end

-- called after boss is engaged
function module:OnEngage()
	self:Message(L["engagewarn"], "Urgent")
	self:DelayedMessage(timer.firstLocustSwarm - 10, L["gainwarn10sec"], "Important")
	self:Bar(L["gainincbar"], timer.firstLocustSwarm, icon.locust)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["gaintrigger"] then
		self:Sync(syncName.locustGain)
	elseif msg == L["etrigger"] then
		self:Message(L["enragewarn"], "Alert", nil, "Alarm")
	end
end

function module:LocustCast(msg)
	if string.find(msg, L["casttrigger"]) then
		self:Sync(syncName.locustCast)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.locustCast then
		self:LocustCast()
	elseif sync == syncName.locustGain then
		self:LocustGain()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

-- called when anub'rekhan cast locust swarm
function module:LocustCast()
	--self:ScheduleEvent("bwanublocustinc", self.TriggerEvent, timer.locustSwarmCastTime, self, "BigWigs_SendSync", syncName.locustGain)
	if self.db.profile.locust then
		self:Message(L["castwarn"], "Orange", nil, "Beware")
		self:WarningSign(icon.locust, timer.locustSwarmCastTime)
		self:Bar(L["castwarn"], timer.locustSwarmCastTime, icon.locust )
	end
end

-- called when casting locust swarm is over and anub'rekhan gained the buff/aura
function module:LocustGain()
	--self:CancelScheduledEvent("bwanublocustinc")
	if self.db.profile.locust then
		self:WarningSign(icon.locust, 5)
		--self:DelayedMessage(timer.locustSwarmDuration, L["gainendwarn"], "Important")
		self:Bar(L["gainbar"], timer.locustSwarmDuration, icon.locust)
		self:Message(L["gainnextwarn"], "Urgent")
		self:DelayedMessage(timer.locustSwarmInterval - 10, L["gainwarn10sec"], "Important")
		self:Bar(L["gainincbar"], timer.locustSwarmInterval, icon.locust)
	end
end


----------------------------------
--      Module Test Function    --
----------------------------------

function module:Test()
    self:SendEngageSync()
    --self:LocustCast(L["casttrigger"])
    --self:ScheduleEvent(self:ToString().."Test_Locust", self.LocustCast(L["casttrigger"]), 5, self)
    self:DelayedSync(5, syncName.locustCast)
end

