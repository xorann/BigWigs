------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.buru
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"you", "other", "icon", "bosskill"}

-- locals
module.timer = {}
local timer = module.timer

module.icon = {}
local icon = module.icon

module.syncName = {
	watch = "BuruWatch",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.watch and rest then
		self:Watch(rest)
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Watch(name)
	if name then
		if name == UnitName("player") and self.db.profile.you then
			self:Message(L["msg_watchYou"], "Personal", true, "RunAway")
			self:Message(UnitName("player") .. L["msg_watchOther"], "Attention", nil, nil, true)
		elseif self.db.profile.other then
			self:Message(string.format(L["msg_watchOther"], name), "Attention")
			self:TriggerEvent("BigWigs_SendTell", name, L["msg_watchYou"])
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Watch(UnitName("player"))

	module:BigWigs_RecvSync(syncName.watch, UnitName("player"))
end
