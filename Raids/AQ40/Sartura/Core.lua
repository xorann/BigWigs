------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.sartura
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "whirlwind", "adds", "enrage", "berserk", "bosskill" }

-- locals
module.timer = {
	berserk = 600,
	firstWhirlwind = 20.3,
	whirlwind = 15,
	nextWhirlwind = {
		min = 25,
		max = 30
	},
}
local timer = module.timer

module.icon = {
	berserk = "Spell_Shadow_UnholyFrenzy",
	whirlwind = "Ability_Whirlwind",
}
local icon = module.icon

module.syncName = {
	whirlwind = "SarturaWhirlwindStart",
	whirlwindOver = "SarturaWhirlwindEnd",
	enrage = "SarturaEnrage",
	berserk = "SarturaBerserk",
	add = "SarturaAddDead",
}
local syncName = module.syncName

module.guard = 0


------------------------------
-- Synchronization	    	--
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.whirlwind then
		self:Whirlwind()
	elseif sync == syncName.whirlwindOver then
		self:WhirlwindGone()
	elseif sync == syncName.enrage then
		self:Enrage()
	elseif sync == syncName.berserk then
		self:Berserk()
	elseif sync == syncName.add then
		self:AddDeath()
	end
end

------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Whirlwind()
	if self.db.profile.whirlwind then
		self:Message(L["msg_whirlwindGain"], "Important")
		self:Bar(L["bar_whirlwind"], timer.whirlwind, icon.whirlwind)

		self:IrregularBar(L["bar_possibleWhirlwind"], timer.nextWhirlwind.min, timer.nextWhirlwind.max, icon.whirlwind)
	end
end

function module:WhirlwindGone()
	if self.db.profile.whirlwind then
		self:RemoveBar(L["bar_whirlwind"])
		self:Message(L["msg_whirlwindGone"], "Attention")
	end
end

function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Attention")
	end
end

function module:Berserk()
	if self.db.profile.berserk then
		self:Message(L["msg_berserk"], "Attention")
		self:RemoveBar(L["bar_berserk"])

		self:CancelDelayedMessage(L["msg_berserk5m"])
		self:CancelDelayedMessage(L["msg_berserk3m"])
		self:CancelDelayedMessage(L["msg_berserk90"])
		self:CancelDelayedMessage(L["msg_berserk60"])
		self:CancelDelayedMessage(L["msg_berserk30"])
		self:CancelDelayedMessage(L["msg_berserk10"])
	end
end

function module:AddDeath()
	module.guard = module.guard + 1
	if self.db.profile.adds then
		self:Message(string.format(L["msg_addDeath"], module.guard), "Positive")
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Whirlwind()
	module:WhirlwindGone()
	module:Enrage()
	module:Berserk()
	module:AddDeath()

	module:BigWigs_RecvSync(syncName.whirlwind)
	module:BigWigs_RecvSync(syncName.whirlwindOver)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.berserk)
	module:BigWigs_RecvSync(syncName.add)
end