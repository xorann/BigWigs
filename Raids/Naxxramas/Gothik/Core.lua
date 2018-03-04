------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.gothik
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_riderName"], L["misc_deathKnightName"], L["misc_traineeName"],
	L["misc_spectralRiderName"], L["misc_spectralDeathKnightName"], L["misc_spectralTraineeName"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"room", -1, "add", "adddeath", "teleport", "bosskill"}


-- locals
module.timer = {
	inroom = 273,
	
	firstTrainee = 27,
	traineeInterval = 20.3, -- its 20.5 seconds not 21
	trainee = 0,
	
	firstDeathknight = 77,
	deathknightInterval = 25,
	deathknight = 0,
	
	firstRider = 137,
	riderInterval = 30,
	rider = 0,
	
	teleport = 15,
}
--[[
local timer = {
	inroom = 274,
	firstTrainee = 24,
	trainee = 20,
	firstDeathknight = 74,
	deathknight = 25,
	firstRider = 134,
	rider = 30,
}
]]
local timer = module.timer

module.icon = {
	inroom = "Spell_Magic_LesserInvisibilty",
	trainee = "Ability_Seal",
	deathknight = "INV_Boots_Plate_08",
	rider = "Spell_Shadow_DeathPact",
	teleport = "spell_arcane_blink",
}
local icon = module.icon

module.syncName = {}
local syncName = module.syncName


module.wave = 0
module.numTrainees = 0
module.numDeathknights = 0
module.numRiders = 0


------------------------------
--      Synchronization	    --
------------------------------


------------------------------
-- Sync Handlers	    	--
------------------------------


------------------------------
-- Utility	Functions   	--
------------------------------
function module:WaveWarn(message, L, color)
	module.wave = module.wave + 1
	if self.db.profile.add then 
		self:Message(string.format(L["msg_wave"], module.wave) .. message, color) 
	end
end

function module:Trainee()
	module.numTrainees = module.numTrainees + 1
	
	if self.db.profile.add then
		self:Bar(string.format(L["bar_trainee"], module.numTrainees), timer.trainee, icon.trainee)
	end
	self:ScheduleEvent("bwgothiktrawarn", self.WaveWarn, timer.trainee - 3, self, L["msg_trainee"], L, "Attention")
	self:ScheduleRepeatingEvent("bwgothiktrarepop", self.Trainee, timer.trainee, self)
	
	if module.numTrainees >= 13 then  -- cancels bar after wave 11
		self:RemoveBar(string.format(L["bar_trainee"], module.numTrainees - 1))
		self:CancelScheduledEvent("bwgothiktrawarn")
		self:CancelScheduledEvent("bwgothiktrarepop")
		module.numTrainees = 0
	end
end

function module:DeathKnight()
	module.numDeathknights = module.numDeathknights + 1
	
	if self.db.profile.add then
		self:Bar(string.format(L["bar_deathKnight"], module.numDeathknights), timer.deathknight, icon.deathknight)
	end
	self:ScheduleEvent("bwgothikdkwarn", self.WaveWarn, timer.deathknight - 3, self, L["msg_deathKnight"], L, "Urgent")
	self:ScheduleRepeatingEvent("bwgothikdkrepop", self.DeathKnight, timer.deathknight, self)

	if module.numDeathknights >= 9 then  -- cancels bar after wave 7
		self:RemoveBar(string.format(L["bar_deathKnight"], module.numDeathknights - 1))
		self:CancelScheduledEvent("bwgothikdkwarn")
		self:CancelScheduledEvent("bwgothikdkrepop")
		module.numDeathknights = 0
	end
end

function module:Rider()
	module.numRiders = module.numRiders + 1
	
	if self.db.profile.add then
		self:Bar(string.format(L["bar_rider"], module.numRiders), timer.rider, icon.rider)
	end
	self:ScheduleEvent("bwgothikriderwarn", self.WaveWarn, timer.rider - 3, self, L["msg_rider"], L, "Important")
	self:ScheduleRepeatingEvent("bwgothikriderrepop", self.Rider, timer.rider, self)
	
	if module.numRiders >= 6 then  -- cancels bar after wave 4
		self:RemoveBar(string.format(L["bar_rider"], module.numRiders - 1)) 
		self:CancelScheduledEvent("bwgothikriderwarn")
		self:CancelScheduledEvent("bwgothikriderrepop")
		module.numRiders = 0
	end
end

function module:StopRoom()
	self:RemoveBar(L["bar_inRoom"])
	self:CancelDelayedMessage(L["msg_inRoom3m"])
	self:CancelDelayedMessage(L["msg_inRoom90"])
	self:CancelDelayedMessage(L["msg_inRoom60"])
	self:CancelDelayedMessage(L["msg_inRoom30"])
	self:CancelDelayedMessage(L["msg_inRoom10"])
	
	--if module.numTrainees and module.numDeathknights and module.numRiders then
	--	self:RemoveBar(string.format(L["bar_trainee"], module.numTrainees - 1)) -- disabled for custom cancel
	--	self:RemoveBar(string.format(L["bar_deathKnight"], module.numDeathknights - 1)) -- too
	--	self:RemoveBar(string.format(L["bar_rider"], module.numRiders - 1)) -- too
	--end
	--self:CancelScheduledEvent("bwgothiktrawarn")
	--self:CancelScheduledEvent("bwgothikdkwarn")
	--self:CancelScheduledEvent("bwgothikriderwarn")
	--self:CancelScheduledEvent("bwgothiktrarepop")
	--self:CancelScheduledEvent("bwgothikdkrepop")
	--self:CancelScheduledEvent("bwgothikriderrepop")
	
	module.wave = 0
	module.numTrainees = 0
	module.numDeathknights = 0
	module.numRiders = 0
	
end

function module:Teleport()
	self:KTM_Reset()
	
	if self.db.profile.teleport then
		self:Bar(L["bar_teleport"], timer.teleport, icon.teleport)
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:StopRoom()
	module:Rider()
	module:DeathKnight()
	module:Trainee()
	module:WaveWarn(L["msg_trainee"], L, "Attention")
end
