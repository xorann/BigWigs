------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.ouro
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "sweep", "sandblast", -1, "emerge", "submerge", -1, "berserk", "bosskill" }


-- locals
module.timer = {
	firstSweep = {
		min = 35,
		max = 40,
	},
	nextSubmerge = 90,
	sweep = 1.5,
	sweepInterval = 20,
	sandblast = 2,
	sandblastInterval = {
		min = 22,
		max = 25,
	},
	nextEmerge = 30,
}
local timer = module.timer

module.icon = {
	sweep = "Spell_Nature_Thorns",
	sandblast = "Spell_Nature_Cyclone",
	submerge = "Spell_Nature_Earthquake",
}
local icon = module.icon

module.syncName = {
	sweep = "OuroSweep",
	sandblast = "OuroSandblast",
	emerge = "OuroEmerge2",
	submerge = "OuroSubmerge3",
	berserk = "OuroBerserk",
}
local syncName = module.syncName

module.berserkannounced = nil


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.sweep then
		self:Sweep()
	elseif sync == syncName.sandblast then
		self:Sandblast()
	elseif sync == syncName.emerge then
		self:Emerge()
	elseif sync == syncName.submerge then
		self:Submerge()
	elseif sync == syncName.berserk then
		self:Berserk()
	end
end


------------------------------
-- Sync Handlers	    --
------------------------------
function module:Sweep()
	if self.db.profile.sweep then
		self:RemoveBar(L["bar_sweep"]) -- remove timer bar
		self:RemoveBar(L["bar_sweepFirst"])
		self:Bar(L["bar_sweep"], timer.sweep, icon.sweep) -- show cast bar
		self:Message(L["msg_sweep"], "Important", true, "Alarm")
		self:DelayedMessage(timer.sweepInterval - 5, L["msg_sweepSoon"], "Important", nil, nil, true)
		self:Bar(L["bar_sweep"], timer.sweepInterval + timer.sweep, icon.sweep)
	end
end

function module:Sandblast()
	if self.db.profile.sandblast then
		self:RemoveBar(L["bar_sandBlast"]) -- remove timer bar
		self:Bar(L["msg_sandBlastNow"], timer.sandblast, icon.sandblast) -- show cast bar
		self:Message(L["msg_sandBlastNow"], "Important", true, "Alert")
		self:DelayedMessage(timer.sandblastInterval.min - 5, L["msg_sandBlastSoon"], "Important", nil, nil, true)
		self:Bar(L["bar_sandBlast"], timer.sandblastInterval, icon.sandblast)
	end
end

function module:DoSubmergeCheck()
	self:ScheduleRepeatingEvent("bwourosubmergecheck", self.SubmergeCheck, 1, self)
end

function module:Emerge()
	if self.phase ~= "berserk" then
		self.phase = "emerged"

		self:CancelScheduledEvent("bwourosubmergecheck")
		self:ScheduleEvent("bwourosubmergecheck", self.DoSubmergeCheck, 10, self)
		self:CancelScheduledEvent("bwsubmergewarn")
		self:RemoveBar(L["bar_emerge"])

		if self.db.profile.emerge then
			self:Message(L["msg_emerge"], "Important", false, "Beware")
			self:PossibleSubmerge()
		end
	end
end

function module:Submerge()
	self:CancelDelayedMessage(L["msg_sweepSoon"])
	self:CancelDelayedMessage(L["msg_sandBlastSoon"])
	self:CancelDelayedMessage(L["msg_submergeSoon"])

	local sweepRegistered, sweepTime, sweepElapsed = self:BarStatus(L["bar_sweep"])
	local sandblastRegistered, sandblastTime, sandblastElapsed = self:BarStatus(L["bar_sandBlast"])

	self:RemoveBar(L["bar_sweep"])
	self:RemoveBar(L["bar_sweepFirst"])
	self:RemoveBar(L["bar_sandBlast"])
	self:RemoveBar(L["bar_submerge"])

	-- show next sweep after emerge
	if sweepRegistered and self.db.profile.sweep then
		local remaining = sweepTime - sweepElapsed
		local nextSweep = timer.nextEmerge + remaining
		self:Bar(L["bar_sweep"], nextSweep, icon.sweep)
	end
	-- show next sand blast after emerge
	if sandblastRegistered and self.db.profile.sandblast then
		local remaining = sandblastTime - sandblastElapsed
		local nextSandblast = timer.nextEmerge + remaining
		self:Bar(L["bar_sandBlast"], nextSandblast, icon.sandblast)
	end

	self.phase = "submerged"

	if self.db.profile.submerge then
		self:Message(L["msg_submerge"], "Important")
		self:ScheduleEvent("bwsubmergewarn", "BigWigs_Message", timer.nextEmerge - 5, L["msg_emergeSoon"], "Important")
		self:Bar(L["bar_emerge"], timer.nextEmerge, icon.submerge)
	end
end

function module:Berserk()
	self.phase = "berserk"

	self:CancelDelayedMessage(L["msg_submergeSoon"])
	self:RemoveBar(L["bar_submerge"])
	if self:IsEventRegistered("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF") then
		self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	end

	if self.db.profile.berserk then
		self:Message(L["msg_berserk"], "Important", true, "Beware")
	end
end


------------------------------
-- Utility	Functions   --
------------------------------
function module:PossibleSubmerge()
	if self.db.profile.emerge then
		self:DelayedMessage(timer.nextSubmerge - 15, L["msg_submergeSoon"], "Important", nil, nil, true)
		self:Bar(L["bar_submerge"], timer.nextSubmerge, icon.submerge)
	end
end

function module:SubmergeCheck()
	-- if the player is dead he can't see ouro: omit this check
	if self.phase == "emerged" then
		if not UnitIsDeadOrGhost("player") and not self:IsOuroVisible() then
			self:DebugMessage("OuroSubmerge")
			self:Sync(syncName.submerge)
		end
	end
end

function module:EngageCheck()
	if not self.engaged then
		if self:IsOuroVisible() then
			module:CancelScheduledEvent("bwouroengagecheck")

			module:SendEngageSync()
		end
	else
		module:CancelScheduledEvent("bwouroengagecheck")
	end
end

function module:IsOuroVisible()
	if UnitName("playertarget") == self.submergeCheckName then
		return true
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i .. "target") == self.submergeCheckName then
				return true
			end
		end
	end

	return false
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Sweep()
	module:Sandblast()
	module:DoSubmergeCheck()
	module:Emerge()
	module:Submerge()
	module:Berserk()
	module:PossibleSubmerge()
	module:SubmergeCheck()
	module:EngageCheck()
	module:IsOuroVisible()

	module:BigWigs_RecvSync(syncName.sweep)
	module:BigWigs_RecvSync(syncName.sandblast)
	module:BigWigs_RecvSync(syncName.emerge)
	module:BigWigs_RecvSync(syncName.submerge)
	module:BigWigs_RecvSync(syncName.berserk)
end
