------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.magmadar
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"panic", "frenzy", "bosskill"}


-- locals
module.timer = {
	panic = 30,
	firstPanicDelay = 20 - 30,
	frenzy = 8,
}
local timer = module.timer

module.icon = {
	panic = "Spell_Shadow_DeathScream",
	frenzy = "Ability_Druid_ChallangingRoar",
	tranquil = "Spell_Nature_Drowsy",
}
local icon = module.icon

module.syncName = {
	panic = "MagmadarPanic",
	frenzy = "MagmadarFrenzyStart",
	frenzyOver = "MagmadarFrenzyStop",
}
local syncName = module.syncName


local _, playerClass = UnitClass("player")

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.panic then
		self:Panic()
	elseif sync == syncName.frenzy then
		self:Frenzy()
	elseif sync == syncName.frenzyOver then
        self:FrenzyOver()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Panic(delay)
	if self.db.profile.panic then
		if not delay then
			delay = 0
			self:Message(L["msg_panicNow"], "Important")
		end
	
		self:DelayedMessage(timer.panic - 5 + delay, L["msg_panicSoon"], "Urgent", nil, nil, true)		
		self:Bar(L["bar_panic"], timer.panic + delay, icon.panic)
		
		if playerClass == "WARRIOR" then
			self:DelayedSound(timer.panic - 10 + delay, "Ten")
			self:DelayedSound(timer.panic - 3 + delay, "Three")
			self:DelayedSound(timer.panic - 2 + delay, "Two")
			self:DelayedSound(timer.panic - 1 + delay, "One")
		end
	end
end

function module:Frenzy()
	if self.db.profile.frenzy then
		self:Message(L["msg_frenzy"], "Important", true, "Alert")
		self:Bar(L["bar_frenzy"], timer.frenzy, icon.frenzy, true, "red")
		if playerClass == "HUNTER" then
			self:WarningSign(icon.tranquil, timer.frenzy, true)
		end
	end
end

function module:FrenzyOver()
	self:RemoveBar(L["bar_frenzy"])
    self:RemoveWarningSign(icon.tranquil, true)
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Frenzy()
	module:FrenzyOver()
	module:Panic()
	
	module:BigWigs_RecvSync(syncName.panic)
	module:BigWigs_RecvSync(syncName.frenzy)
	module:BigWigs_RecvSync(syncName.frenzyOver)
end
