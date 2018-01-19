------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.moam
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"adds", "paralyze", "bosskill"}

-- locals
module.timer = {
	paralyze = 90,
	unparalyze = 90,
}
local timer = module.timer

module.icon = {
	paralyze = "Spell_Shadow_CurseOfTounges",
	unparalyze = "Spell_Shadow_CurseOfTounges"
}
local icon = module.icon

module.syncName = {
	paralyze = "MoamParalyze",
	unparalyze = "MoamUnparalyze",
}
local syncName = module.syncName

module.firstunparalyze = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.paralyze then
		self:Paralyze()
	elseif sync == syncName.unparalyze then
		self:Unparalyze()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Paralyze()
	if self.db.profile.adds then
		self:Message(L["msg_addsNow"], "Important")
	end
	if self.db.profile.paralyze then
		self:DelayedMessage(timer.paralyze - 60, format(L["msg_returnSoon"], 60), "Attention", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 30, format(L["msg_returnSoon"], 30), "Attention", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 15, format(L["msg_returnSoon"], 15), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 5, format(L["msg_returnSoon"], 5), "Important", nil, nil, true)
		self:Bar(L["bar_paralyze"], timer.paralyze, icon.paralyze)
	end
end

function module:Unparalyze()
	if module.firstunparalyze then
		module.firstunparalyze = false
	elseif self.db.profile.paralyze then 
		self:Message(L["msg_returnNow"], "Important") 
	end
	
	if self.db.profile.adds then
		self:DelayedMessage(timer.unparalyze - 60, format(L["msg_addsSoon"], 60), "Attention", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 30, format(L["msg_addsSoon"], 30), "Attention", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 15, format(L["msg_addsSoon"], 15), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 5, format(L["msg_addsSoon"], 5), "Important", nil, nil, true)
		self:Bar(L["bar_adds"], timer.unparalyze, icon.unparalyze) 
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Unparalyze()
	module:Paralyze()
	
	module:BigWigs_RecvSync(syncName.paralyze)
	module:BigWigs_RecvSync(syncName.unparalyze)
end
