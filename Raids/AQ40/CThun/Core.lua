------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.cthun
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
module.eyeofcthun = AceLibrary("Babble-Boss-2.2")["Eye of C'Thun"]
module.cthun = AceLibrary("Babble-Boss-2.2")["C'Thun"]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = { module.eyeofcthun, module.cthun } -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "tentacle", "glare", "group", -1, "giant", "acid", "weakened", "proximity", "fleshtentacle", "bosskill" }

-- Proximity Plugin
module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end -- 11.11y range check
module.proximitySilent = false


-- locals
module.timer = {
	tentacleParty = 0, -- will be overriden at runtime
	p1RandomEyeBeams = 12, -- how long does eye of c'thun target the same player at the beginning
	p1Tentacle = 45, -- tentacle timers for phase 1
	p1TentacleStart = 45, -- delay for first tentacles from engage onwards
	p1GlareStart = 50, -- delay for first dark glare from engage onwards
	p1Glare = 85, -- interval for dark glare
	p1GlareCasting = 5, -- time it takes from casting dark glare until the spell starts
	p1GlareDuration = 30, -- duration of dark glare

	p2Offset = 10, -- delay for all timers to restart after the Eye dies
	p2Tentacle = 30, -- tentacle timers for phase 2
	p2ETentacle = 40, -- Eye tentacle timers for phase 2 40s
	p2GiantClaw = 40, -- Giant Claw timer for phase 2
	p2FirstGiantClaw = 25, -- first giant claw after eye of c'thun dies
	p2FirstGiantEye = 56, -- first giant eye after eye of c'thun dies
	p2FirstEyeTentacles = 45, -- first eye tentacles after eye of c'thun dies
	p2FirstGiantClawAfterWeaken = 10,
	p2FirstGiantEyeAfterWeaken = 40,
	reschedule = 50, -- delay from the moment of weakening for timers to restart
	target = 1, -- delay for target change checking on Eye of C'Thun and Giant Eye Tentacle
	weakened = 45, -- duration of a weaken

	lastEyeTentaclesSpawn = 0,
	lastGiantEyeSpawn = 0,
	eyeBeam = 2, -- Eye Beam Cast time
}
local timer = module.timer

module.icon = {
	giantEye = "inv_misc_eye_01", --"Interface\\Icons\\Ability_EyeOfTheOwl"
	giantClaw = "Spell_Nature_Earthquake",
	eyeTentacles = "spell_shadow_siphonmana", --"Interface\\Icons\\Spell_Nature_CallStorm"
	darkGlare = "Inv_misc_ahnqirajtrinket_04",
	weaken = "INV_ValentinesCandy",
	eyeBeamSelf = "Ability_creature_poison_05",
	digestiveAcid = "ability_creature_disease_02",
}
local icon = module.icon

module.syncName = {
	p2Start = "CThunP2Start1",
	weaken = "CThunWeakened2",
	weakenOver = "CThunWeakenedOver1",
	giantEyeDown = "CThunGEdown1",
	giantClawSpawn = "GiantClawSpawn1",
	giantEyeSpawn = "GiantEyeSpawn",
	tentaleParty = "TentacleParty",
	giantEyeEyeBeam = "GiantEyeEyeBeam1",
	cthunEyeBeam = "CThunEyeBeam1",
	fleshTentacleDeath = "CThunFleshTentacle",
}
local syncName = module.syncName

module.cthunstarted = nil
module.phase2started = nil
module.firstGlare = nil
--local target = nil

module.doCheckForWipe = false

module.fleshTentacle1Health = 100
module.fleshTentacle2Health = 100


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.p2Start then
		self:CThunP2Start()
	elseif sync == syncName.weaken then
		self:CThunWeakened()
	elseif sync == syncName.weakenOver then
		self:CThunWeakenedOver()
	elseif sync == syncName.giantEyeDown then
		self:Message(L["msg_giantEyeDown"], "Positive")
	elseif sync == syncName.giantEyeEyeBeam then
		self:GiantEyeEyeBeam()
	elseif sync == syncName.cthunEyeBeam then
		self:EyeBeam()
	elseif sync == syncName.giantClawSpawn then
		self:GiantClawTentacle()
	elseif sync == syncName.giantEyeSpawn then
		self:GiantEyeTentacle()
	elseif sync == syncName.tentaleParty then
		self:TentacleParty()
	elseif sync == syncName.fleshTentacleDeath then
		self:FleshTentacleDeath()
	end
end


-----------------------
-- Sync Handlers   --
-----------------------
function module:CThunStart()
	if not module.cthunstarted then
		module.cthunstarted = true
		module.doCheckForWipe = true

		self:Bar(L["bar_startRandomBeams"], timer.p1RandomEyeBeams, icon.giantEye)

		if self.db.profile.tentacle then
			self:Bar(L["bar_tentacleParty"], timer.p1TentacleStart, icon.eyeTentacles)
			self:DelayedMessage(timer.p1TentacleStart - 5, L["msg_tentacle"], "Urgent", false, "Alert")
		end

		module.firstGlare = true
		self:DarkGlare()

		-- fallback in case server script is .. lacking
		self:ScheduleEvent("bwcthuntentaclesstart", self.TentacleParty, timer.p1TentacleStart, self)

		self:Proximity()
	end
end

function module:CThunP2Start()
	if not module.phase2started then
		module.phase2started = true
		module.doCheckForWipe = false -- disable wipe check since we get out of combat, enable it later again
		timer.tentacleParty = timer.p2Tentacle

		self:Message(L["msg_phase2"], "Bosskill")

		-- cancel dark glare
		self:RemoveBar(L["bar_darkGlareNext"])
		self:RemoveBar(L["bar_darkGlareCast"])
		self:RemoveBar(L["bar_darkGlareEnd"])
		self:CancelScheduledEvent("bwcthundarkglare") -- ok
		self:CancelScheduledEvent("bwcthundarkglarestart") -- ok
		self:CancelDelayedBar(L["bar_darkGlareEnd"])
		self:CancelDelayedBar(L["bar_darkGlareNext"])
		self:RemoveWarningSign(icon.darkGlare)

		-- cancel eye tentacles
		self:RemoveBar(L["bar_tentacleParty"])
		self:CancelDelayedMessage(self.db.profile.rape and L["tentacle"] or L["msg_tentacle"])
		self:CancelScheduledEvent("bwcthuntentacles") -- ok
		self:CancelScheduledEvent("bwcthuntentaclesstart") -- ok

		-- cancel dark glare group warning
		self:CancelScheduledEvent("bwcthungroupwarning") -- ok
		self:CancelScheduledEvent("bwcthuntarget") -- ok
		self:CancelScheduledEvent("bwcthungroupwarningstart") -- ok

		self:RemoveBar(L["bar_startRandomBeams"])

		-- start P2 events
		if self.db.profile.tentacle then
			-- first eye tentacles
			self:DelayedMessage(timer.p2FirstEyeTentacles - 5, L["msg_tentacle"], "Urgent", false, nil, true)
			self:Bar(L["bar_tentacleParty"], timer.p2FirstEyeTentacles, icon.eyeTentacles)
		end

		if self.db.profile.giant then
			self:Bar(L["bar_giantEye"], timer.p2FirstGiantEye, icon.giantEye)
			self:DelayedMessage(timer.p2FirstGiantEye - 5, L["msg_giantEyeSoon"], "Urgent", false, nil, true)

			self:Bar(L["bar_giantClaw"], timer.p2FirstGiantClaw, icon.giantClaw)
		end

		if self.db.profile.fleshtentacle then
			self:SetupFleshTentacle()
		end

		--self:ScheduleEvent("bwcthunstarttentacles", self.TentacleParty, timer.p2FirstEyeTentacles, self)
		--self:ScheduleEvent("bwcthunstartgiant", self.GiantEyeTentacle, timer.p2FirstGiantEye, self )
		--self:ScheduleEvent("bwcthunstartgiantc", self.GiantClawTentacle, timer.p2FirstGiantClaw, self )

		timer.lastEyeTentaclesSpawn = GetTime() + 10

		self:RemoveProximity()
	end
end

function module:CThunWeakened()
	self:ThrottleSync(0.1, syncName.weakenOver)

	if self.db.profile.weakened then
		self:Message(L["msg_weakened"], "Positive")
		self:Sound("Murloc")
		self:Bar(L["bar_weakened"], timer.weakened, icon.weaken)
		self:Message(timer.weakened - 5, L["msg_weakenedOverSoon"], "Urgent")
	end

	-- cancel tentacle timers
	self:CancelDelayedMessage(self.db.profile.rape and L["tentacle"] or L["msg_tentacle"])
	self:CancelScheduledEvent("bwcthungtentacles") -- ok
	self:CancelScheduledEvent("bwcthungctentacles") -- ok
	self:CancelDelayedMessage(L["msg_giantEyeSoon"])
	self:CancelScheduledEvent("bwcthunstartgiant") -- ok

	self:RemoveBar(L["bar_tentacleParty"])
	self:RemoveBar(L["bar_giantEye"])
	self:RemoveBar(L["bar_giantClaw"])

	-- next eye tentacles 75s after last spawn / 45s delayed
	self:CancelScheduledEvent("bwcthuntentacles") -- ok
	local nextEyeTentacles = timer.p2Tentacle - (GetTime() - timer.lastEyeTentaclesSpawn) + timer.weakened;
	self:DebugMessage("nextEyeTentacles(" .. nextEyeTentacles .. ") = timer.p2Tentacle(" .. timer.p2Tentacle .. ") - (GetTime() - timer.lastEyeTentaclesSpawn)(" .. (GetTime() - timer.lastEyeTentaclesSpawn) .. ") + time.weakened(" .. timer.weakened .. ")")
	self:Bar(L["bar_tentacleParty"], nextEyeTentacles, icon.eyeTentacles)
	self:ScheduleEvent("bwcthunstarttentacles", self.TentacleParty, nextEyeTentacles, self)
	self:DelayedMessage(nextEyeTentacles - 5, L["msg_tentacle"], "Urgent", false, nil, true)

	self:ScheduleEvent("bwcthunweakenedover", self.CThunWeakenedOver, timer.weakened, self)
	timer.lastGiantEyeSpawn = 0 -- reset timer to force a refresh on the timer

	self:RemoveFleshTentacle()
end

function module:CThunWeakenedOver()
	self:ThrottleSync(600, syncName.weakenOver)

	self:CancelScheduledEvent("bwcthunweakenedover") -- ok

	if self.db.profile.weakened then
		self:RemoveBar(L["bar_weakened"])
		self:CancelDelayedMessage(L["msg_weakenedOverSoon"])

		self:Message(L["msg_weakenedOverNow"], "Important")
	end

	-- next giant claw 10s after weaken
	self:Bar(L["bar_giantClaw"], timer.p2FirstGiantClawAfterWeaken, icon.giantClaw)

	-- next giant eye 40s after weaken
	self:Bar(L["bar_giantEye"], timer.p2FirstGiantEyeAfterWeaken, icon.giantEye)

	if self.db.profile.fleshtentacle then
		self:SetupFleshTentacle()
	end
end

function module:GiantEyeEyeBeam()
	local timeSinceLastSpawn = GetTime() - timer.lastGiantEyeSpawn
	if timeSinceLastSpawn > 30 then
		timer.lastGiantEyeSpawn = GetTime()
		self:GiantEyeTentacle()
	end

	self:EyeBeam()
end

function module:DelayedEyeBeamCheck()
	local name = L["misc_unknown"]
	local eyeTarget = self:CheckTarget()
	if eyeTarget then
		name = eyeTarget
		self:Icon(name, -1, 2.5)
		if name == UnitName("player") then
			self:WarningSign(icon.eyeBeamSelf, 2 - 0.1)
		end
	end
	self:Bar(string.format(L["bar_eyeBeam"], name), timer.eyeBeam - 0.1, icon.giantEye, true, "green")
end

function module:EyeBeam()
	self:ScheduleEvent("CThunDelayedEyeBeamCheck", self.DelayedEyeBeamCheck, 0.1, self) -- has to be done delayed since the target change is delayed
end

function module:DigestiveAcid()
	if self.db.profile.acid then
		self:Message(L["msg_digestiveAcid"], "Red", true, "RunAway")
		self:WarningSign(icon.digestiveAcid, 5) --ability_creature_disease_02
	end
end


-----------------------
-- Utility Functions --
-----------------------
function module:CheckTarget()
	local i
	local newtarget = nil
	local enemy = module.eyeofcthun

	if module.phase2started then
		enemy = L["misc_gianteye"]
	end
	if UnitName("playertarget") == enemy then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i .. "target") == enemy then
				newtarget = UnitName("Raid" .. i .. "targettarget")
				break
			end
		end
	end

	return newtarget
end


-- P1
function module:DarkGlare()
	module.proximitySilent = true -- turn off beeping of the range check
	local function GlareOverSoon()
		module.proximitySilent = false -- turn on beeping of the range check
	end

	self:ScheduleEvent("bwcthunglareoversoon", GlareOverSoon, timer.p1GlareDuration - 5, self)

	if self.db.profile.glare then
		if module.firstGlare then
			self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timer.p1GlareStart, self)

			self:Bar(L["bar_darkGlareNext"], timer.p1GlareStart, icon.darkGlare)
			module.firstGlare = nil
		else
			self:ScheduleEvent("bwcthundarkglare", self.DarkGlare, timer.p1Glare, self)

			self:WarningSign(icon.darkGlare, 5)
			self:Message(L["msg_darkGlare"], "Urgent", true, "Beware")
			self:Bar(L["bar_darkGlareCast"], timer.p1GlareCasting, icon.darkGlare)

			self:DelayedBar(timer.p1GlareCasting, L["bar_darkGlareEnd"], timer.p1GlareDuration, icon.darkGlare)
			self:DelayedMessage(timer.p1GlareCasting + timer.p1GlareDuration - 5, L["msg_darkGlareEnds"], "Urgent", false, nil, true)
			self:DelayedBar(timer.p1GlareCasting + timer.p1GlareDuration, L["bar_darkGlareNext"], timer.p1Glare - timer.p1GlareCasting - timer.p1GlareDuration, icon.darkGlare)
		end
	end
end

-- P2
function module:GiantEyeTentacle()
	if module.phase2started then
		if self.db.profile.giant then
			timer.lastGiantEyeSpawn = GetTime()

			self:Bar(L["bar_giantEye"], timer.p2ETentacle, icon.giantEye)
			--self:DelayedMessage(timer.p2ETentacle - 5, L["msg_giantEyeSoon"], "Urgent", false, nil, true)

			self:WarningSign(icon.giantEye, 5)
		end
	end
end

function module:GiantClawTentacle()
	module.doCheckForWipe = true
	--self:CancelScheduledEvent("bwcthungctentacles") -- ok
	--self:ScheduleEvent("bwcthungctentacles", self.GiantClawTentacle, timer.p2GiantClaw, self )
	if module.phase2started then
		if self.db.profile.giant then
			self:Bar(L["bar_giantClaw"], timer.p2GiantClaw, icon.giantClaw)
		end
	end
end

function module:TentacleParty()
	timer.lastEyeTentaclesSpawn = GetTime()
	--self:ScheduleEvent("bwcthuntentacles", self.TentacleParty, timer.tentacleParty, self)
	if self.db.profile.tentacle then
		self:Bar(L["bar_tentacleParty"], timer.tentacleParty, icon.eyeTentacles)
		self:DelayedMessage(timer.tentacleParty - 5, L["msg_tentacle"], "Urgent", false, nil, true)
	end
end

function module:SetupFleshTentacle()
	module.fleshTentacle1Health = 100
	module.fleshTentacle2Health = 100
	self:TriggerEvent("BigWigs_StartHPBar", self, L["misc_fleshTentacleFirst"], 100)
	self:TriggerEvent("BigWigs_SetHPBar", self, L["misc_fleshTentacleFirst"], 0)
	self:TriggerEvent("BigWigs_StartHPBar", self, L["misc_fleshTentacleSecond"], 100)
	self:TriggerEvent("BigWigs_SetHPBar", self, L["misc_fleshTentacleSecond"], 0)

	self:ScheduleRepeatingEvent("bwcthunCheckFleshTentacleHP", self.UpdateFleshTentacle, 0.5, self)
end

function module:UpdateFleshTentacle()
	local health = self:GetFleshTentacleHealth()
	BigWigs:Print("UpdateFleshTentacle 1 " .. module.fleshTentacle1Health .. " 2 " .. module.fleshTentacle2Health .. " h " .. health)
	if health <= module.fleshTentacle1Health then
		module.fleshTentacle1Health = health
		self:TriggerEvent("BigWigs_SetHPBar", self, L["misc_fleshTentacleFirst"], 100 - module.fleshTentacle1Health)
	else
		module.fleshTentacle2Health = health
		self:TriggerEvent("BigWigs_SetHPBar", self, L["misc_fleshTentacleSecond"], 100 - module.fleshTentacle2Health)
	end
end

function module:GetFleshTentacleHealth()
	local health = 100
	if UnitName("playertarget") == L["misc_fleshTentacle"] then
		--if UnitName("playertarget") == "Ragged Timber Wolf" then
		health = UnitHealth("playertarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid" .. i .. "target") == L["misc_fleshTentacle"] then
				health = UnitHealth("Raid" .. i .. "target")
				break
			end
		end
	end

	-- 0 would remove the bar
	if health == 0 then
		health = 0.1
	end

	return health
end

function module:FleshTentacleDeath()
	module.fleshTentacle1Health = 0
	self:TriggerEvent("BigWigs_SetHPBar", self, L["misc_fleshTentacleFirst"], 99.9)
end

function module:RemoveFleshTentacle()
	module.fleshTentacle1Health = 100
	module.fleshTentacle2Health = 100
	self:TriggerEvent("BigWigs_StopHPBar", self, L["misc_fleshTentacleFirst"])
	self:TriggerEvent("BigWigs_StopHPBar", self, L["misc_fleshTentacleSecond"])
	self:CancelScheduledEvent("bwcthunCheckFleshTentacleHP")
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:CThunStart()
	module:CThunP2Start()
	module:CThunWeakened()
	module:CThunWeakenedOver()
	module:GiantEyeEyeBeam()
	module:DelayedEyeBeamCheck()
	module:EyeBeam()
	module:DigestiveAcid()

	module:CheckTarget()
	module:DarkGlare()
	module:GiantEyeTentacle()
	module:GiantClawTentacle()
	module:TentacleParty()
	module:SetupFleshTentacle()
	module:UpdateFleshTentacle()
	module:GetFleshTentacleHealth()
	module:FleshTentacleDeath()
	module:RemoveFleshTentacle()

	module:BigWigs_RecvSync(syncName.p2Start)
	module:BigWigs_RecvSync(syncName.weaken)
	module:BigWigs_RecvSync(syncName.weakenOver)
	module:BigWigs_RecvSync(syncName.giantEyeDown)
	module:BigWigs_RecvSync(syncName.giantEyeEyeBeam)
	module:BigWigs_RecvSync(syncName.cthunEyeBeam)
	module:BigWigs_RecvSync(syncName.giantClawSpawn)
	module:BigWigs_RecvSync(syncName.giantEyeSpawn)
	module:BigWigs_RecvSync(syncName.tentaleParty)
	module:BigWigs_RecvSync(syncName.fleshTentacleDeath)
end
