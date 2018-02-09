local bossName = BigWigs.bossmods.aq40.bugFamily
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end

--BigWigs:Print("classic-wow " .. bossName)


------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Melee")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Melee")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Spells")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Spells")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Spells")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Spells")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Spells")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Spells")

	self:ThrottleSync(5, syncName.volley)
	self:ThrottleSync(5, syncName.heal)
	self:ThrottleSync(5, syncName.healStop)
	self:ThrottleSync(5, syncName.panic)
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(5, syncName.kriDead)
	self:ThrottleSync(5, syncName.yaujDead)
	self:ThrottleSync(5, syncName.vemDead)
	self:ThrottleSync(5, syncName.allDead)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	module.kridead = nil
	module.vemdead = nil
	module.yaujdead = nil
	module.healtime = 0
	module.castingheal = false

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.panic then
		self:Bar(L["bar_panicFirst"], timer.firstPanic, icon.panic, true, BigWigsColors.db.profile.fear)
	end
	if self.db.profile.toxicvolley then
		self:Bar(L["bar_toxicVolley"], timer.firstVolley, icon.volley, true, "green")
		self:DelayedMessage(timer.firstVolley - 3, L["msg_toxicVolley"], "Urgent")
	end
	if self.db.profile.enrage then
		self:Bar(L["bar_enrage"], timer.enrage, icon.enrage, true, BigWigsColors.db.profile.enrage)
		self:DelayedMessage(timer.enrage - 5 * 60, L["msg_enrage5m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 3 * 60, L["msg_enrage3m"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 90, L["msg_enrage90"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 60, L["msg_enrage90"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 30, L["msg_enrage30"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.enrage - 10, L["msg_enrage10"], "Attention", nil, nil, true)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)

	if msg == string.format(UNITDIESOTHER, module.kri) then
		self:Sync(syncName.kriDead)
	elseif msg == string.format(UNITDIESOTHER, module.yauj) then
		self:Sync(syncName.yaujDead)
	elseif msg == string.format(UNITDIESOTHER, module.vem) then
		self:Sync(syncName.vemDead)
	end
end

function module:Melee(msg)
	if string.find(msg, L["trigger_attack1"])
			or string.find(msg, L["trigger_attack2"])
			or string.find(msg, L["trigger_attack3"])
			or string.find(msg, L["trigger_attack4"]) then

		if module.castingheal then
			if (GetTime() - module.healtime) < timer.heal then
				self:Sync(syncName.healStop)
			elseif (GetTime() - module.healtime) >= timer.heal then
				module.castingheal = false
			end
		end
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["trigger_heal"] then
		self:Sync(syncName.heal)
	end
end

function module:Spells(msg)
	local _,_,toxicvaporsother,_ = string.find(msg, L["trigger_toxicVaporsOther"])
	if self.engaged and (string.find(msg, L["trigger_panic"]) or string.find(msg, L["trigger_panicResist"]) or string.find(msg, L["trigger_panicImmune"])) then
		self:Sync(syncName.panic)
	elseif string.find(msg, L["trigger_toxicVolleyHit"]) or string.find(msg, L["trigger_toxicVolleyAfflicted"]) or string.find(msg, L["trigger_toxicVolleyResist"]) or string.find(msg, L["trigger_toxicVolleyImmune"]) then
		self:Sync(syncName.volley)
	elseif msg == L["trigger_toxicVaporsYou"] and self.db.profile.announce then
		self:Message(L["msg_toxicVapors"], "Attention", "Alarm")
	elseif toxicvaporsother and self.db.profile.announce then
		--self:TriggerEvent("BigWigs_SendTell", toxicvaporsother, L["msg_toxicVapors"]) -- can cause whisper bug on nefarian
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_enrage"])
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, module.kri))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, module.yauj))
	module:CHAT_MSG_COMBAT_HOSTILE_DEATH(string.format(UNITDIESOTHER, module.vem))
	module:Melee(L["trigger_attack1"])
	module:Melee(L["trigger_attack2"])
	module:Melee(L["trigger_attack3"])
	module:Melee(L["trigger_attack4"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_heal"])
	module:Spells(L["trigger_toxicVaporsOther"])
	module:Spells(L["trigger_panic"])
	module:Spells(L["trigger_panicResist"])
	module:Spells(L["trigger_panicImmune"])
	module:Spells(L["trigger_toxicVolleyHit"])
	module:Spells(L["trigger_toxicVolleyAfflicted"])
	module:Spells(L["trigger_toxicVolleyResist"])
	module:Spells(L["trigger_toxicVolleyImmune"])
	module:Spells(L["trigger_toxicVaporsYou"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
