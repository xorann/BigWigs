local bossName = BigWigs.bossmods.naxx.heigan
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)


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


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])

-- called after module is enabled
function module:OnEnable()	
	self:CombatlogFilter(L["trigger_bossDeath"], self.BossDeathEvent)
	self:CombatlogFilter(L["trigger_toPlatform"], self.TeleportEvent, true)
	self:CombatlogFilter(L["trigger_toFloor"], self.TeleportEvent, true)
	self:CombatlogFilter(L["trigger_decrepitFever"], self.DiseaseEvent, true)
	
	self:ThrottleSync(10, syncName.toPlatform)
    self:ThrottleSync(10, syncName.toFloor)
	self:ThrottleSync(5, syncName.disease)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.teleport then
		self:Bar(L["bar_toPlatform"], timer.toPlatform, icon.toPlatform)
	end
    if self.db.profile.disease then
        self:Bar(L["bar_decrepitFever"], timer.firstDisease, icon.disease)
    end
    if self.db.profile.erruption then
        timer.erruption = timer.erruptionSlow
        self:Bar(L["bar_erruption"], timer.firstErruption, icon.erruption)
        self:ScheduleEvent("HeiganErruption", self.Erruption, timer.firstErruption, self)
    end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:BossDeathEvent(msg)
	if string.find(msg, L["trigger_bossDeath"]) then
		self:SendBossDeathSync()
	end
end

function module:TeleportEvent(msg)
    if string.find(msg, L["trigger_toPlatform"]) then
        self:Sync(syncName.toPlatform)
    elseif string.find(msg, L["trigger_toFloor"]) then
        self:Sync(syncName.toFloor)
    end
end

function module:DiseaseEvent(msg)
	if string.find(msg, L["trigger_decrepitFever"]) then
		if self.db.profile.disease then 
			self:Sync(syncName.disease)
		end
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
	module:DiseaseEvent(L["trigger_decrepitFever"])
	module:TeleportEvent(L["trigger_toPlatform"])
	module:TeleportEvent(L["trigger_toFloor"])
	module:BossDeathEvent(L["trigger_bossDeath"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
    -- /run local m=BigWigs:GetModule("Heigan the Unclean");m:Test()
    
    local function fever()
        module:DiseaseEvent(L["trigger_decrepitFever"])
    end
    local function toPlatform()
        module:TeleportEvent(L["trigger_toPlatform"])
    end
    local function toFloor()
        module:TeleportEvent(L["trigger_toFloor"])
    end

    local function deactivate()
        BigWigs:Print("deactivate")
        self:Disable()
    end
    
     
    
    local time = 0
    
    -- immitate CheckForEngage
    self:SendEngageSync()
    
    BigWigs:Print("module Test started")   
    
    -- fever after 9s
    time = time + timer.firstDisease
    BigWigs:Print(" fever after " .. time)
    self:ScheduleEvent(self:ToString().."Test_fever", fever, time, self)
    
    -- fever after 30s
    time = time + timer.disease
    BigWigs:Print(" fever after " .. time)
    self:ScheduleEvent(self:ToString().."Test_fever2", fever, time, self)
    
    -- fever after 51s
    time = time + timer.disease
    BigWigs:Print(" fever after " .. time)
    self:ScheduleEvent(self:ToString().."Test_fever3", fever, time, self)
    
    -- fever after 72s
    time = time + timer.disease
    BigWigs:Print(" fever after " .. time)
    self:ScheduleEvent(self:ToString().."Test_fever4", fever, time, self)
    
    
    -- toPlatform after 90s
    time = timer.toPlatform
    BigWigs:Print(" to platform after " .. time)
    self:ScheduleEvent(self:ToString().."Test_toPlatform", toPlatform, time, self)
    
    -- toFloor after 135s
    time = time + timer.toFloor
    BigWigs:Print(" to floor after " .. time)
    self:ScheduleEvent(self:ToString().."Test_toFloor", toFloor, time, self)
    
    
    -- reset after 50s
    time = time + 10
    BigWigs:Print(" deactivate after " .. time)
    self:ScheduleEvent(self:ToString().."Test_deactivate", deactivate, time, self)
end
