------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.thaddius
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local feugen = AceLibrary("Babble-Boss-2.2")["Feugen"]
local stalagg = AceLibrary("Babble-Boss-2.2")["Stalagg"]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = {module.translatedName, feugen, stalagg} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"enrage", "charge", "polarity", -1, "power", "throw", "phase", "bosskill"}


-- locals
module.timer = {
	throw = 21,
	powerSurge = 10,
	enrage = 300,
	polarityTick = 6,
	polarityShift = 30,
}
local timer = module.timer

module.icon = {
	throw = "Ability_Druid_Maul",
	powerSurge = "Spell_Shadow_UnholyFrenzy",
	enrage = "Spell_Shadow_UnholyFrenzy",
	polarityShift = "Spell_Nature_Lightning",
}
local icon = module.icon

module.syncName = {
	powerSurge = "StalaggPower",
	phase2 = "ThaddiusPhaseTwo",
	adddied = "ThaddiusAddDeath",
	polarity = "ThaddiusPolarity",
	polarityShiftCast = "ThaddiusPolarityShiftCast",
	enrage = "ThaddiusEnrage",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.powerSurge then
		self:PowerSurge()
	elseif sync == syncName.adddied then
		self:AddDied()
	elseif sync == syncName.phase2 then
		self:Phase2()
	elseif sync == syncName.polarity then
		self:PolarityShift()
	elseif sync == syncName.polarityShiftCast then
		self:PolarityShiftCast()
	elseif sync == syncName.enrage then
		self:Enrage()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:PowerSurge()
	if self.db.profile.power then
		self:Message(L["msg_stalagg"], "Important")
		self:Bar(L["bar_powerSurge"], timer.powerSurge, icon.powerSurge)
	end
end

function module:AddDied()
	BigWigs:DebugMessage("add died")
	self.addsdead = self.addsdead + 1
	if self.addsdead == 2 then
		if self.db.profile.phase then 
			self:Message(L["msg_bossActive"], "Attention") 
		end
		self:CancelScheduledEvent("bwthaddiusthrow")
		self:CancelDelayedMessage(L["msg_throw"])
	end
end

function module:Phase2()
    self:RemoveBar(L["bar_throw"])
    self:CancelDelayedMessage(L["msg_throw"])
    self:CancelScheduledEvent("bwthaddiusthrow")
    
	if self.db.profile.phase then 
		self:Message(L["msg_phase2"], "Important") 
	end
	if self.db.profile.enrage then
		self:Bar(L["bar_enrage"], timer.enrage, icon.enrage, true, BigWigsColors.db.profile.enrage)
		self:DelayedMessage(timer.enrage - 3 * 60, L["msg_enrage3m"], "Attention")
		self:DelayedMessage(timer.enrage - 90, L["msg_enrage90"], "Attention")
		self:DelayedMessage(timer.enrage - 60, L["msg_enrage60"], "Urgent")
		self:DelayedMessage(timer.enrage - 30, L["msg_enrage30"], "Important")
		self:DelayedMessage(timer.enrage - 10, L["msg_enrage10"], "Important")
	end
	
	self:KTM_Reset()
end

function module:PolarityShift()
	if self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:DelayedMessage(timer.polarityShift - 3, L["msg_polarityShift3"], "Important", nil, "Beware")
		self:Bar(L["bar_polarityShift"], timer.polarityShift, icon.polarityShift)
	end
end

function module:PolarityShiftCast()
	if self.db.profile.polarity then
		self:Message(L["msg_polarityShiftNow"], "Important")
	end
end

function module:Enrage()
	if self.db.profile.enrage then 
		self:Message(L["msg_enrage"], "Important") 
	end
	
	self:RemoveBar(L["bar_enrage"])
	
	self:CancelDelayedMessage(L["msg_enrage3m"])
	self:CancelDelayedMessage(L["msg_enrage90"])
	self:CancelDelayedMessage(L["msg_enrage60"])
	self:CancelDelayedMessage(L["msg_enrage30"])
	self:CancelDelayedMessage(L["msg_enrage10"])
end


------------------------------
-- Utility Functions   		--
------------------------------
function module:Throw()
	if self.db.profile.throw then
		self:Bar(L["bar_throw"], timer.throw, icon.throw)
		self:DelayedMessage(timer.throw - 5, L["msg_throw"], "Urgent")
	end
end

function module:NewPolarity(chargetype)
	if self.previousCharge then BigWigs:DebugMessage("old: " .. self.previousCharge) end
	BigWigs:DebugMessage("new: " .. chargetype)
    if self.db.profile.charge then
		if not self.previousCharge or self.previousCharge == "" or self.previousCharge ~= chargetype then
			if chargetype == L["misc_positiveCharge"] then
				self:Message(L["msg_positiveCharge"], "Positive", true, "RunAway")
				self:WarningSign(chargetype, 5)	
			else
				self:Message(L["msg_negativeCharge"], "Important", true, "RunAway")
				self:WarningSign(chargetype, 5)
			end
		elseif self.previousCharge and self.previousCharge == chargetype then
			self:Message(L["msg_noChange"], "Urgent", true, "Long")
		end
		self:Bar(L["bar_polarityTick"], timer.polarityTick, chargetype, "Important")
	end
	
	self.previousCharge = chargetype
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:NewPolarity(L["misc_positiveCharge"])
	module:NewPolarity(L["misc_negativeCharge"])
	module:Throw()
	module:Enrage()
	module:PolarityShiftCast()
	module:PolarityShift()
	module:Phase2()
	module:AddDied()
	module:PowerSurge()
	
	module:BigWigs_RecvSync(syncName.powerSurge)
	module:BigWigs_RecvSync(syncName.adddied)
	module:BigWigs_RecvSync(syncName.phase2)
	module:BigWigs_RecvSync(syncName.polarity)
	module:BigWigs_RecvSync(syncName.polarityShiftCast)
	module:BigWigs_RecvSync(syncName.enrage)
end
