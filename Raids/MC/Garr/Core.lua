------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.garr
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"adds", "bosskill"}


module.defaultDB = {
	adds = false,
}

-- locals
module.timer = {}
local timer = module.timer

module.icon = {}
local icon = module.icon

module.syncName = {
	addDeath = "GarrAddDead"
}
local syncName = module.syncName


module.adds = 0

------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.addDeath and rest then
        local newCount = tonumber(rest)
		self:AddDeath(newCount)
    end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:AddDeath(number)
	if number and self.adds < number then
		self.adds = number
		if self.db.profile.adds then
			self:Message(L["msg_add" .. number], "Positive")
			--self:TriggerEvent("BigWigs_SetCounterBar", self, L["bar_adds"], (8 - number))
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:AddDeath(1)
	
	module:BigWigs_RecvSync(syncName.addDeath, 1)
end
