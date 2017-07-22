------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.defenders
local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "plagueyou", "plagueother", "icon", -1, "thunderclap", "explode", "enrage" --[[, "bosskill"]] }

module.defaultDB = {
	enrage = false,
	bosskill = nil,
}

-- locals
module.timer = {
	explode = 6,
}
local timer = module.timer

module.icon = {
	explode = "",
	plague = "Spell_Shadow_CurseOfTounges",
}
local icon = module.icon

module.syncName = {
	enrage = "DefenderEnrage",
	explode = "DefenderExplode",
	thunderclap = "DefenderThunderclap",
}
local syncName = module.syncName


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.explode then
		self:Explosion()
	elseif sync == syncName.enrage then
		self:Enrage()
	elseif sync == syncName.thunderclap then
		self:Thunderclap()
	elseif sync == syncName.plague and rest then
		self:Plague(rest)
	end
end


------------------------------
-- Sync Handlers	    --
------------------------------
function module:Explosion()
	if self.db.profile.explode then
		self:Message(L["msg_explode"], "Important", nil, "Beware")
		self:Bar(L["msg_explode"], timer.explode, icon.explode)
	end
end

function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important")
	end
end

function module:Thunderclap()
	if self.db.profile.thunderclap then
		self:Message(L["msg_thunderclap"], "Important")
	end
end

function module:Plague(name)
	if self.db.profile.plagueother then
		self:Message(string.format(L["msg_plague"], name), "Attention")
		--self:TriggerEvent("BigWigs_SendTell", pplayer, L["msg_plagueYou"]) -- can cause whisper bug on nefarian
	end

	if self.db.profile.icon then
		self:Icon(name)
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Explosion()
	module:Enrage()
	module:Thunderclap()
	module:Plague(UnitName("player"))

	module:BigWigs_RecvSync(syncName.explode)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.thunderclap)
	module:BigWigs_RecvSync(syncName.plague, UnitName("player"))
end
