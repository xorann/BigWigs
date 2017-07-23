------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.broodlord
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "ms", "bw", "bosskill" }


-- locals
module.timer = {
	blastWave = 12,
	mortalStrike = 5,
}
local timer = module.timer

module.icon = {
	blastWave = "Spell_Holy_Excorcism_02",
	mortalStrike = "Ability_Warrior_SavageBlow",
}
local icon = module.icon

module.syncName = {}
local syncName = module.syncName

module.lastBlastWave = 0
module.lastMS = 0
module.MS = ""


------------------------------
-- Utility		     		--
------------------------------
function module:MortalStrike(name)
	if self.db.profile.ms then
		if name == UnitName("player") then
			self:Message(L["msg_mortalStrikeYou"], "Core", true, "Beware")
			self:WarningSign(icon.mortalStrike, timer.mortalStrike)
		else
			self:Message(string.format(L["msg_mortalStrikeOther"], name), "Core", true, "Alarm")
		end

		self:Bar(string.format(L["bar_mortalStrike"], name), timer.mortalStrike, icon.mortalStrike, true, "Black")
		self:SetCandyBarOnClick("BigWigsBar " .. string.format(L["bar_mortalStrike"], name), function(name, button, extra) TargetByName(extra, true) end, name)
	end
end

function module:BlastWave()
	if self.db.profile.bw then
		self:Bar(L["bar_blastWave"], timer.blastWave, icon.blastWave, true, "Red")
	end
end

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:MortalStrike(UnitName("player"))
	module:BlastWave()
end
