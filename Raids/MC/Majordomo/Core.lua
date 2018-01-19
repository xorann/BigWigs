------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.mc.majordomo
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.wipemobs = { L["misc_eliteName"], L["misc_healerName"] }
module.toggleoptions = {"magic", "dmg", "adds", "bosskill"}

module.defaultDB = {
	adds = false,
}

-- locals
module.timer = {
	shieldDuration = 10,
	shieldInterval = 15,
	firstShield = 15,
}
local timer = module.timer

module.icon = {
	shield = "Spell_Shadow_DetectLesserInvisibility",
	magic = "Spell_Frost_FrostShock",
	dmg = "Spell_Shadow_AntiShadow",
}
local icon = module.icon

module.syncName = {
	dmg = "DomoAuraDamage",
	magic = "DomoAuraMagic",
	healerDead = "DomoHealerDead",
	eliteDead = "DomoEliteDead",
}
local syncName = module.syncName

module.healerDead = nil
module.eliteDead = nil


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)    
    if sync == syncName.healerDead and rest and rest ~= "" then
        rest = tonumber(rest)
        self:HealerDeath(rest)
	elseif sync == syncName.eliteDead and rest and rest ~= "" then
        rest = tonumber(rest)
        self:EliteDeath(rest)
	elseif sync == syncName.magic then
		self:MagicShield()
	elseif sync == syncName.dmg then
		self:DamageShield()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:HealerDeath(number)
	if number and self.healerDead and number <= 4 and self.healerDead < number then
		self.healerDead = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_healerDeath"], self.healerDead), "Positive")
			--self:TriggerEvent("BigWigs_SetCounterBar", self, "Priests dead", (4 - self.healerDead))
		end
	end
end

function module:EliteDeath(number)
	if number and number <= 4 and (not self.eliteDead or self.eliteDead < number) then
		self.eliteDead = number
		if self.db.profile.adds then
			self:Message(string.format(L["msg_eliteDeath"], self.eliteDead), "Positive")
			--self:TriggerEvent("BigWigs_SetCounterBar", self, "Elites dead", (4 - self.eliteDead))
		end
	end
end

function module:MagicShield()
	if self.db.profile.magic then
		self:RemoveBar(L["bar_nextShield"])
		self:Message(L["msg_magic"], "Attention")
		self:Bar(L["bar_magic"], timer.shieldDuration, icon.magic)
	end
	
	if self.db.profile.magic or self.db.profile.dmg then
		self:DelayedBar(timer.shieldDuration, L["bar_nextShield"], timer.shieldInterval - timer.shieldDuration, icon.shield)
		self:DelayedMessage(timer.shieldInterval - 5, L["msg_shieldSoon"], "Urgent", nil, nil, true)
	end
end

function module:DamageShield()
	if self.db.profile.dmg then
        self:RemoveBar(L["bar_nextShield"])
		self:Message(L["msg_dmg"], "Attention")
		self:Bar(L["bar_dmg"], timer.shieldDuration, icon.dmg)
	end
	
	if self.db.profile.magic or self.db.profile.dmg then
		self:DelayedBar(timer.shieldDuration, L["bar_nextShield"], timer.shieldInterval - timer.shieldDuration, icon.shield)
		self:DelayedMessage(timer.shieldInterval - 5, L["msg_shieldSoon"], "Urgent", nil, nil, true)
	end
end



----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:DamageShield()
	module:MagicShield()
	module:EliteDeath(1)
	module:HealerDeath(1)
	
	module:BigWigs_RecvSync(syncName.healerDead, 1)
	module:BigWigs_RecvSync(syncName.eliteDead, 1)
	module:BigWigs_RecvSync(syncName.magic)
	module:BigWigs_RecvSync(syncName.dmg)
end
