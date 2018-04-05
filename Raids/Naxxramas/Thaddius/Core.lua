------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.thaddius
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local feugen = AceLibrary("Babble-Boss-2.2")["Feugen"]
local stalagg = AceLibrary("Babble-Boss-2.2")["Stalagg"]


-- module variables
module.revision = 20016 -- To be overridden by the module!
module.enabletrigger = {module.translatedName, feugen, stalagg} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"enrage", "charge", "polarity", -1, "power", "throw", "phase", "bosskill"}


-- locals
module.timer = {
	throw = 20,
	powerSurge = {
		min = 10,
		max = 15
	},
	enrage = 300,
	polarityTick = 5.3,
	polarityShift = 33,
	polarityShiftCast = 3,
	firstPolarityShift = 16,
	phaseTransition = 20,
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
	adddiedFeugen = "ThaddiusAddDeathFeugen",
	adddiedStalagg = "ThaddiusAddDeathStalagg",
	polarity = "ThaddiusPolarity",
	polarityShiftCast = "ThaddiusPolarityShiftCast",
	enrage = "ThaddiusEnrage",
}
local syncName = module.syncName


module.feugenDead = nil
module.stalaggDead = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.powerSurge then
		self:PowerSurge()
	elseif sync == syncName.adddiedFeugen then
		self:AddDied(feugen)
	elseif sync == syncName.adddiedStalagg then
		self:AddDied(stalagg)
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

function module:AddDied(add)
	BigWigs:DebugMessage("add died")
	
	if add == feugen then
		module.feugenDead = true
	elseif add == stalagg then
		module.stalaggDead = true
	end
	
	if module.feugenDead and module.stalaggDead then
		if self.db.profile.phase then 
			self:Message(L["msg_bossActive"], "Attention") 
			self:Bar(L["bar_bossActive"], timer.phaseTransition, icon.enrage, true, BigWigsColors.db.profile.start)
		end
		self:CancelScheduledEvent("bwthaddiusthrow")
		self:CancelDelayedMessage(L["msg_throw"])
		self:RemoveBar(L["bar_throw"])		
		self:RemoveAddsHealthBar()
	end
end

function module:Phase2()
    self:RemoveBar(L["bar_throw"])
    self:CancelDelayedMessage(L["msg_throw"])
    self:CancelScheduledEvent("bwthaddiusthrow")
	self:RemoveAddsHealthBar()
    
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
		
		self:Bar(L["bar_polarityShift"], timer.firstPolarityShift, icon.polarityShift)
		BigWigsEnrage:Start(timer.enrage, self.translatedName)
	end
	
	self:KTM_Reset()
end

function module:PolarityShift()
	if self.db.profile.polarity then
		self:RegisterEvent("PLAYER_AURAS_CHANGED")
		self:Bar(L["bar_polarityShift"], timer.polarityShift, icon.polarityShift)
	end
end

function module:PolarityShiftCast()
	if self.db.profile.polarity then
		self:Message(L["msg_polarityShiftNow"], "Important", nil, "Beware")
		self:Bar(L["bar_polarityShift"], timer.polarityShiftCast, icon.polarityShift, true, BigWigsColors.db.profile.significant)
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
			if string.find(chargetype, L["misc_positiveCharge"]) then
				self:Message(L["msg_positiveCharge"], "Important", true, "RunAway")
				self:WarningSign(L["misc_positiveCharge"], timer.polarityTick)	
			else
				self:Message(L["msg_negativeCharge"], "Important", true, "RunAway")
				self:WarningSign(L["misc_negativeCharge"], timer.polarityTick)
			end
		elseif self.previousCharge and self.previousCharge == chargetype then
			self:Message(L["msg_noChange"], "Positive", true, "Long")
		end
		
		if string.find(chargetype, L["misc_positiveCharge"]) then
			self:Bar(L["bar_polarityTick"], timer.polarityTick, L["misc_positiveCharge"], "Important")	
		else
			self:Bar(L["bar_polarityTick"], timer.polarityTick, L["misc_negativeCharge"], "Important")
		end
		
	end
	
	self.previousCharge = chargetype
end


function module:PLAYER_AURAS_CHANGED(msg)
	local chargetype = nil
	local iIterator = 1
	while UnitDebuff("player", iIterator) do
		local texture, applications = UnitDebuff("player", iIterator)
		if string.find(texture, L["misc_positiveCharge"]) or string.find(texture, L["misc_negativeCharge"]) then
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




function module:SetupAddsHealthBar()
	self:TriggerEvent("BigWigs_StartHPBar", self, feugen, 100)
	self:TriggerEvent("BigWigs_SetHPBar", self, feugen, 0)
	self:TriggerEvent("BigWigs_StartHPBar", self, stalagg, 100)
	self:TriggerEvent("BigWigs_SetHPBar", self, stalagg, 0)

	self:ScheduleRepeatingEvent("bwthaddiusaddhealthbarupdate", self.UpdateAddsHealthBar, 1, self)
end

function module:UpdateAddsHealthBar()
	function getHealth(target)
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i .. "target") == target then
				return UnitHealth("Raid" .. i .. "target") / UnitHealthMax("Raid" .. i .. "target") * 100
			end
		end
		
		return 0
	end

	self:TriggerEvent("BigWigs_SetHPBar", self, feugen, 100 - getHealth(feugen))
	self:TriggerEvent("BigWigs_SetHPBar", self, stalagg, 100 - getHealth(stalagg))
end

function module:RemoveAddsHealthBar()
	self:TriggerEvent("BigWigs_StopHPBar", self, feugen)
	self:TriggerEvent("BigWigs_StopHPBar", self, stalagg)
	self:CancelScheduledEvent("bwthaddiusaddhealthbarupdate")
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:NewPolarity("Interface\\Icons\\Spell_ChargePositive")
	module:NewPolarity("Interface\\Icons\\Spell_ChargePositive")
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
