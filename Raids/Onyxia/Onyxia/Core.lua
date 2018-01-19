------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.onyxia.onyxia
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "flamebreath", "deepbreath", "wingbuffet", "fireball", "phase", "onyfear", "bosskill" }


-- locals

module.timer = {
	firstFear = 9.3,
	fear = 29.5,
	fearCast = 1.5,
	wingbuffet = 1,
	flamebreath = 2,
	deepbreath = 5,
	fireball = 3,
}
local timer = module.timer

module.icon = {
	wingbuffet = "INV_Misc_MonsterScales_14",
	fear = "Spell_Shadow_Possession",
	deepbreath = "Spell_Fire_SelfDestruct",
	deepbreath_sign = "Spell_Fire_Lavaspawn",
	fireball = "Spell_Fire_FlameBolt",
	flamebreath = "Spell_Fire_Fire",
}
local icon = module.icon

module.syncName = {
	deepbreath = "OnyDeepBreath",
	phase2 = "OnyPhaseTwo",
	phase3 = "OnyPhaseThree",
	flamebreath = "OnyFlameBreath",
	fireball = "OnyFireball",
	fear = "OnyBellowingRoar",
}
local syncName = module.syncName

module.transitioned = false
module.phase = 0


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.phase2 then
		self:Phase2()
	elseif sync == syncName.phase3 then
		self:Phase3()
	elseif sync == syncName.deepbreath then
		self:DeepBreath()
	elseif sync == syncName.flamebreath then
		self:FlameBreath()
	elseif sync == syncName.fireball then
		self:Fireball()
	elseif sync == syncName.fear then
		self:Fear()
	end
end


------------------------------
-- Sync Handlers	    --
------------------------------
function module:Phase2()
	if module.phase < 2 then
		module.transitioned = true --to stop sending new syncs
		module.phase = 2
		if self.db.profile.phase then
			self:Message(L["msg_phase2"], "Important", false, "Alarm")
		end
	end
end

function module:Phase3()
	if self.db.profile.phase and module.phase < 3 then
		self:Message(L["msg_phase3"], "Important", true, "Beware")
		self:Bar(L["bar_fearNext"], timer.firstFear + timer.fearCast, icon.fear, true, "Orange")
		module.phase = 3
	end
end

function module:DeepBreath()
	if self.db.profile.deepbreath then
		self:Message(L["msg_deepBreath"], "Important", true, "RunAway")
		self:Bar(L["bar_deepBreath"], timer.deepbreath, icon.deepbreath, true, BigWigsColors.db.profile.significant)
		self:WarningSign(icon.deepbreath_sign, timer.deepbreath)
	end
end

function module:FlameBreath()
	if self.db.profile.flamebreath then
		self:Bar(L["bar_flameBreath"], timer.flamebreath, icon.flamebreath)
	end
end

function module:Fireball()
	if self.db.profile.fireball then
		self:Bar(L["bar_fireball"], timer.fireball, icon.fireball)
	end
end

function module:Fear()
	if self.db.profile.onyfear then
		self:RemoveBar(L["bar_fearNext"]) -- remove timer bar

		self:Message(L["msg_fear"], "Important", true, "Alarm")
		self:Bar(L["bar_fearCast"], timer.fearCast, icon.fear, true, "Orange") -- add cast bar
		self:DelayedBar(timer.fearCast, L["bar_fearNext"], timer.fear, icon.fear, true, "Orange") -- delayed timer bar
		self:WarningSign(icon.fear, 5)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Phase2()
	module:Phase3()
	module:DeepBreath()
	module:FlameBreath()
	module:Fireball()
	module:Fear()

	module:BigWigs_RecvSync(syncName.phase2)
	module:BigWigs_RecvSync(syncName.phase3)
	module:BigWigs_RecvSync(syncName.deepbreath)
	module:BigWigs_RecvSync(syncName.flamebreath)
	module:BigWigs_RecvSync(syncName.fireball)
	module:BigWigs_RecvSync(syncName.fear)
end
