------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.jindo
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"curse", "hex", "brainwash", "healingward", "puticon", "bosskill"}


-- locals
module.timer = {
	firstHex = 8,
	firstHealing = 12,
	firstBrainwash = 21,
    healing = 18, -- varies from 16.9 to 18.6
    brainwash = 25, -- varies from 22.9 to 26.8
	healingUptime = 240,
	brainwashUptime = 240,
	hex = 5,
}
local timer = module.timer

module.icon = {
	hex = "Spell_Nature_Polymorph",
	healing = "Spell_Holy_LayOnHands",
	brainwash = "Spell_Totem_WardOfDraining",
}
local icon = module.icon

module.syncName = {
	curse = "JindoCurse",
	hex = "JindoHexStart",
	hexOver = "JindoHexStop",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.curse and rest then
		if self.db.profile.curse then
			if rest == UnitName("player") then
				self:Message(L["msg_curseWhisper"], "Attention")
			else
				self:Message(string.format(L["msg_curseOther"], rest), "Urgent")
				self:TriggerEvent("BigWigs_SendTell", rest, L["msg_curseWhisper"])
			end
		end
		if self.db.profile.puticon then 
			self:Icon(rest)
		end
	elseif sync == syncName.hex and rest and self.db.profile.hex then
        self:RemoveBar("Next Hex")
		self:Message(string.format(L["msg_hex"], rest), "Important")
		self:Bar(string.format(L["bar_hex"], rest), timer.hex, icon.hex, true, "White")
	elseif sync == syncName.hexOver and rest and self.db.profile.hex then
		self:RemoveBar(string.format(L["bar_hex"], rest))
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:BigWigs_RecvSync(syncName.curse, UnitName("player"))
	module:BigWigs_RecvSync(syncName.hex, UnitName("player"))
	module:BigWigs_RecvSync(syncName.hexOver, UnitName("player"))
end
