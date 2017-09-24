------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.aq40.bugFamily
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

module.kri = AceLibrary("Babble-Boss-2.2")["Lord Kri"]
module.yauj = AceLibrary("Babble-Boss-2.2")["Princess Yauj"]
module.vem = AceLibrary("Babble-Boss-2.2")["Vem"]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = { module.kri, module.yauj, module.vem } -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "panic", "toxicvolley", "heal", "announce", "deathspecials", "enrage", "bosskill" }


-- locals
module.timer = {
	firstPanic = {
		min = 15,
		max = 20,
	},
	panic = 20,
	firstVolley = 11.4,
	volley = 5,
	enrage = 900,
	heal = 2,
}
local timer = module.timer

module.icon = {
	panic = "Spell_Shadow_DeathScream",
	volley = "Spell_Nature_Corrosivebreath",
	enrage = "Spell_Shadow_UnholyFrenzy",
	heal = "Spell_Holy_Heal",
}
local icon = module.icon

module.syncName = {
	volley = "BugTrioKriVolley",
	heal = "BugTrioYaujHealStart",
	healStop = "BugTrioYaujHealStop",
	panic = "BugTrioYaujPanic",
	enrage = "BugTrioEnraged",
	kriDead = "BugTrioKriDead",
	yaujDead = "BugTrioYaujDead",
	vemDead = "BugTrioVemDead",
	allDead = "BugTrioAllDead",
}
local syncName = module.syncName

module.kridead = nil
module.vemdead = nil
module.yaujdead = nil
module.healtime = 0
module.castingheal = false


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.volley then
		self:Volley()
	elseif sync == syncName.heal then
		self:Heal()
	elseif sync == syncName.healStop then
		self:HealStop()
	elseif sync == syncName.panic then
		self:Panic()
	elseif sync == syncName.enrage then
		self:Enrage()
	elseif sync == syncName.kriDead then
		self:KriDead()
	elseif sync == syncName.yaujDead then
		self:YaujDead()
	elseif sync == syncName.vemDead then
		self:VemDead()
	elseif sync == syncName.allDead then
		self:SendBossDeathSync()
	end
end

------------------------------
-- Sync Handlers	    --
------------------------------
function module:Volley()
	if self.db.profile.toxicvolley then
		self:Bar(L["bar_toxicVolley"], timer.volley, icon.volley)
	end
end

function module:Heal()
	module.healtime = GetTime()
	module.castingheal = true
	if self.db.profile.heal then
		self:Bar(L["bar_heal"], timer.heal, icon.heal, true, "Blue")
		self:Message(L["msg_heal"], "Attention", true, "Alert")
	end
end

function module:HealStop()
	module.castingheal = false
	self:RemoveBar(L["bar_heal"])
end

function module:Panic()
	if self.db.profile.panic then
		self:Bar(L["bar_panic"], timer.panic, icon.panic, true, "Orange")
		self:Message(L["msg_panic"], "Urgent", true, "Alarm")
	end
end

function module:Enrage()
	if self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important")
	end
end

function module:KriDead()
	module.kridead = true

	-- cancel
	self:RemoveBar(L["bar_toxicVolley"])
	self:CancelDelayedMessage(L["msg_toxicVolley"])

	if self.db.profile.deathspecials then
		self:Message(L["msg_kriDead"], "Positive")
	end
	if module.vemdead and module.yaujdead then
		self:Sync(syncName.allDead)
	end
end

function module:YaujDead()
	module.yaujdead = true

	-- cancel
	self:RemoveBar(L["bar_heal"])
	self:RemoveBar(L["bar_panic"])
	self:CancelDelayedMessage(L["msg_panic"])

	if self.db.profile.deathspecials then
		self:Message(L["msg_yaujDead"], "Positive")
	end
	if module.vemdead and module.kridead then
		self:Sync(syncName.allDead)
	end
end

function module:VemDead()
	module.vemdead = true
	if module.yaujdead and module.kridead then
		if self.db.profile.deathspecials then
			self:Message(L["msg_vemDead"], "Positive")
		end
		self:Sync(syncName.allDead)
	elseif module.yaujdead then
		if self.db.profile.deathspecials then
			self:Message(L["msg_vemDeadKriEnrage"], "Positive")
		end
	elseif module.kridead then
		if self.db.profile.deathspecials then
			self:Message(L["msg_vemDeadYaujEnrage"], "Positive")
		end
	elseif not module.kridead and not module.yaujdead then
		if self.db.profile.deathspecials then
			self:Message(L["msg_vemDeadBothEnrage"], "Positive")
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
	module:Heal()
	module:HealStop()
	module:Panic()
	module:Enrage()
	module:KriDead()
	module:YaujDead()
	module:VemDead()

	module:BigWigs_RecvSync(syncName.volley)
	module:BigWigs_RecvSync(syncName.heal)
	module:BigWigs_RecvSync(syncName.healStop)
	module:BigWigs_RecvSync(syncName.panic)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.kriDead)
	module:BigWigs_RecvSync(syncName.yaujDead)
	module:BigWigs_RecvSync(syncName.vemDead)
	module:BigWigs_RecvSync(syncName.allDead)
end
