------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.razorgore
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
local controller = AceLibrary("Babble-Boss-2.2")["Grethok the Controller"]
module.enabletrigger = { module.translatedName, controller } -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "phase", "mobs", "eggs", "polymorph", "mc", "icon", "orb", "fireballvolley", "conflagration", "ktm", "bosskill" }


-- locals
module.timer = {
	mobspawn = 35,
	mc = 15,
	polymorph = 20,
	conflagrate = 10,
	volley = 2,
	egg = 3,
	orb = 90,
}
local timer = module.timer

module.icon = {
	mobspawn = "Spell_Holy_PrayerOfHealing",
	egg = "INV_Misc_MonsterClaw_02",
	eggDestroyed = "inv_egg_01",
	orb = "INV_Misc_Gem_Pearl_03",
	volley = "Spell_Fire_FlameBolt",
	conflagrate = "Spell_Fire_Incinerate",
	mindControl = "Spell_Shadow_ShadowWordDominate",
	polymorph = "Spell_Nature_Brilliance",
}
local icon = module.icon

module.syncName = {
	egg = "RazorgoreEgg",
	eggStart = "RazorgoreEggStart",
	orb = "RazorgoreOrbStart_", -- 19 characters
	orbOver = "RazorgoreOrbStop_",
	volley = "RazorgoreVolleyCast",
	phase2 = "RazorgorePhaseTwo",
}
local syncName = module.syncName

module.doCheckForWipe = nil

------------------------------
-- Override CheckForWipe  	--
------------------------------
function module:CheckForWipe(event)
    if module.doCheckForWipe then
        BigWigs:DebugMessage("doCheckForWipe")
        BigWigs:CheckForWipe(self)
    end
end


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.egg and rest then
		self:EggDestroyed(rest)
	elseif sync == syncName.eggStart then
		self:DestroyingEgg()
	elseif string.find(sync, syncName.orb) then
		local name = string.sub(sync, 19)
		self:OrbStart(name)
	elseif string.find(sync, syncName.orbOver) then
		self:OrbEnd()
	elseif sync == syncName.volley then
		self:Volley()
	elseif sync == syncName.phase2 then
		self:Phase2()
	end
end

------------------------------
-- Sync Handlers	    --
------------------------------
function module:EggDestroyed(number)
	number = tonumber(number)
	if number == (self.eggs + 1) and self.eggs <= 30 then
		self.eggs = self.eggs + 1
		if self.db.profile.eggs then
			self:Message(string.format(L["msg_egg"], self.eggs), "Positive")
		end
		self:TriggerEvent("BigWigs_SetCounterBar", self, "Eggs destroyed", (30 - self.eggs))
	elseif number == (self.eggs + 1) and number == 30 and self.phase ~= 2 then
		self:Sync(syncName.phase2)
	end
end

function module:DestroyingEgg()
	--self:CancelScheduledEvent("destroyegg_check")
	--self:ScheduleEvent("destroyegg_check", self.DestroyEggCheck, 3, self)
	if self.db.profile.eggs then
		self:Bar(L["bar_egg"], timer.egg, icon.egg, true, "white")
	end
	self:Sync(syncName.egg .. " " .. tostring(self.eggs + 1))
end

function module:OrbStart(name)
	self:CancelScheduledEvent("destroyegg_check")
	self:CancelScheduledEvent("orbcontrol_check")

	if self.db.profile.orb then
		if self.previousorb ~= nil then
			self:RemoveBar(string.format(L["bar_orb"], self.previousorb))
		end
		self:Bar(string.format(L["bar_orb"], name), timer.orb, icon.orb, true, "white")
		self:SetCandyBarOnClick("BigWigsBar " .. string.format(L["bar_orb"], name), function(name, button, extra)
			TargetByName(extra, true)
		end, name)
	end
	self:ScheduleEvent("orbcontrol_check", self.OrbControlCheck, 1, self)
	self.previousorb = name
end

function module:OrbEnd()
	self:CancelScheduledEvent("destroyegg_check")
	self:CancelScheduledEvent("orbcontrol_check")

	if self.db.profile.orb and self.previousorb then
		self:Bar(string.format(L["bar_orb"], self.previousorb), timer.orb, icon.orb, true, "white")
	end
	if self.db.profile.fireballvolley then
		self:RemoveBar(L["bar_volley"])
	end
	if self.db.profile.eggs then
		self:RemoveBar(L["bar_egg"])
	end
end

function module:Volley()
	if self.db.profile.fireballvolley then
		self:Bar(L["bar_volley"], timer.volley, icon.volley)
		self:Message(L["msg_volley"], "Urgent")
		self:WarningSign(icon.volley, 2)
	end
end

function module:Conflagration()
	if self.db.profile.conflagration then
		self:Bar(L["bar_conflagration"], timer.conflagrate, icon.conflagrate)
	end
end

function module:Phase2()
	if self.phase < 2 then
		self.phase = 2
		self:CancelScheduledEvent("destroyegg_check")
		self:CancelScheduledEvent("orbcontrol_check")
		if self.previousorb ~= nil and self.db.profile.orb then
			self:RemoveBar(string.format(L["bar_orb"], self.previousorb))
		end
		if self.db.profile.eggs then
			self:RemoveBar(L["bar_egg"])
		end
		if self.db.profile.phase then
			self:Message(L["msg_phase2"], "Attention")
		end

		self:KTM_SetTarget(self.translatedName)
		self:KTM_Reset()
	end
end


----------------------------------
-- Utility			    		--
----------------------------------
function module:Engaged()
	if self.db.profile.phase then
		self:Message(L["msg_engage"], "Attention")
	end
	if self.db.profile.mobs then
		self:Bar(L["bar_mobs"], timer.mobspawn, icon.mobspawn, true, "Cyan")
		self:Message(timer.mobspawn - 5, L["msg_mobsSoon"], "Important")
	end
	self:TriggerEvent("BigWigs_StartCounterBar", self, "Eggs destroyed", 30, "Interface\\Icons\\" .. icon.eggDestroyed)
	self:TriggerEvent("BigWigs_SetCounterBar", self, "Eggs destroyed", (30 - 0.1))
	
	-- do not check for wipe until the first wave of mobs since we get out of combat in between
	module.doCheckForWipe = false
	function DelayCheckForWipe()
		module.doCheckForWipe = true
	end
	self:ScheduleEvent("BigWigsRazorgoreDelayedCheckForWipe", DelayCheckForWipe, timer.mobspawn + 5, self)
end

function module:MindControl(name)
	if self.db.profile.icon then
		self:Icon(name)
	end

	if self.db.profile.mc then
		self:Message(string.format(L["msg_mindControlOther"], name), "Important")
		self:Bar(string.format(L["bar_mindControl"], name), timer.mc, icon.mindControl, true, "Purple")
		self:SetCandyBarOnClick("BigWigsBar " .. string.format(L["bar_mindControl"], name), function(name, button, extra) TargetByName(extra, true) end, name)
	end
end

function module:MindControlGone(name)
	self:RemoveBar(string.format(L["bar_mindControl"], name))
end

function module:Polymorph(name)
	if self.db.profile.polymorph then
		self:Message(string.format(L["msg_polymorphOther"], name), "Important")
		self:Bar(string.format(L["bar_polymorph"], name), timer.polymorph, icon.polymorph)
		self:SetCandyBarOnClick("BigWigsBar " .. string.format(L["bar_polymorph"], name), function(name, button, extra) TargetByName(extra, true) end, name)
	end
end

function module:PolymorphGone(name)
	self:RemoveBar(string.format(L["bar_polymorph"], name))
end

function module:OrbControlCheck()
	local bosscontrol = false
	for i = 1, GetNumRaidMembers() do
		if UnitName("raidpet" .. i) == self.translatedName then
			bosscontrol = true
			break
		end
	end
	if bosscontrol then
		self:ScheduleEvent("orbcontrol_check", self.OrbControlCheck, 1, self)
	elseif GetRealZoneText() == "Blackwing Lair" then
		self:Sync(syncName.orbOver .. self.previousorb)
	end
end

function module:DestroyEggCheck()
	local bosscontrol = false
	for i = 1, GetNumRaidMembers() do
		if UnitName("raidpet" .. i) == self.translatedName then
			bosscontrol = true
			break
		end
	end
	if bosscontrol then
		--self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(self.eggs + 1))
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:BigWigs_RecvSync(syncName.egg, 1)
	module:BigWigs_RecvSync(syncName.eggStart)
	module:BigWigs_RecvSync(syncName.orbOver)
	module:BigWigs_RecvSync(syncName.volley)
	module:BigWigs_RecvSync(syncName.phase2)
end
