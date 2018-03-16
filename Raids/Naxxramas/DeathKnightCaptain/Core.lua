--[[
    Created by Dorann
--]]

------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.deathKnightCaptain
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20015 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"whirlwind"}
module.trashMod = true

-- locals
module.timer = {
	whirlwindFirst = {
		min = 5,
		max = 10,
	},
	whirlwindCast = 2,
	whirlwindInterval = {
		min = 20,
		max = 25
	}
}
local timer = module.timer

module.icon = {
	whirlwind = "ability_whirlwind"
}
local icon = module.icon

module.syncName = {
	whirlwind = "DeathKnightCaptainWhirlwind",
	death = "DeathKnightCaptainDeath"
}
local syncName = module.syncName


module.deathCount = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.whirlwind then
		self:Whirlwind()
	elseif sync == syncName.death then
		self:Death()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Whirlwind()
	if self.db.profile.whirlwind then		
		self:Bar(L["bar_whirlwind"], timer.whirlwindCast, icon.whirlwind, true, BigWigsColors.db.profile.significant)
		self:Bar(L["bar_whirlwindNext"], timer.whirlwindInterval, icon.whirlwind)
	end
end

function module:Death(msg)
	module.deathCount = module.deathCount + 1
	if module.deathCount == 2 then
		BigWigs:CheckForBossDeath(msg, self)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Whirlwind()
	
	module:BigWigs_RecvSync(syncName.whirlwind)
end
