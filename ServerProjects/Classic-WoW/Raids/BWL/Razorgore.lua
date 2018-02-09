local bossName = BigWigs.bossmods.bwl.razorgore
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

------------------------------
-- Initialization      		--
------------------------------

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Events")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Events")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")

	self:ThrottleSync(5, syncName.egg)
	self:ThrottleSync(5, syncName.orb .. "(.+)")
	self:ThrottleSync(5, syncName.orbOver .. "(.+)")
	self:ThrottleSync(3, syncName.volley)
end


-- called after module is enabled and after each wipe
function module:OnSetup()
	self.phase = 0
	self.previousorb = nil
	self.eggs = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Engaged()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
-- Event Handlers      		--
------------------------------
function module:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["trigger_phase2"] then
		self:Sync(syncName.phase2)
	elseif msg == L["trigger_destroyEgg1"] or msg == L["trigger_destroyEgg2"] or msg == L["trigger_destoryEgg3"] then
		self:Sync(syncName.egg .. " " .. tostring(self.eggs + 1))
		
		if self.eggs == 30 then
			self:Sync(syncName.phase2)
		end
	end
end

function module:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	if string.find(msg, L["trigger_egg"]) then
		self:Sync(syncName.eggStart)
	end
end

-- does not work on nefarian
function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, "Razorgore the Untamed casts Destroy Egg") then
		-- as of now, this does also fire on finished 'Destroy Egg' cast.
		-- but only after a successful one and the range is shitty of this emote.
		self:Sync(syncName.egg .. " " .. tostring(self.eggs + 1))
	elseif string.find(msg, "Nefarian's troops flee as the power") then
		-- there is a really funny emote text bug on the current version on Nostalris, I'll only use this in case they fix it
		self:Sync(syncName.phase2)
	end
end

function module:Events(msg)
	local _, _, mcother = string.find(msg, L["trigger_mindControlOtherGain"])
	local _, _, mcotherend = string.find(msg, L["trigger_mindControlOtherGone"])
	local _, _, polyother = string.find(msg, L["trigger_polymorphOtherGain"])
	local _, _, polyotherend = string.find(msg, L["trigger_polymorphOtherGone"])
	local _, _, orbother = string.find(msg, L["trigger_orbControlOther"])
	--local _, _, deathother = string.find(msg, L["trigger_deathOther"])

	if mcother then
		self:MindControl(mcother)
	elseif msg == L["trigger_mindControlYouGain"] then
		self:MindControl(UnitName("player"))
	elseif mcotherend then
		self:MindControlGone(mcotherend)
	elseif msg == L["trigger_mindControlYouGone"] then
		self:MindControlGone(UnitName("player"))
	elseif polyother then
		self:Polymorph(polyother)
	elseif msg == L["trigger_polymorphYouGain"] then
		self:Polymorph(UnitName("player"))
	elseif polyotherend then
		self:PolymorphGone(polyotherend)
	elseif msg == L["trigger_polymorphYouGone"] then
		self:PolymorphGone(UnitName("player"))
	elseif orbother then
		self:Sync(syncName.orb .. orbother)
	elseif msg == L["trigger_orbControlYou"] then
		self:Sync(syncName.orb .. UnitName("player"))
	elseif string.find(msg, L["trigger_conflagration"]) then
		self:Conflagration()
	end

	--[[if deathother then
		if self.db.profile.mc then
			self:RemoveBar(string.format(L["bar_mindControl"], deathother))
		end
		if self.db.profile.polymorph then
			self:RemoveBar(string.format(L["bar_polymorph"], deathother))
		end
		if self.db.profile.orb then
			self:RemoveBar(string.format(L["bar_orb"], deathother))
		end
	elseif msg == L["trigger_deathYou"] then
		if self.db.profile.mc then
			self:RemoveBar(string.format(L["bar_mindControl"], UnitName("player")))
		end
		if self.db.profile.polymorph then
			self:RemoveBar(string.format(L["bar_polymorph"], UnitName("player")))
		end
		if self.db.profile.orb then
			self:RemoveBar(string.format(L["bar_orb"], UnitName("player")))
		end
	end]]
end

function module:CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE(msg)
	if msg == L["trigger_volley"] then
		self:Sync(syncName.volley)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger_volley"] then
		self:Sync(syncName.volley)
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
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_volley"])
	module:CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE(L["trigger_volley"])
	module:Events(L["trigger_mindControlOtherGain"])
	module:Events(L["trigger_mindControlOtherGone"])
	module:Events(L["trigger_polymorphOtherGain"])
	module:Events(L["trigger_polymorphOtherGain"])
	module:Events(L["trigger_polymorphOtherGone"])
	module:Events(L["trigger_orbControlOther"])
	module:Events(L["trigger_mindControlYouGain"])
	module:Events(L["trigger_polymorphYouGain"])
	module:Events(L["trigger_polymorphYouGone"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
