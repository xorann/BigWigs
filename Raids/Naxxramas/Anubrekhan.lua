
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "CheckForLocustCast")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckForLocustCast")
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
		self:Message(L["enragewarn"], "Important", nil, "Alarm")
	end
end

function module:CheckForLocustCast(msg)
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

-- called when anub'rekhan casts locust swarm
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
		--self:WarningSign(icon.locust, 5)
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

function module:Test(long)
    -- /run local m=BigWigs:GetModule("Anub'Rekhan");m:Test()
    
	local function testLocustSwarmCast()
		module:CheckForLocustCast(L["casttrigger"])
    end
	local function testLocustSwarmGain()
		module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["gaintrigger"])
	end
	local function testEnrage()
		module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["etrigger"])
	end
	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(module:ToString())
	end
	
	if long then
		local testTimer = 0
		-- long test
		self:SendEngageSync()
		
		-- first locust swarm cast
		testTimer = testTimer + timer.firstLocustSwarm
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmCast1", testLocustSwarmCast, testTimer, self)
		BigWigs:Print("testLocustSwarmCast in " .. testTimer)
		
		-- first locust swarm gain
		testTimer = testTimer + timer.locustSwarmCastTime
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmGain1", testLocustSwarmGain, testTimer, self)
		BigWigs:Print("testLocustSwarmGain in " .. testTimer)
		
		-- enrage
		self:ScheduleEvent(self:ToString() .. "testEnrage1", testEnrage, 90, self)
		BigWigs:Print("testEnrage in " .. 90)
		
		-- second locust swarm cast
		testTimer = testTimer + timer.locustSwarmInterval
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmCast2", testLocustSwarmCast, testTimer, self)
		BigWigs:Print("testLocustSwarmCast in " .. testTimer)

		-- second locust swarm gain
		testTimer = testTimer + timer.locustSwarmCastTime
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmGain2", testLocustSwarmGain, testTimer, self)
		BigWigs:Print("testLocustSwarmGain in " .. testTimer)
		
		-- wipe
		testTimer = testTimer + 10
		self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
		BigWigs:Print("testDisable in " .. testTimer)
	else
		-- short test
		local testTimer = 0
		self:SendEngageSync()
		
		-- first locust swarm cast
		testTimer = testTimer + 5
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmCast1", testLocustSwarmCast, testTimer, self)
		BigWigs:Print("testLocustSwarmCast in " .. testTimer)
		
		-- first locust swarm gain
		testTimer = testTimer + timer.locustSwarmCastTime
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmGain1", testLocustSwarmGain, testTimer, self)
		BigWigs:Print("testLocustSwarmGain in " .. testTimer)
		
		-- enrage
		self:ScheduleEvent(self:ToString() .. "testEnrage1", testEnrage, 10, self)
		BigWigs:Print("testEnrage in " .. 10)
		
		-- second locust swarm cast
		testTimer = testTimer + 25
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmCast2", testLocustSwarmCast, testTimer, self)
		BigWigs:Print("testLocustSwarmCast in " .. testTimer)

		-- second locust swarm gain
		testTimer = testTimer + timer.locustSwarmCastTime
		self:ScheduleEvent(self:ToString() .. "testLocustSwarmGain2", testLocustSwarmGain, testTimer, self)
		BigWigs:Print("testLocustSwarmGain in " .. testTimer)
		
		-- wipe
		testTimer = testTimer + 5
		self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
		BigWigs:Print("testDisable in " .. testTimer)
	end
end

