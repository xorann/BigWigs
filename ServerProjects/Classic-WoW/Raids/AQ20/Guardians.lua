local bossName = BigWigs.bossmods.aq20.guardians
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
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckPlague")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

-- override to suppress victory message and sound
function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, AceLibrary("Babble-Boss-2.2")[bossName]) then
		self.core:ToggleModuleActive(self, false)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.explode and msg == L["trigger_explode"] then 
		self:Message(L["msg_explode"], "Important")
	elseif self.db.profile.enrage and msg == L["trigger_enrage"] then 
		self:Message(L["msg_enrage"], "Important")
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.summon and msg == L["trigger_summonGuardian"] then 
		self:Message(L["msg_summonGuard"], "Attention")
	elseif self.db.profile.summon and msg == L["trigger_summonWarrior"] then 
		self:Message(L["msg_summonWarrior"], "Attention")
	end
end

function module:CheckPlague( msg )
	local _,_, player, type = string.find(msg, L["trigger_plague"])
	if player and type then
		if self.db.profile.plagueyou and player == L["misc_you"] and type == L["misc_are"] then
			self:Message(L["msg_plagueYou"], "Personal", true)
			self:Message(UnitName("player") .. L["msg_plagueOther"], "Attention", nil, nil, true )
		elseif self.db.profile.plagueother then
			self:Message(player .. L["msg_plagueOther"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["msg_plagueYou"])
		end

		if self.db.profile.icon then
			self:Icon(player)
		end
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
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_explode"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_summonGuardian"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(L["trigger_summonWarrior"])
	module:CheckPlague(L["trigger_plague"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
