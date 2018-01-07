--[[

[2017/08/30 20:43:40-456]: Twins\Core.lua:71: attempt to index local `self' (a nil value)
Twins\Core.lua:71: in function `event'
AceEvent-2.0\AceEvent-2.0.lua:430: in function <Interface\AddOns\Ace2\AceEvent-2.0\AceEvent-2.0.lua:407>

  ---
  
 ]]
------------------------------
--      Variables      --
------------------------------

local bossName = BigWigs.bossmods.aq40.twins
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
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
	teleport = 30,
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
	local mod = BigWigs:GetModule(BigWigs.bossmods.aq40.twins)
	
	if sync == syncName.teleport then
        --self:Teleport()
        mod:Teleport()
	elseif sync == syncName.heal then
		--self:Heal()
		mod:Heal()
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

--[[

Error:  attempt to index local `self' (a nil value)
AddOn: BigWigs
File: Core.lua
Line: 58
Count: 1
[C]: ?
Interface\AddOns\BigWigs\Raids\AQ40\Twins\Core.lua:58: in function `event'
Interface\AddOns\Ace2\AceEvent-2.0\AceEvent-2.0.lua:430: in function <Interface\AddOns\Ace2\AceEvent-2.0\AceEvent-2.0.lua:407>


]]
function module:Teleport()
	--local mod = BigWigs:GetModule(BigWigs.bossmods.aq40.twins)
	local mod = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
	
	if mod.db.profile.teleport then
		mod:Bar(L["bar_teleport"], timer.teleport, icon.teleport)
		--self:Bar("Switch", 6, icon.teleport)
        mod:KTM_Reset()
        
        mod:DelayedSound(timer.teleport - 10, "Ten")
        mod:DelayedSound(timer.teleport - 3, "Three")
        mod:DelayedSound(timer.teleport - 2, "Two")
        mod:DelayedSound(timer.teleport - 1, "One")
        mod:DelayedMessage(timer.teleport - 0.1, L["msg_teleport"], "Attention", false, "Alarm")

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
		self:Bar(L["bar_enrage"], timer.enrage,	icon.enrage, true, BigWigsColors.db.profile.enrage)

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

