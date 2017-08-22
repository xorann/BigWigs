------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.ayamiss
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"sacrifice", "bosskill"}

-- locals
module.timer = {}
local timer = module.timer

module.icon = {}
local icon = module.icon

module.syncName = {
	sacrifice = "AyamissSacrifice"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.sacrifice and rest then
		self:Sacrifice(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Sacrifice(name)
	if self.db.profile.sacrifice then 
		self:Message(name .. L["msg_sacrifice"], "Important") 
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Sacrifice(UnitName("player"))

	module:BigWigs_RecvSync(syncName.sacrifice, UnitName("player"))
end
