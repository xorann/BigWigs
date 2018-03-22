local bossName = BigWigs.bossmods.naxx.thaddius
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
module.revision = 20016 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])

-- called after module is enabled
function module:OnEnable()
	self:CombatlogFilter(L["trigger_stalagg"], self.PowerSurgeEvent, true)
	self:CombatlogFilter(L["trigger_polarityShiftCast"], self.PolarityCastEvent, true)
	self:CombatlogFilter(L["trigger_enrage"], self.EnrageEvent)
	self:CombatlogFilter(L["trigger_polarityShift"], self.PolarityShiftEvent, true)
	self:CombatlogFilter(L["trigger_addDeathFeugen"], self.AddDeathEvent)
	self:CombatlogFilter(L["trigger_addDeathStalagg"], self.AddDeathEvent)
	self:CombatlogFilter(L["trigger_phase2_1"], self.PhaseTwoEvent)
	self:CombatlogFilter(L["trigger_phase2_2"], self.PhaseTwoEvent)
	self:CombatlogFilter(L["trigger_phase2_3"], self.PhaseTwoEvent)
	
	self:ThrottleSync(10, syncName.polarity)
	self:ThrottleSync(4, syncName.powerSurge)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.enrageStarted = nil
	self.teslawarn = nil
	self.stage1warn = nil
	self.previousCharge = ""
	
	module.feugenDead = false
	module.stalaggDead = false
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.phase and not self.stage1warn then
		self:Message(L["msg_phase1"], "Important")
	end
	self.stage1warn = true
	self:Throw()
	self:ScheduleRepeatingEvent("bwthaddiusthrow", self.Throw, timer.throw, self)
	
	self:SetupAddsHealthBar()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:RemoveAddsHealthBar()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:PowerSurgeEvent(msg)
	if string.find(msg, L["trigger_stalagg"]) then
		self:Sync(syncName.powerSurge)
	end
end

function module:AddDeathEvent(msg)
	if string.find(msg, L["trigger_addDeathFeugen"]) then
		self:Sync(syncName.adddiedFeugen)
	elseif string.find(msg, L["trigger_addDeathStalagg"]) then
		self:Sync(syncName.adddiedStalagg)
	end
end

function module:PhaseTwoEvent(msg)
	if string.find(msg, L["trigger_phase2_1"]) or string.find(msg, L["trigger_phase2_2"]) or string.find(msg, L["trigger_phase2_3"]) then
		self:Sync(syncName.phase2)
	end
end

function module:PolarityCastEvent(msg)
	if string.find(msg, L["trigger_polarityShiftCast"]) then
		self:Sync(syncName.polarityShiftCast)
	end
end

function module:PolarityShiftEvent(msg)
	if string.find(msg, L["trigger_polarityShift"]) then
		self:Sync(syncName.polarity)
	end
end

function module:EnrageEvent(msg)
	if string.find(msg, L["trigger_enrage"]) then
		self:Sync(syncName.enrage)
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
	module:PowerSurgeEvent(L["trigger_stalagg"])
	module:AddDeathEvent(L["trigger_addDeathFeugen"])
	module:AddDeathEvent(L["trigger_addDeathStalagg"])
	module:PhaseTwoEvent(L["trigger_phase2_1"])
	module:PhaseTwoEvent(L["trigger_phase2_2"])
	module:PhaseTwoEvent(L["trigger_phase2_3"])
	module:PolarityCastEvent(L["trigger_polarityShiftCast"])
	module:PolarityShiftEvent(L["trigger_polarityShift"])
	module:EnrageEvent(L["trigger_enrage"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)
	-- /run local m=BigWigs:GetModule("Thaddius");m:TestVisual(true)
    BigWigs:Print("test")
	
	local function testPhase2()
		module:PhaseTwoEvent(L["trigger_phase2_1"])
        BigWigs:Print("  testPhase2")
    end
	local function testPolarityShiftPositive()
		module:PolarityShift()
		module:NewPolarity("Interface\\Icons\\Spell_ChargePositive")
	end
    local function testPolarityShiftNegative()
		module:PolarityShift()
		module:NewPolarity("Interface\\Icons\\Spell_ChargeNegative")
	end
	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(module:ToString())
        BigWigs:Print("  testDisable")
	end
    
    if long then
        local testTimer = 0
        self:SendEngageSync()

        -- phase2
        testTimer = testTimer + 10
        self:ScheduleEvent(self:ToString() .. "testPhase2", testPhase2, testTimer, self)
        BigWigs:Print(" testPhase2 in " .. testTimer)

        -- polarity shift 1
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive1 in " .. testTimer)

        -- polarity shift 2
        testTimer = testTimer + 30
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive2", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive2 in " .. testTimer)

        -- polarity shift 3
        testTimer = testTimer + 30
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftNegative", testPolarityShiftNegative, testTimer, self)
        BigWigs:Print(" testPolarityShiftNegative in " .. testTimer)

        -- disable
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
        BigWigs:Print(" testDisable in " .. testTimer)
    else
        local testTimer = 0
        self:SendEngageSync()

        -- phase2
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPhase2", testPhase2, testTimer, self)
        BigWigs:Print(" testPhase2 in " .. testTimer)

        -- polarity shift 1
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive1 in " .. testTimer)

        -- polarity shift 2
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftPositive2", testPolarityShiftPositive, testTimer, self)
        BigWigs:Print(" testPolarityShiftPositive2 in " .. testTimer)

        -- polarity shift 3
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testPolarityShiftNegative", testPolarityShiftNegative, testTimer, self)
        BigWigs:Print(" testPolarityShiftNegative in " .. testTimer)

        -- disable
        testTimer = testTimer + 5
        self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
        BigWigs:Print(" testDisable in " .. testTimer)
    end
end
