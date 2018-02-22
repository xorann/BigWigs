------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.faerlina
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"silence", "enrage", "rain", "bosskill"}


-- locals
module.timer = {
	firstEnrage = 60,
	enrage = 60,
	silence = 30,
	rainTick = 2,
	rainDuration = 10,
}
local timer = module.timer

module.icon = {
	enrage = "Spell_Shadow_UnholyFrenzy",
	silence = "Spell_Holy_Silence",
	rain = "Spell_Shadow_RainOfFire",
}
local icon = module.icon

module.syncName = {
	enrage = "FaerlinaEnrage",
	enrageFade = "FaerlinaEnrageFade",
	silence = "FaerlinaSilence",
}
local syncName = module.syncName


module.timeEnrageStarted = nil
module.isEnraged = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.enrage then
		self:Enrage()
	elseif sync == syncName.enrageFade then
		self:EnrageFade()
	elseif sync == syncName.silence then
		self:Silence()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Enrage()
	self:RemoveBar(L["bar_enrage"])
	self:CancelDelayedMessage(L["msg_enrage15"])
	if self.db.profile.enrage then
		--self:WarningSign(icon.enrage, 5) -- would override the rain of fire warning sign
		self:Message(L["msg_enrageNow"], "Urgent", true, "Beware")
	end
	
	module.timeEnrageStarted = GetTime()
	module.isEnraged = true
end

function module:Silence()
	local currentTime = GetTime()
	
	if not module.isEnraged then -- preemptive, 30s silence
		--[[ The enrage timer should only be reset if it's less than 30sec
		to her next enrage, because if you silence her when there's 30+
		sec to the enrage, it won't actually stop her from enraging. ]]

		if self.db.profile.silence then
			if (module.timeEnrageStarted + 30) < currentTime then
				self:Message(L["msg_silenceNoDelay"], "Urgent")
			else
				self:Message(L["msg_silenceDelay"], "Urgent")
			end
			self:Bar(L["bar_silence"], timer.silence, icon.silence)
			self:DelayedMessage(timer.silence -5, L["msg_silence5"], "Urgent")
		end
		if (module.timeEnrageStarted + 30) < currentTime then
			if self.db.profile.enrage then
				-- We SHOULD reset the enrage timer, since it's more than 30
				-- sec since enrage started. This is only visuals ofcourse.
				self:RemoveBar(L["bar_enrage"])
				self:CancelDelayedMessage(L["msg_enrage15"])
				self:DelayedMessage(timer.silence - 15, L["msg_enrage15"], "Important")
				self:Bar(L["bar_enrage"], timer.silence, icon.enrage)
			end
			module.timeEnrageStarted = currentTime
		end

	else -- Reactive enrage removed
		module.timeEnrageStarted = currentTime
		
		if self.db.profile.enrage then
			self:Message(string.format(L["msg_enrageRemoved"], timer.enrage), "Urgent")
			self:Bar(L["bar_enrage"], timer.enrage, icon.enrage)
			self:DelayedMessage(timer.enrage - 15, L["msg_enrage15"], "Important")	
		end
		
		if self.db.profile.silence then
			self:Bar(L["bar_silence"], timer.silence, icon.silence)
			self:DelayedMessage(timer.silence -5, L["msg_silence5"], "Urgent")
		end
		
		module.isEnraged = nil
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Silence()
	module:Enrage()
	
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.silence)
end
