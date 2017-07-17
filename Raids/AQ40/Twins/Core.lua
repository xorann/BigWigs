
------------------------------
--      Variables      --
------------------------------

local bossName = BigWigs.bossmods.aq40.twins
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local veklor = AceLibrary("Babble-Boss-2.2")["Emperor Vek'lor"]
local veknilash = AceLibrary("Babble-Boss-2.2")["Emperor Vek'nilash"]

-- module variables
module.revision = 20012 -- To be overridden by the module!
module.enabletrigger = {veklor, veknilash} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"bug", "teleport", "enrage", "heal", "blizzard", "bosskill"}

-- locals
module.timer = {
	teleport = 29.8,
	enrage = 900,
	blizzard = 10,
}
local timer = module.timer

module.icon = {
	teleport = "Spell_Arcane_Blink",
	enrage = "Spell_Shadow_UnholyFrenzy",
	blizzard = "Spell_Frost_IceStorm",
}
local icon = module.icon

module.syncName = {
	teleport = "TwinsTeleport43",
	heal = "TwinsHeal",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.teleport then
        self:Teleport()
	elseif sync == syncName.heal then
		self:Heal()
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

function module:Teleport()
	if self.db.profile.teleport then
		self:Bar(L["bar_teleport"], timer.teleport, icon.teleport)
		self:Bar("Switch", 6, icon.teleport)
        self:KTM_Reset()
        
        self:DelayedSound(timer.teleport - 10, "Ten")
        self:DelayedSound(timer.teleport - 3, "Three")
        self:DelayedSound(timer.teleport - 2, "Two")
        self:DelayedSound(timer.teleport - 1, "One")
        self:DelayedMessage(timer.teleport - 0.1, L["msg_teleport"], "Attention", false, "Alarm")

	end
end

function module:Heal()
	if not self.prior and self.db.profile.heal then
		self:Message(L["msg_heal"], "Important")
		self.prior = true
		self:ScheduleEvent(function() module.prior = nil end, 10)
	end
end

------------------------------
-- Utility			    	--
------------------------------

function module:WarnForEnrage()
	if self.db.profile.enrage then
		self:Bar(L["bar_enrage"],
			timer.enrage,
			icon.enrage)

		self:DelayedMessage(timer.enrage - 10 * 60, L["msg_enrage10m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 5 * 60, L["msg_enrage5m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 3 * 60, L["msg_enrage3m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 90, L["msg_enrage90"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.enrage - 60, L["msg_enrage60"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.enrage - 30, L["msg_enrage30"], "Important", nil, nil, true)
		self:DelayedMessage(timer.enrage - 10, L["msg_enrage10"], "Important", nil, nil, true)

	end
end

function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important")
	end
end

function module:BlizzardGain()
	if self.db.profile.blizzard then
		self:Message(L["msg_blizzard"], "Personal", true, "Alarm")
		self:WarningSign(icon.blizzard, timer.blizzard)
	end
end

function module:BlizzardGone()
	self:RemoveWarningSign(icon.blizzard)
end

function module:BugExplosion()
	if self.db.profile.bug then
		self:Message(L["msg_explosion"], "Personal", true)
	end
end


----------------------------------
-- 		Module Test Function    --
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Teleport()
	module:Heal()
	module:WarnForEnrage()
	module:BlizzardGain()
	module:BlizzardGone()
	module:BugExplosion()
end

