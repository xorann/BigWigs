------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.huhuran
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "wyvern", "frenzy", "berserk", "bosskill" }


-- locals
module.timer = {
	berserk = 300,
	sting = {
		min = 15,
		max = 20
	},
	frenzy = 10,
}
local timer = module.timer

module.icon = {
	berserk = "INV_Shield_01",
	sting = "INV_Spear_02",
	frenzy = "Ability_Druid_ChallangingRoar",
	tranquil = "Spell_Nature_Drowsy",
}
local icon = module.icon

module.syncName = {
	sting = "HuhuranWyvernSting",
	frenzy = "HuhuranFrenzyGain",
	frenzyOver = "HuhuranFrenzyFade",
	berserkSoon = "HuhuranBerserkSoon",
	berserk = "HuhuranBerserk"
}
local syncName = module.syncName

module.berserkannounced = false


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.sting then
		self:Sting()
	elseif sync == syncName.frenzyGain then
		self:FrenzyGain()
	elseif sync == syncName.frenzyOver then
		self:FrenzyFade()
	elseif sync == syncName.berserkSoon then
		self:BerserkSoon()
	elseif sync == syncName.berserk then
		self:Berserk()
	end
end

------------------------------
-- Sync Handlers	    --
------------------------------
function module:Sting()
	if self.db.profile.sting then
		self:Message(L["msg_sting"], "Urgent")
		self:Bar(L["bar_sting"], timer.sting, icon.sting)
	end
end

function module:FrenzyGain()
	if self.db.profile.frenzy then
		self:Message(L["msg_frenzy"], "Important", nil, true, "Alert")
		self:Bar(L["bar_frenzy"], timer.frenzy, icon.frenzy, true, "red")

		local _, playerClass = UnitClass("player")
		if playerClass == "HUNTER" or true then
			self:WarningSign(icon.tranquil, timer.frenzy, true)
		end
	end
end

function module:FrenzyFade()
	if self.db.profile.frenzy then
		self:RemoveBar(L["bar_frenzy"])
		self:RemoveWarningSign(icon.tranquil, true)
	end
end

function module:BerserkSoon()
	if self.db.profile.berserk then
		self:Message(L["msg_berserkSoon"], "Important", false, "Alarm")
		module.berserkannounced = true
	end
end

function module:Berserk()
	if self.db.profile.berserk then
		self:CancelDelayedMessage(L["msg_berserk60"])
		self:CancelDelayedMessage(L["msg_berserk30"])
		self:CancelDelayedMessage(L["msg_berserk5"])
		self:RemoveBar(L["bar_berserk"])

		self:Message(L["msg_berserk"], "Urgent", false, "Beware")
		module.berserkannounced = true
	end
end


------------------------------
-- Utility			    	--
------------------------------
function module:WarnForBerserk()
	if self.db.profile.berserk then
		self:Bar(L["bar_berserk"], timer.berserk, icon.berserk)
		self:DelayedMessage(timer.berserk - 60, L["msg_berserk60"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.berserk - 30, L["msg_berserk30"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.berserk - 5, L["msg_berserk5"], "Important", nil, nil, true)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Sting()
	module:FrenzyGain()
	module:FrenzyFade()
	module:BerserkSoon()
	module:Berserk()
	module:WarnForBerserk()

	module:BigWigs_RecvSync(syncName.sting)
	module:BigWigs_RecvSync(syncName.frenzyGain)
	module:BigWigs_RecvSync(syncName.frenzyOver)
	module:BigWigs_RecvSync(syncName.berserkSoon)
	module:BigWigs_RecvSync(syncName.berserk)
end
