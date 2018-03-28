--[[
    Created by Dorann
--]]

local bossName = BigWigs.bossmods.naxx.stitchedGiant
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
module.revision = 20016 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:CombatlogFilter(L["trigger_slimeBolt"], self.SlimeBoltEvent)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.boltNumber = 1
	module.lastBolt = nil
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar(string.format(L["bar_slimeBoltNext"], 1), timer.slimeFirst, icon.slimeBolt)
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


-- not synchronized since it's not relevant if you are not in range and we don't have any problems with delayed synchronization
function module:SlimeBolt()
	if self.db.profile.slimeBolt then
		if not module.lastBolt then
			module.boltNumber = 1
		else
			local elapsed = GetTime() - module.lastBolt
			
			if elapsed < timer.slimeInterval then
				if module.boltNumber == 2 then
					module.boltNumber = 3
				elseif module.boltNumber == 1 then
					module.boltNumber = 2
				else
					module.boltNumber = 1
				end
			else
				module.boltNumber = 1
			end
		end			
			
		self:Bar(L["bar_slimeBoltCast"], timer.slimeCast, icon.slimeBolt, true, BigWigsColors.db.profile.interrupt)
		self:Bar(string.format(L["bar_slimeBoltNext"], module.boltNumber), timer.slimeInterval, icon.slimeBolt)
		module.lastBolt = GetTime()
	end
end

------------------------------
--      Event Handlers      --
------------------------------
function module:SlimeBoltEvent(msg, event)
	BigWigs:DebugMessage("slimeBolt: " .. msg)
	if string.find(msg, L["trigger_slimeBolt"]) then
		BigWigs:DebugMessage("slimeBolt found.")
		module:SlimeBolt()
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
	module:SlimeBoltEvent(L["trigger_slimeBolt"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual(long)	
	-- /run local m=BigWigs:GetModule("Stiched Giant");m:TestVisual()
	local function slimeBolt()
		module:SlimeBoltEvent(L["trigger_slimeBolt"])
		BigWigs:Print("slimeBolt")
	end 
	
	local function deactivate()
		self:DebugMessage("deactivate")
		self:Disable()
	end

	BigWigs:Print("module Test started")

	-- immitate CheckForEngage
	self:SendEngageSync()

	-- sweep after 5s
	self:ScheduleEvent(self:ToString() .. "Test_slimeBolt1", slimeBolt, 6, self)
	self:ScheduleEvent(self:ToString() .. "Test_slimeBolt2", slimeBolt, 7, self)
	self:ScheduleEvent(self:ToString() .. "Test_slimeBolt3", slimeBolt, 12, self)
	
	self:ScheduleEvent(self:ToString() .. "Test_deactivate", deactivate, 15, self)
end
