------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.viscidus
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "freeze", "volley", "toxinyou", "toxinother", "bosskill" }


-- locals
module.timer = {
	volley = {
		min = 11,
		max = 14,
	}
}
local timer = module.timer

module.icon = {
	volley = "Spell_Nature_CorrosiveBreath",
	toxin = "Spell_Nature_AbolishMagic",
}
local icon = module.icon

module.syncName = {
	volley = "ViscidusVolley",
	toxin = "ViscidusToxin"
}
local syncName = module.syncName


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.volley then
		self:Volley()
	elseif sync == syncName.toxin and rest then
		self:Toxin(rest)
	end
end


------------------------------
-- Sync Handlers	    --
------------------------------
function module:Volley()
	if self.db.profile.volley then
		self:Message(L["msg_volley"], "Urgent")
		self:Bar(L["bar_volley"], timer.volley, icon.volley)
	end
end

function module:Toxin(name)
	if name then

		if self.db.profile.toxinother and name ~= UnitName("player") then
			self:Message(pl .. L["msg_toxin"], "Important")
			--self:TriggerEvent("BigWigs_SendTell", pl, L["msg_toxinSelf"]) -- can cause whisper bug on nefarian
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Volley()
	module:Toxin(UnitName("player"))

	module:BigWigs_RecvSync(syncName.volley)
	module:BigWigs_RecvSync(syncName.toxin)
end
