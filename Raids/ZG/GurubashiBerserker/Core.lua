------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.gurubashiBerserker
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"fear", "knockback" --[[, "bosskill"]]}


-- locals
--[[
first knockback
	~8, 10, 10, ~9, 10, 9 => 9-12
knockback interval
	~12, 12, 12, 12, 13 => 12
	
first fear
	~15, 17, 17, ~1, 19, 2 => 1-19???
fear interval
	15, 15, 28 => 15
]]

module.timer = {
	firstFear = 15,
	fear = 15,
	firstKnockback = {
		min = 9,
		max = 12,
	},
	knockback = 12
}
local timer = module.timer

module.icon = {
	fear = "Ability_GolemThunderClap",
	knockback = "INV_Gauntlets_05"
}
local icon = module.icon

module.syncName = {
	fear = "BerserkerFear",
	knockback = "BerserkerKnockback"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick )
	if sync == syncName.fear then
		self:Fear()
	elseif sync == syncName.knockback then
		self:Knockback()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Fear()
	if self.db.profile.fear then
		self:Bar(L["bar_fear"], timer.fear, icon.fear)
	end
end

function module:Knockback()	
	if self.db.profile.knockback then
		self:Bar(L["bar_knockback"], timer.knockback, icon.knockback)
	end
end


------------------------------
--      Utility	Functions   --
------------------------------

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.fear)
	module:BigWigs_RecvSync(syncName.knockback)
end
