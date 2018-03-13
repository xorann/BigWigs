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
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS", "CheckStalagg")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "PolarityCastEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "PolarityCastEvent")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "CheckForEnrage")
	
	self:ThrottleSync(10, syncName.polarity)
	self:ThrottleSync(4, syncName.powerSurge)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.enrageStarted = nil
	self.addsdead = 0
	self.teslawarn = nil
	self.stage1warn = nil
	self.previousCharge = ""
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.phase and not self.stage1warn then
		self:Message(L["msg_phase1"], "Important")
	end
	self.stage1warn = true
	self:Throw()
	self:ScheduleRepeatingEvent("bwthaddiusthrow", self.Throw, timer.throw, self)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckStalagg(msg)
	if msg == L["trigger_stalagg"] then
		self:Sync(syncName.powerSurge)
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_polarityShift"]) then
		self:Sync(syncName.polarity)	
	elseif msg == L["trigger_addDeath1"] or msg == L["trigger_addDeath2"] then
		self:Sync(syncName.adddied)
	elseif string.find(msg, L["trigger_phase2_1"]) or string.find(msg, L["trigger_phase2_2"]) or string.find(msg, L["trigger_phase2_3"]) then
		self:Sync(syncName.phase2)
	end
end

function module:CheckForEnrage(msg)
	if msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	end
end

function module:PolarityCastEvent(msg)
	if string.find(msg, L["trigger_polarityShiftCast"]) then
		self:Sync(syncName.polarityShiftCast)
	end
end

function module:PLAYER_AURAS_CHANGED(msg)
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local texture, applications = UnitDebuff("player", iIterator)
		if texture == L["misc_positiveCharge"] or texture == L["misc_negativeCharge"] then
			-- If we have a debuff with this texture that has more
			-- than one application, it means we still have the
			-- counter debuff, and thus nothing has changed yet.
			-- (we got a PW:S or Renew or whatever after he casted
			--  PS, but before we got the new debuff)
			if applications > 1 then 
				return 
			end
			chargetype = texture
			-- Note that we do not break out of the while loop when
			-- we found a debuff, since we still have to check for
			-- debuffs with more than 1 application.
		end
		iIterator = iIterator + 1
	end
	if not chargetype then return end

	self:UnregisterEvent("PLAYER_AURAS_CHANGED")

	self:NewPolarity(chargetype)
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
	module:PolarityCastEvent(L["trigger_polarityShiftCast"])
	module:CheckForEnrage(L["trigger_enrage"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_polarityShift"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_addDeath1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_addDeath2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_1"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_2"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_3"])
	module:CheckStalagg(L["trigger_stalagg"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)
	-- /run local m=BigWigs:GetModule("Thaddius");m:TestVisual(true)
    BigWigs:Print("test")
	
	local function testPhase2()
		module:CHAT_MSG_MONSTER_YELL(L["trigger_phase2_1"])
        BigWigs:Print("  testPhase2")
    end
	local function testPolarityShiftPositive()
		module:PolarityShift()
		module:NewPolarity(L["misc_positiveCharge"])
	end
    local function testPolarityShiftNegative()
		module:PolarityShift()
		module:NewPolarity(L["misc_negativeCharge"])
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
