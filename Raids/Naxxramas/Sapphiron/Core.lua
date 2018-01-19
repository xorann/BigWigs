------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.sapphiron
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"berserk", "lifedrain", "deepbreath", "icebolt", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false


-- locals
module.timer = {
	berserk = 900,
	deepbreathInc = 23,
	deepbreath = 7,
	lifedrainAfterFlight = 14,
	lifedrain = 24,
	groundPhase = 50,
}
local timer = module.timer

module.icon = {
	deepbreath = "Spell_Frost_FrostShock",
	deepbreathInc = "Spell_Arcane_PortalIronForge",
	lifedrain = "Spell_Shadow_LifeDrain02",
	berserk = "INV_Shield_01",
}
local icon = module.icon

module.syncName = {
	lifedrain = "SapphironLifeDrain",
	flight = "SapphironFlight",
	deepbreath = "SapphironDeepBreath"
}
local syncName = module.syncName


module.timeLifeDrain = nil
module.cachedUnitId = nil
module.lastTarget = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.lifedrain then
		self:LifeDrain()
	elseif sync == syncName.flight then
		self:Flight()
	elseif sync == syncName.deepbreath then
		self:DeepBreath()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:LifeDrain()
	if self.db.profile.lifedrain then
		self:Message(L["msg_lifeDrainNow"], "Urgent")
		self:Bar(L["bar_lifeDrain"], timer.lifedrain, icon.lifedrain)
	end
end

function module:Flight()
	if  self.db.profile.deepbreath and self.engaged then
		if self:IsEventScheduled("bwsapphtargetscanner") then
			self:CancelScheduledEvent("bwsapphtargetscanner")
		end
		if self:IsEventScheduled("bwsapphdelayed") then
			self:CancelScheduledEvent("bwsapphdelayed")
		end
		self:Message(L["msg_deepBreathSoon"], "Urgent")
		self:Bar(L["bar_deepBreathCast"], timer.deepbreathInc, icon.deepbreathInc)
		module.lastTarget = nil
		module.cachedUnitId = nil
		self:ScheduleEvent("besapphdelayed", self.StartTargetScanner, timer.groundPhase, self)
	end
end

function module:DeepBreath()
	if self.db.profile.deepbreath then
		self:Message(L["msg_deepBreathNow"], "Important")
		self:Bar(L["bar_deepBreath"], timer.deepbreath, icon.deepbreath)
	end
	
	self:RemoveBar(L["bar_lifeDrain"])
	if self.db.profile.lifedrain then
		self:Bar(L["bar_lifeDrain"], timer.lifedrainAfterFlight, icon.lifedrain)
	end
end


------------------------------
-- Target Scanning     		--
------------------------------

function module:StartTargetScanner()
	if not self:IsEventScheduled("bwsapphtargetscanner") and self.engaged then 
		-- Start a repeating event that scans the raid for targets every 1 second.
		self:ScheduleRepeatingEvent("bwsapphtargetscanner", self.RepeatedTargetScanner, 1, self)
	end
end

function module:RepeatedTargetScanner()
	if not UnitAffectingCombat("player") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
		return
	end

	if not self.engaged then 
		return 
	end
	local found = nil

	-- If we have a cached unit (which we will if we found someone with the boss
	-- as target), then check if he still has the same target
	if module.cachedUnitId and UnitExists(module.cachedUnitId) and UnitName(module.cachedUnitId) == boss then
		found = true
	end

	-- Check the players target
	if not found and UnitExists("target") and UnitName("target") == boss then
		module.cachedUnitId = "target"
		found = true
	end

	-- Loop the raid roster
	if not found then
		for i = 1, GetNumRaidMembers() do
			local unit = string.format("raid%dtarget", i)
			if UnitExists(unit) and UnitName(unit) == boss then
				module.cachedUnitId = unit
				found = true
				break
			end
		end
	end

	-- We've checked everything. If nothing was found, just return home.
	-- We basically shouldn't return here, because someone should always have
	-- him targetted.
	if not found then 
		return 
	end

	local inFlight = nil

	-- Alright, we've got a valid unitId with the boss as target, now check if
	-- the boss had a target on the last iteration or not - if he didn't, and
	-- still doesn't, then we fire the "in air" warning.
	if not UnitExists(module.cachedUnitId.."target") then
		-- Okay, the boss doesn't have a target.
		if not module.lastTarget then
			-- He didn't have a target last time either
			inFlight = true
		end
		module.lastTarget = nil
	else
		-- This should always be set before we hit the time when he actually
		-- loses his target, hence we can check |if not lastTarget| above.
		module.lastTarget = true
	end

	-- He's not flying, so we're just going to continue scanning.
	if not inFlight then 
		return 
	end

	-- He's in flight! (I hope)
	if self:IsEventScheduled("bwsapphtargetscanner") then
		self:CancelScheduledEvent("bwsapphtargetscanner")
	end
	self:Sync(syncName.flight)
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:RepeatedTargetScanner()
	module:StartTargetScanner()
	module:DeepBreath()
	module:Flight()
	module:LifeDrain()
	
	module:BigWigs_RecvSync(syncName.lifedrain)
	module:BigWigs_RecvSync(syncName.flight)
	module:BigWigs_RecvSync(syncName.deepbreath)
end
