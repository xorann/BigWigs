------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.arlokk
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"phase", "whirlwind", "vanish", "mark", "puticon", "bosskill"}


-- locals
module.timer = {
	firstVanish = 29,
	vanish = 8,
    unvanish = 8,
	whirlwind = 2,
}
local timer = module.timer

module.icon = {
	vanish = "Ability_Vanish",
	whirlwind = "Ability_Whirlwind",
}
local icon = module.icon

module.syncName = {
	trollPhase = "ArlokkPhaseTroll",
	vanishPhase = "ArlokkPhaseVanish",
	pantherPhase = "ArlokkPhasePanther",
}
local syncName = module.syncName

module.vanished = nil

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.pantherPhase then
		self:PantherPhase()
	elseif sync == syncName.vanishPhase then
		self:VanishPhase()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:PantherPhase()
    module.vanished = false
	self:CancelScheduledEvent("checkunvanish")
	if self.db.profile.vanish then
		self:RemoveBar(L["bar_vanishReturn"])
        self:Bar(L["bar_vanishNext"], timer.vanish, icon.vanish)
	end
	if self.db.profile.phase then
		self:Message(L["msg_phasePanther"], "Attention")
	end
    
	if not module.vanished then
		self:ScheduleRepeatingEvent("checkvanish", self.CheckVanish, 0.5, self)
	end
end

function module:VanishPhase()
	module.vanished = true
	self:CancelScheduledEvent("checkvanish")
	self:CancelScheduledEvent("trollphaseinc")
	if self.db.profile.phase then
		self:Message(L["msg_phaseVanish"], "Attention")
	end
	if self.db.profile.vanish then
        self:RemoveBar(L["bar_vanishNext"])
		self:Bar(L["bar_vanishReturn"], timer.unvanish, icon.vanish, true, "White")
	end
	self:ScheduleRepeatingEvent("checkunvanish", self.CheckUnvanish, 0.5, self)
end


------------------------------
--      Utility	Functions   --
------------------------------
function module:IsArlokkVisible()
    if UnitName("playertarget") == self.submergeCheckName then
		return true
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == self.submergeCheckName then
				return true
			end
		end
	end
    
    return false
end

function module:CheckUnvanish()
    self:DebugMessage("CheckUnvanish")
    if module:IsArlokkVisible() then
        self:Sync(syncName.pantherPhase)
    end
end

function module:CheckVanish()
    self:DebugMessage("CheckVanish")
    if not module:IsArlokkVisible() then
        self:Sync(syncName.vanishPhase)
    end	
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:PantherPhase()
	module:VanishPhase()
	
	module:BigWigs_RecvSync(syncName.pantherPhase)
	module:BigWigs_RecvSync(syncName.vanishPhase)
end
