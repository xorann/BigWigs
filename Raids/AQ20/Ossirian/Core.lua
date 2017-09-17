------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq20.ossirian
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"supreme", "debuff", "bosskill"}

-- locals
module.timer = {
	weakness = 45,
	supreme = 45,
}
local timer = module.timer

module.icon = {
	supreme = "Spell_Shadow_CurseOfTounges",
}
local icon = module.icon

module.syncName = {
	weakness = "OssirianWeakness",
	crystal = "OssirianCrystal",
	supreme = "OssirianSupreme",
}
local syncName = module.syncName

module.currentWeakness = nil
module.timeLastWeaken = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.weakness and rest then
		self:Weakness(rest)
	elseif sync == syncName.crystal then
		self:Crystal()
	elseif sync == syncName.supreme then
		self:Supreme()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Weakness(weakness, delay)
	if not weakness then
        return
    end
    if not delay then
		delay = 0
	end
	
	module.timeLastWeaken = GetTime()
	module.currentWeakness = weakness

	if self.db.profile.debuff then
		self:Message(string.format(L["msg_debuff"], L[tostring(weakness)]), "Important")
		self:Bar(L[weakness], timer.weakness - delay, L[weakness .. "Icon"])
	end

	self:RemoveBar(L["bar_supreme"])
	self:CancelDelayedMessage(string.format(L["msg_supremeSoon"], 15))
	self:CancelDelayedMessage(string.format(L["msg_supremeSoon"], 10))
	self:CancelDelayedMessage(string.format(L["msg_supremeSoon"], 5))

	if self.db.profile.supreme then
		self:DelayedMessage(timer.supreme - delay, string.format(L["msg_supremeSoon"], 15), "Attention", nil, nil, true)
		self:DelayedMessage(timer.supreme - delay, string.format(L["msg_supremeSoon"], 10), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.supreme - delay, string.format(L["msg_supremeSoon"], 5), "Important", nil, nil, true)
		self:Bar(L["bar_supreme"], timer.supreme - delay, icon.supreme)
	end
end

function module:Crystal()
	if module.timeLastWeaken + 3 < GetTime() then -- crystal trigger occurs 2s after weaken trigger
		self:Weakness(module.currentWeakness, 2)
	end
end

function module:Supreme()
	if self.db.profile.supreme then
		self:Message(L["msg_supreme"], "Attention", nil, "Beware")
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Weakness("Shadow", 0)
	module:Crystal()
	module:Supreme()
	
	module:BigWigs_RecvSync(syncName.weakness, "Shadow")
	module:BigWigs_RecvSync(syncName.crystal)
	module:BigWigs_RecvSync(syncName.supreme)
end
