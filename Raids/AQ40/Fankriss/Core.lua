------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.fankriss
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "worm", "entangle", "bosskill" }


-- locals
module.timer = {
	worm = 20,
}
local timer = module.timer

module.icon = {
	worm = "Spell_Shadow_UnholyFrenzy",
	entangle = "Spell_Nature_Web",
}
local icon = module.icon

module.syncName = {
	worm = "FankrissWormSpawn",
	entangle = "FankrissEntangle",
}
local syncName = module.syncName

module.worms = 0


------------------------------
-- Synchronization	    	--
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.entangle then
		self:Entangle()
	elseif sync == syncName.worm and rest then
		self:Worm(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Entangle()
	if self.db.profile.entangle then
		self:Message(L["msg_entangle"], "Urgent", true, "Alarm")
		self:WarningSign(icon.entangle, 2)
	end
end

function module:Worm(aNumber)
	if aNumber then
		aNumber = tonumber(aNumber)
		if aNumber == (module.worms + 1) then
			-- we accept this worm
			-- Yes, this could go completely wrong when you don't reset your module and the whole raid does after a wipe
			-- or you reset your module and the rest doesn't. Anyway. it'll work a lot better than anything else.
			module.worms = module.worms + 1
			if self.db.profile.worm then
				self:Message(string.format(L["msg_worm"], module.worms), "Urgent")
				self:Bar(string.format(L["bar_wormEnrage"], module.worms), timer.worm, icon.worm)
			end
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Entangle()
	module:Worm(1)

	module:BigWigs_RecvSync(syncName.entangle)
	module:BigWigs_RecvSync(syncName.worm, 1)
end
