
------------------------------
--      Variables     		--
------------------------------

local bossName = BigWigs.bossmods.aq40.skeram
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mc", "split", "bosskill"}

-- locals
module.timer = {
	mc = 20,
}
local timer = module.timer

module.icon = {
	mc = "Spell_Shadow_Charm",
}
local icon = module.icon

module.syncName = {
	mc = "SkeramMC",
	mcOver = "SkeramMCEnd",
	split80 = "SkeramSplit80Soon",
	split75 = "SkeramSplit75Now",
	split55 = "SkeramSplit55Soon",
	split50 = "SkeramSplit50Now",
	split30 = "SkeramSplit30Soon",
	split25 = "SkeramSplit25Now",
}
local syncName = module.syncName

module.splittime = false


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.split80 then
		self:SplitSoon()
	elseif sync == syncName.split55 then
		self:SplitSoon()
	elseif sync == syncName.split30 then
		self:SplitSoon()
	elseif sync == syncName.split75 then
		self:Split()
	elseif sync == syncName.split50 then
		self:Split()
	elseif sync == syncName.split25 then
		self:Split()
	elseif sync == syncName.mc and rest then
		self:MindControl(rest)
	elseif sync == syncName.mcOver and rest then
		self:MindControlGone(rest)
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

function module:MindControl(name)
	if self.db.profile.mc then
		if name == UnitName("player") then
			self:Bar(string.format(L["bar_mc"], UnitName("player")), timer.mc, icon.mc, true, "White")
			self:Message(L["msg_mcPlayer"], "Attention")
		else
			self:Bar(string.format(L["bar_mc"], name), timer.mc, icon.mc, true, "White")
			self:Message(string.format(L["msg_mcOther"], name), "Urgent")
		end
	end
end

function module:MindControlGone(name)
	if self.db.profile.mc then
		self:RemoveBar(string.format(L["bar_mc"], name))
	end
end

function module:SplitSoon()
	module.splittime = true
	if self.db.profile.split then
		self:Message(L["msg_splitSoon"], "Urgent")
	end
end

function module:Split()
	module.splittime = false
	if self.db.profile.split then
		self:Message(L["msg_split"], "Important", "Alarm")
	end
end


----------------------------------
-- 		Module Test Function    --
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	local name = UnitName("player")
	module:MindControl(name)
	module:MindControl("Someplayer")
	module:MindControlGone(name)
	module:SplitSoon()
	module:Split()
	module:BigWigs_RecvSync(syncName.split80)
	module:BigWigs_RecvSync(syncName.split55)
	module:BigWigs_RecvSync(syncName.split30)
	module:BigWigs_RecvSync(syncName.split75)
	module:BigWigs_RecvSync(syncName.split50)
	module:BigWigs_RecvSync(syncName.split25)
	module:BigWigs_RecvSync(syncName.mc, name)
	module:BigWigs_RecvSync(syncName.mcOver, name)
end