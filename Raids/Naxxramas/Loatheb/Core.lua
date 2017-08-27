------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.loatheb
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"doom", "curse", "spore", "bosskill"}


-- locals
module.timer = {
	softEnrage = 300,
	firstDoom = 120,
	doomLong = 30,
	doomShort = 15,
	doom = 0, -- this variable will be changed during the encounter
	spore = 13,
	firstCurse = 10,
	curse = 30,
}
local timer = module.timer

module.icon = {
	softEnrage = "Spell_Shadow_UnholyFrenzy",
	doom = "Spell_Shadow_NightOfTheDead",
	spore = "Ability_TheBlackArrow",
	curse = "Spell_Holy_RemoveCurse",
}
local icon = module.icon

module.syncName = {
	doom = "LoathebDoom2",
	spore = "LoathebSporeSpawn2",
	curse = "LoathebRemoveCurse",
}
local syncName = module.syncName


module.numSpore = 0 -- how many spores have been spawned
module.numDoom = 0 -- how many dooms have been casted
module.timeCurseWarning = 0


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.doom and rest then
		self:Doom(rest)
	elseif sync == syncName.curse then
		self:Curse()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Doom(syncNumDoom)
	syncNumDoom = tonumber(syncNumDoom)
	if syncNumDoom then
		if syncNumDoom == (module.numDoom + 1) then
			module.numDoom = module.numDoom + 1
			if self.db.profile.doom then
				self:Message(string.format(L["msg_doomSoon"], module.numDoom, timer.doom), "Important")
			end
			if self.db.profile.doom then
				self:Bar(string.format(L["bar_doom"], module.numDoom + 1), timer.doom, icon.doom)
				self:DelayedMessage(timer.doom - 5, string.format(L["msg_doomSoon"], module.numDoom + 1), "Urgent")
			end
		end
	end
end

function module:Curse()
	if self.db.profile.curse then
		if module.timeCurseWarning + 5 < GetTime() then
			module.timeCurseWarning = GetTime()
			self:Message(L["msg_curse"], "Important")
			self:Bar(L["bar_curse"], timer.curse, icon.curse)
		end
	end
end


------------------------------
--      Utility	Functions   --
------------------------------
function module:SoftEnrage()
	timer.doom = timer.doomShort -- reduce doom timer from 30s to 15s
end

function module:Spore()
	module.numSpore = module.numSpore + 1

	if self.db.profile.spore then
		--self:Message(string.format(L["msg_spore"], module.numSpore), "Important")
		self:Bar(string.format(L["bar_spore"], module.numSpore), timer.spore, icon.spore)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Spore()
	module:SoftEnrage()
	module:Curse()
	module:Doom(1)
	
	module:BigWigs_RecvSync(syncName.doom, 1)
	module:BigWigs_RecvSync(syncName.curse)
end
