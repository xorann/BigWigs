--[[
    Created by Dorann
--]]

local bossName = BigWigs.bossmods.naxx.deathKnightCaptain
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
module.revision = 20015 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:CombatlogFilter(L["trigger_whirlwind"], self.WhirlwindEvent)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.deathCount = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar(L["bar_whirlwindNext"], timer.whirlwindFirst, icon.whirlwind)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:WhirlwindEvent(msg, event)
	BigWigs:DebugMessage("whirlwind: " .. msg)
	if string.find(msg, L["trigger_whirlwind"]) then
		BigWigs:DebugMessage("whirlwind found. syncing it")
		self:Sync(syncName.whirlwind)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, module.translatedName) then
		self:Sync(syncName.death, msg)
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
	module:WhirlwindEvent(L["trigger_whirlwind"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)	
	-- /run local m=BigWigs:GetModule("Death Knight Captain");m:TestVisual()
	local function whirlwind()
		--module:CheckForUnbalance("Instructor Razuvious's Unbalancing Strike hits Death Knight Understudy for 10724.")
		module:WhirlwindEvent(L["trigger_whirlwind"])
		BigWigs:Print("whirlwind")
	end 
	
	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
	end

	BigWigs:Print("module Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- sweep after 5s
	self:ScheduleEvent(self:ToString() .. "Test_whirlwind", whirlwind, 6, self)
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 10, self)
end
