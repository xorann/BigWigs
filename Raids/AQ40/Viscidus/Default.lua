local bossName = BigWigs.bossmods.aq40.viscidus
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)


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
-- Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckVis")
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
-- Event Handlers      --
------------------------------
function module:CheckVis(arg1)
	if string.find(arg1, L["trigger_volley"]) then
		self:Sync(syncName.volley)

	elseif string.find(arg1, L["trigger_toxin"]) then
		local _, _, player, ty = string.find(arg1, L["trigger_toxin"])
		if player == L["misc_you"] and ty == L["misc_are"] then
			player = UnitName("player")
			if self.db.profile.toxinyou then
				self:Message(L["msg_toxinSelf"], "Personal", true, "RunAway")
				self:WarningSign("Spell_Nature_AbolishMagic", 5)
			end
		end

		if player then
			self:Sync(syncName.toxin, player)
		end
	end
end

function module:Emote(arg1)
	if not self.db.profile.freeze then return end
	if arg1 == L["trigger_slow"] then
		self:Message(L["msg_freeze1"], "Atention")
	elseif arg1 == L["trigger_freeze"] then
		self:Message(L["msg_freeze2"], "Urgent")
	elseif arg1 == L["trigger_frozen"] then
		self:Message(L["msg_frozen"], "Important")
	elseif arg1 == L["trigger_crack"] then
		self:Message(L["msg_crack1"], "Urgent")
	elseif arg1 == L["trigger_shatter"] then
		self:Message(L["msg_crack2"], "Important")
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
	module:CheckVis(L["trigger_volley"])
	module:CheckVis(L["trigger_toxin"])
	module:Emote(L["trigger_slow"])
	module:Emote(L["trigger_freeze"])
	module:Emote(L["trigger_frozen"])
	module:Emote(L["trigger_crack"])
	module:Emote(L["trigger_shatter"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
