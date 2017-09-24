------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.zg.jeklik
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]


-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"phase", "heal", "flay", "fear", "swarm", "bomb", "announce", "bosskill"}


-- locals
module.timer = {
	firstFear = 23,
	fear = 22,
	firstSilence = 31,
	healCast = 4,
	nextHeal = 20,
	fear2 = 39.5,
	fireBombs = 10,
	mindflay = 10,
	bats = 68,
}
local timer = module.timer

module.icon = {
	fear = "Spell_Shadow_SummonImp",
	fear2 = "Spell_Shadow_PsychicScream", 
	silence = "Spell_Frost_Iceshock",
	fire = "Spell_Fire_Lavaspawn",
	bomb = "Spell_Fire_Fire",
	mindflay = "Spell_Shadow_SiphonMana",
	heal = "Spell_Holy_Heal",
	bats = "Spell_Fire_SelfDestruct",
}
local icon = module.icon

module.syncName = {
	fear = "JeklikFearRep",
	fear2 = "JeklikFearTwoRep",
	mindflay = "JeklikMindFlay",
	mindflayOver = "JeklikMindFlayEnd",
	heal = "JeklikHeal",
	healOver = "JeklikHealStop",
	bombBats = "JeklikBombBats",
	swarmBats = "JeklikSwarmBats",
	phase2 = "JeklikPhaseTwo",
}
local syncName = module.syncName


module.phase          = nil
module.lastHeal       = nil
module.castingheal    = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.phase2 and self.phase < 2 then
        self.phase = 2
		self:KTM_Reset()
		if self.db.profile.phase then
			self:Message(L["msg_phaseTwo"], "Attention")
		end
		if self.db.profile.fear then
			self:RemoveBar(L["bar_fear"])
			self:Bar(L["bar_fear"], timer.fear2, icon.fear2)
		end
        self:Bar("Fire Bombs", timer.fireBombs, icon.bomb)
	elseif sync == syncName.fear and self.db.profile.fear then
		self:Bar(L["bar_fear"], timer.fear, icon.fear, true, "Orange")
	elseif sync == syncName.fear2 then
		if self.db.profile.fear then
			self:Bar(L["bar_fear"], timer.fear2, icon.fear2)
		end
		if self.db.profile.heal then
			self:RemoveBar(L["bar_heal"])			
		end
	elseif sync == syncName.swarmBats and self.db.profile.swarm then
		self:Message(L["msg_swarm"], "Urgent")
	elseif sync == syncName.bombBats and self.db.profile.bomb then
		self:Message(L["msg_bomb"], "Urgent")
	elseif sync == syncName.mindflay then
		if self.db.profile.flay then
			self:RemoveBar(L["bar_mindFlay"])
			self:Bar(L["bar_mindFlay"], timer.mindflay, icon.mindflay)
		end
		if self.db.profile.heal then
			self:RemoveBar(L["bar_heal"])			
		end
	elseif sync == syncName.mindflayOver and self.db.profile.flay then
		self:RemoveBar(L["bar_mindFlay"])
	elseif sync == syncName.heal then
		self.lastHeal = GetTime()
		self.castingheal = 1
		if self.db.profile.heal then
            self:RemoveBar("Next Heal")
			self:Message(L["msg_heal"], "Important", "Alarm")
			self:Bar(L["bar_heal"], timer.healCast, icon.heal, true, "Blue")
		end
	elseif sync == syncName.healOver then
		self.castingheal = 0
		if self.db.profile.heal then
			self:RemoveBar(L["bar_heal"])
            if (self.lastHeal + timer.nextHeal) > GetTime() then
                self:Bar("Next Heal", (self.lastHeal + timer.nextHeal - GetTime()), icon.heal)
            end
		end
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
	module:BigWigs_RecvSync(syncName.phase2)
	module:BigWigs_RecvSync(syncName.fear)
	module:BigWigs_RecvSync(syncName.fear2)
	module:BigWigs_RecvSync(syncName.swarmBats)
	module:BigWigs_RecvSync(syncName.bombBats)
	module:BigWigs_RecvSync(syncName.mindflay)
	module:BigWigs_RecvSync(syncName.mindflayOver)
	module:BigWigs_RecvSync(syncName.healOver)
end
