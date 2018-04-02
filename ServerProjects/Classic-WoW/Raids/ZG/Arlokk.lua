local bossName = BigWigs.bossmods.zg.arlokk
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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	
	self:ThrottleSync(3, syncName.trollPhase)
	self:ThrottleSync(3, syncName.vanishPhase)
	self:ThrottleSync(3, syncName.pantherPhase)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.vanished = false
end

-- called after boss is engaged
function module:OnEngage()
	self:CancelScheduledEvent("checkvanish")
    self:ScheduleRepeatingEvent("checkvanish", self.CheckVanish, 1, self)
	
	if self.db.profile.phase then
		self:Message(L["msg_phaseTroll"], "Attention")
	end
	
	self:Bar(L["bar_vanishNext"], timer.firstVanish, icon.vanish)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
	self:CancelScheduledEvent("checkvanish")
	self:CancelScheduledEvent("checkunvanish")
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_MONSTER_YELL(msg)
	local _,_, n = string.find(msg, L["trigger_mark"])
	
	if n then
		if self.db.profile.mark then
			if n == UnitName("player") then
				self:Message(L["msg_markYou"], "Attention", true, "Alarm")
			else
				self:Message(string.format(L["msg_markOther"], n), "Attention")
			end
		end
		
		if self.db.profile.puticon then
			self:Icon(n, -1, -1)
		end
		--self:Sync(syncName.vanishPhase)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_whirlwind"] and self.db.profile.whirlwind then
		self:Bar(L["bar_whirlwind"], timer.whirlwind, icon.whirlwind)
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
	module:CHAT_MSG_MONSTER_YELL(L["trigger_mark"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_whirlwind"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	-- /run local m=BigWigs:GetModule("High Priestess Arlokk");m:Test()
    local translatedName = self.translatedName
    
	local function testCheckVanish()
        ClearTarget()
        BigWigs:Print("testCheckVanish")
    end
    local function testCheckUnvanish()
        TargetUnit("player")
        BigWigs:Print("testCheckUnvanish")
    end
	local function testDisable()
		--module:SendWipeSync()
		BigWigs:TriggerEvent("BigWigs_RebootModule", self:ToString())
		BigWigs:DisableModule(module:ToString())
        BigWigs:Print("Test finished")
        self.translatedName = translatedName
	end
    
    -- short test
    local testTimer = 0
    self:SendEngageSync()
    
    BigWigs:Print("Target/Untarget yourself to test CheckVanish/CheckUnvanish")
    testCheckUnvanish()
    self.translatedName = UnitName("player") -- override name to test CheckVanish/CheckUnvanish

    -- vanish
    testTimer = testTimer + 5
    self:ScheduleEvent(self:ToString() .. "testCheckVanish", testCheckVanish, testTimer, self)
    BigWigs:Print("testCheckVanish in " .. testTimer)

    -- unvanish
    testTimer = testTimer + 5
    self:ScheduleEvent(self:ToString() .. "testCheckUnvanish", testCheckUnvanish, testTimer, self)
    BigWigs:Print("testCheckUnvanish in " .. testTimer)
    
    -- disable
    testTimer = testTimer + 10
    self:ScheduleEvent(self:ToString() .. "testDisable", testDisable, testTimer, self)
    BigWigs:Print("testDisable in " .. testTimer)
end
