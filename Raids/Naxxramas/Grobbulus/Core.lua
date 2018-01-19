------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.grobbulus
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"youinjected", "otherinjected", "icon", "cloud", -1, "enrage", "bosskill"}


-- locals
module.timer = {
	enrage = 720,
	inject = 10,
	cloud = 15,
}
local timer = module.timer

module.icon = {
	enrage = "INV_Shield_01",
	inject = "Spell_Shadow_CallofBone",
	cloud = "Ability_Creature_Disease_02",
}
local icon = module.icon

module.syncName = {
	inject = "GrobbulusInject",
	cloud = "GrobbulusCloud",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync( sync, rest, nick )
	if sync == syncName.inject and rest then
		self:Inject(rest)
	elseif sync == syncName.cloud then
		self:Cloud()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Inject(player)
	if player then
		if self.db.profile.youinjected and player == UnitName("player") then
			self:Message(L["msg_bombYou"], "Personal", true, "RunAway")
			self:WarningSign(icon.inject, timer.inject)
			
			self:Message(string.format(L["msg_bombOther"], player), "Attention", nil, nil, true)
			self:Bar(string.format(L["bar_bomb"], player), timer.inject, icon.inject)
		elseif self.db.profile.otherinjected then
			self:Message(string.format(L["msg_bombOther"], player), "Attention")
			--self:TriggerEvent("BigWigs_SendTell", player, L["msg_bombYou"]) -- can cause whisper bug on nefarian
			self:Bar(string.format(L["bar_bomb"], player), timer.inject, icon.inject)
		end
		if self.db.profile.icon then
			self:Icon(player, -1, timer.inject)
		end
	end
end

function module:Cloud()
	if self.db.profile.cloud then
		self:Message(L["msg_cloud"], "Urgent")
		self:Bar(L["bar_cloud"], timer.cloud, icon.cloud)			
	end
end


------------------------------
-- Utility	Functions   	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Inject(UnitName("player"))
	module:Cloud()
	
	module:BigWigs_RecvSync(syncName.inject, UnitName("player"))
	module:BigWigs_RecvSync(syncName.cloud)
end
