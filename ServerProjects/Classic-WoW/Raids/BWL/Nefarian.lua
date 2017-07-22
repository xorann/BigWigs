local bossName = BigWigs.bossmods.bwl.nefarian
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end


--BigWigs:Print("classic-wow " .. bossName)

------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(bossName)
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

module:RegisterYellEngage(L["trigger_engage"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	
	self:ThrottleSync(10, syncName.shadowflame)
	self:ThrottleSync(15, syncName.fear)
	self:ThrottleSync(0, syncName.addDead)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.phase2 = nil
    module.nefCounter = 0
    
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
	self:Bar(L["bar_mobSpawn"], timer.mobspawn, icon.mobspawn)
		
	self:TriggerEvent("BigWigs_StartCounterBar", self, L["misc_drakonidsDead"], module.nefCounterMax, "Interface\\Icons\\inv_egg_01")
	self:TriggerEvent("BigWigs_SetCounterBar", self, L["misc_drakonidsDead"], (module.nefCounterMax - 0.1))
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    BigWigs:CheckForBossDeath(msg, self)
    
    local _, _, drakonid = string.find(msg, L["trigger_nefCounter"])
    if drakonid and L:HasReverseTranslation(drakonid) then
        --self:OnKill(L:GetReverseTranslation(drakonid))
        --nefCounter = nefCounter + 1
        self:DebugMessage("Drakonids dead: " .. tostring(module.nefCounter + 1) .. " Name: " .. drakonid)
		self:Sync(syncName.addDead .. " " .. tostring(module.nefCounter + 1))
    end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
    if string.find(msg, L["trigger_landingNow"]) then
        self:Sync(syncName.landing)
		return
    elseif string.find(msg, L["trigger_landing"]) then
		self:Sync(syncName.landingSoon)
		return
	elseif string.find(msg, L["trigger_zerg"]) then
		self:Sync(syncName.zerg)
		return
	end
	
    -- class calls
	for i,v in pairs(module.warnpairs) do
		if string.find(msg, i) then
			if v[2] then
				if self.db.profile.classcall then
                    local localizedClass, englishClass = UnitClass("player");
                    if string.find(msg, localizedClass) then
						self:Message(v[1], "Core", nil, "Beware")
						self:WarningSign(icon.classcall, 3)
					else 
						self:Message(v[1], "Core", nil, "Long")
                    end
					
					self:Bar(v[1], timer.classcall, icon.classcall)
					self:DelayedMessage(timer.classcall - 3, L["msg_classCall"], "Important")
					self:DelayedSound(timer.classcall - 3, "Three")
					self:DelayedSound(timer.classcall - 2, "Two")
					self:DelayedSound(timer.classcall - 1, "One")
				end
			end
			return
		end
	end
end

-- mind control
-- /run local m=BigWigs:GetModule(BigWigs.bossmods.bwl.nefarian);m:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE("Smorgal is afflicted by Shadow Command.")
function module:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(arg1)
	local _,_, player, type = string.find(arg1, L["trigger_mindControl"])
	if player and type then
		if player == L["misc_you"] and type == L["misc_are"] then
			player = UnitName("player")
		end
		
		self:Sync(syncName.mindControl .. " " .. player)
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["trigger_fear"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["trigger_shadowFlame"]) then
		self:Sync(syncName.shadowflame)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, L["trigger_fearGone"]) then
        --self:RemoveWarningSign(icon.fear)
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
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_fearGone"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_fear"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_shadowFlame"])
	module:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(L["trigger_mindControl"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_landingNow"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_landing"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_zerg"])
	
	module:CHAT_MSG_MONSTER_YELL(L["trigger_shamans"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_druid"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_warlock"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_priest"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_hunter"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_warrior"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_rogue"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_paladin"])
	module:CHAT_MSG_MONSTER_YELL(L["trigger_mage"])

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
