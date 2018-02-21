local bossName = BigWigs.bossmods.naxx.anubrekhan
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

timer.firstLocustSwarm = {
	min = 90, -- week1: 96s
	max = 120
}
timer.locustSwarmInterval = {
	min = 90, -- week1: 103,112,105,102
	max = 120
}

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])

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
end

-- called after boss is engaged
function module:OnEngage()
	--self:DelayedMessage(timer.firstLocustSwarm - 10, L["msg_locustSwarmSoon"], "Important")
	self:Bar(L["bar_locustSwarmNext"], timer.firstLocustSwarm, icon.locust)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_locustSwarm"] then
		self:Sync(syncName.locustGain)
	elseif msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	end
end

function module:CheckForLocustCast(msg)
	if string.find(msg, L["trigger_locustSwarmCast"]) then
		self:Sync(syncName.locustCast)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_locustSwarm"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CheckForLocustCast(L["trigger_locustSwarmCast"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)
	-- /run local m=BigWigs:GetModule("Anub'Rekhan");m:Test()
    
	local function testLocustSwarmCast()
		module:CheckForLocustCast(L["trigger_locustSwarmCast"])
    end
	local function testLocustSwarmGain()
		module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_locustSwarm"])
	end
	local function testEnrage()
		module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
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
