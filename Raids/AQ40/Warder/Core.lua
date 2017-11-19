------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.warder
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"fear", "silence", "roots", "dust", "warnings" --[[, "bosskill"]]}


-- locals
module.timer = {
	fear = {
		min = 17,
		max = 20
	},
	fearCast = 1.5,
	silence = {
		min = 17,
		max = 20
	},
	silenceCast = 1.5,
	roots = {
		min = 17,
		max = 20
	},
	rootsCast = 1.5,
	dust = {
		min = 17,
		max = 20
	},
	dustCast = 1.5,
	firstAbility = 10.5,
	secondAbility = 14.5,
}
local timer = module.timer

module.icon = {
	fear = "Spell_Shadow_Possession",
	silence = "Spell_Holy_Silence",
	roots = "Spell_Nature_StrangleVines",
	dust = "Ability_Hibernation",
	unknown = "INV_Misc_QuestionMark",
}
local icon = module.icon

module.syncName = {
	fear = "WarderFear",
	silence = "WarderSilence",
	roots = "WarderRoots",
	dust = "WarderDust",
}
local syncName = module.syncName

module.warnings = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.fear then
		self:Fear()
	elseif sync == syncName.silence then
		self:Silence()
	elseif sync == syncName.roots then
		self:Roots()
	elseif sync == syncName.dust then
		self:Dust()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Fear()
	if self.db.profile.fear then
		--self:RemoveBar(L["bar_possibleFear"])
		self:Bar(L["bar_fear"], timer.fearCast, icon.fear, true, BigWigsColors.db.profile.fear)
		self:DelayedBar(timer.fearCast, L["bar_possibleFear"], timer.fear.min - timer.fearCast, icon.fear, true, BigWigsColors.db.profile.fear)
	end
	self:AbilityWarn("fear")
end

function module:Silence()
	if self.db.profile.silence then
		--self:RemoveBar(L["bar_possibleSilence"])
		self:Bar(L["bar_silence"], timer.silenceCast, icon.silence)
		self:DelayedBar(timer.silenceCast, L["bar_possibleSilence"], timer.silence.min - timer.silenceCast, icon.silence)
	end
	self:AbilityWarn("silence")
end

function module:Roots()
	if self.db.profile.roots then
		--self:RemoveBar(L["bar_possibleRoots"])
		self:Bar(L["bar_roots"], timer.rootsCast, icon.roots)
		self:DelayedBar(timer.rootsCast, L["bar_possibleRoots"], timer.roots.min - timer.rootsCast, icon.roots)
	end
	self:AbilityWarn("roots")
end

function module:Dust()
	if self.db.profile.dust then
		--self:RemoveBar(L["bar_possibleDust"])
		self:Bar(L["bar_dust"], timer.dustCast, icon.dust)
		self:DelayedBar(timer.dustCast, L["bar_possibleDust"], timer.dust.min - timer.dustCast, icon.dust)
	end
	self:AbilityWarn("dust")
end

function module:AbilityWarn(ability)
	if self.db.profile.warnings then
		if not self.ability1 then
			self.ability1 = ability
			self:Message(string.format("%s + %s", module.warnings[self.ability1][1], module.warnings[self.ability1][2]), "Important", nil, "Long")
		elseif not self.ability2 and ability ~= self.ability1 then
			self.ability2 = ability
			self:Message(string.format("%s + %s", module.warnings[self.ability1][1], module.warnings[self.ability2][1]), "Important", nil, "Long")
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Fear()
	module:Silence()
	module:Roots()
	module:Dust()
	module:AbilityWarn("fear")
	module:AbilityWarn("silence")
	module:AbilityWarn("roots")
	module:AbilityWarn("dust")

	module:BigWigs_RecvSync(syncName.fear)
	module:BigWigs_RecvSync(syncName.silence)
	module:BigWigs_RecvSync(syncName.roots)
	module:BigWigs_RecvSync(syncName.dust)
end
