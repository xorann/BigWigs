------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.golemagg
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"earthquake", "enraged", "bosskill"}


-- locals
module.timer = {}
local timer = module.timer

module.icon = {}
local icon = module.icon

module.syncName = {
	earthquake = "GolemaggEarthquake",
	enrage = "GolemaggEnrage",
}
local syncName = module.syncName

module.earthquakeon = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.earthquake then
		self:Earthquake()
	elseif sync == syncName.enrage then
		self:Enrage()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Earthquake()
	if self.db.profile.earthquake then
		self:Message(L["msg_earthquakeSoon"], "Attention", "Alarm")
	end
end

function module:Enrage()
	if self.db.profile.enraged then
		self:Message(L["msg_enrage"], "Attention", true, "Beware")
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Earthquake()
	module:Enrage()
	
	module:BigWigs_RecvSync(syncName.earthquake)
	module:BigWigs_RecvSync(syncName.enrage)
end
