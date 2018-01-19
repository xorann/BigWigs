------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.gehennas
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_flamewakerName"] }
module.toggleoptions = {"adds", "curse", "rain", "bosskill"}


module.defaultDB = {
	adds = false,
}

-- locals
module.timer = {
	firstCurse = 20,
	firstRain = 4,
	rainTick = 2,
	rainDuration = 6,
	nextRain = 19, -- 12, 18
	curse = 30,
}
local timer = module.timer

module.icon = {
	curse = "Spell_Shadow_BlackPlague",
	rain = "Spell_Shadow_RainOfFire",
}
local icon = module.icon

module.syncName = {
	curse = "GehennasCurse1",
	add = "GehennasAddDead"
}
local syncName = module.syncName


module.flamewaker = 0

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.curse then
		self:Curse()
	elseif sync == syncName.add and rest and rest ~= "" then
        rest = tonumber(rest)
        self:AddDeath(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Curse()
	if self.db.profile.curse then
		self:DelayedMessage(timer.curse - 5, L["msg_curseSoon"], "Urgent", nil, nil, true)
		self:Bar(L["bar_curse"], timer.curse, icon.curse)
	end
end

function module:AddDeath(number)
	if number and number <= 2 and module.flamewaker < number then
		module.flamewaker = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_add"], module.flamewaker), "Positive")
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Curse()
	module:AddDeath(1)
	
	module:BigWigs_RecvSync(syncName.curse)
	module:BigWigs_RecvSync(syncName.add, 1)
end
