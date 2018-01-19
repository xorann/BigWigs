------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.geddon
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
-- module.wipemobs = { L["misc_addName"] }
module.toggleoptions = {"inferno", "service", "bomb", "mana", "announce", "icon", "bosskill"}



-- locals
module.timer = {
	bomb = 8,
	inferno = 8,
	nextInferno = 30,
    firstIgnite = 20,
	ignite = 29,
	service = 8,
}
local timer = module.timer

module.icon = {
	bomb = "Inv_Enchant_EssenceAstralSmall",
	bombSign = "Spell_Shadow_MindBomb",
	inferno = "Spell_Fire_Incinerate",
	ignite = "Spell_Fire_Incinerate",
	service = "Spell_Fire_SelfDestruct",
}
local icon = module.icon

module.syncName = {
	bomb = "GeddonBombX",
	bombStop = "GeddonBombStop",
	inferno = "GeddonInferno1",
	ignite = "GeddonManaIgniteX",
	service = "GeddonServiceX",
}
local syncName = module.syncName


module.firstinferno = true
module.firstignite = true


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.bomb and rest then
		self:Bomb(rest)
	elseif sync == syncName.bombStop and rest then
		self:BombGone(rest)
	elseif sync == syncName.inferno then
        self:Inferno()
	elseif sync == syncName.ignite then
		self:ManaIgnite()
	elseif sync == syncName.service then
		self:Service()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Bomb(name)
	if self.db.profile.bomb then
		self:Bar(string.format(L["bar_bomb"], name), timer.bomb, icon.bomb, true, BigWigsColors.db.profile.significant)
		if name == UnitName("player") then
			self:Message(L["msg_bombYou"], "Attention", "RunAway")
			self:WarningSign(icon.bombSign, timer.bomb)
		else
			self:Message(string.format(L["msg_bombOther"], name), "Attention")
		end
	end
	
	if self.db.profile.icon then
		self:Icon(name, -1, timer.bomb)
	end
	
	if self.db.profile.announce then
		self:TriggerEvent("BigWigs_SendTell", bombother, L["msg_bombWhisper"])
	end
end

function module:BombGone(name)
	if self.db.profile.bomb then
		self:RemoveBar(string.format(L["bar_bomb"], name))
	end
end

function module:Inferno()	
	if self.db.profile.inferno then
		if self.firstinferno then
			self:Bar(L["bar_infernoNext"], timer.nextInferno, icon.inferno)
            self.firstinferno = false
		else
			self:Message(L["msg_infernoNow"], "Important")
			self:Bar(L["bar_infernoChannel"], timer.inferno, icon.inferno)
			self:DelayedBar(timer.inferno, L["bar_infernoNext"], timer.nextInferno - timer.inferno, icon.inferno)
		end
	
		self:DelayedMessage(timer.nextInferno - 5, L["msg_infernoSoon"], "Urgent", nil, nil, true)
	end
	
	self.firstinferno = false
end

function module:ManaIgnite()
	if self.db.profile.mana then
		if not self.firstignite then
			self:Message(L["msg_ignite"], "Important")
            self:Bar(L["bar_ignite"], timer.ignite, icon.ignite)
		else
            self:Bar(L["bar_ignite"], timer.firstIgnite, icon.ignite)
        end
        self.firstignite = false
	end
end

function module:Service()
	if self.db.profile.service then
		self:Bar(L["bar_service"], timer.service, icon.service)
		self:Message(L["msg_service"], "Important")
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Service()
	module:ManaIgnite()
	module:Inferno()
	module:Bomb(UnitName("player"))
	module:BombGone(UnitName("player"))	
	
	module:BigWigs_RecvSync(syncName.bomb, UnitName("player"))
	module:BigWigs_RecvSync(syncName.bombStop, UnitName("player"))
	module:BigWigs_RecvSync(syncName.inferno)
	module:BigWigs_RecvSync(syncName.ignite)
	module:BigWigs_RecvSync(syncName.service)
end
