local bossName = BigWigs.bossmods.naxx.faerlina
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
timer.firstEnrage = 58.5
timer.enrage = 61

------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["trigger_engage1"])
module:RegisterYellEngage(L["trigger_engage2"])
module:RegisterYellEngage(L["trigger_engage3"])
module:RegisterYellEngage(L["trigger_engage4"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",        "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE",            "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_FRIENDLYPLAYER_DAMAGE",  "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE",              "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE",     "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE",               "CheckRain")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	
	self:ThrottleSync(5, syncName.enrage)
	self:ThrottleSync(5, syncName.silence)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.timeEnrageStarted = 0
	module.isEnraged = false
end

-- called after boss is engaged
function module:OnEngage()
	self:Message(L["msg_engage"], "Orange")
	if self.db.profile.enrage then
		self:DelayedMessage(timer.firstEnrage - 15, L["msg_enrage15"], "Important")
		self:Bar(L["bar_enrage"], timer.firstEnrage, icon.enrage)
	end
	module.timeEnrageStarted = GetTime()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if msg == L["trigger_enrage"] then
		self:Sync(syncName.enrage)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if msg == L["trigger_silence"] then
		self:Sync(syncName.silence)
	end
end

function module:CheckRain(msg)
    if string.find(msg, L["trigger_rainDamage"]) then
        if self.db.profile.rain then
            -- I found no better way to trigger this, it will autohide after 2s which is the time between Rain of Fire ticks
            self:WarningSign(icon.rain, timer.rainTick)
        end
	elseif (string.find(msg, L["trigger_rainGain"])) then
        if self.db.profile.rain then
            -- this will not trigger, but I will leave it in case they fix this combatlog event/message
            self:Message(L["msg_rain"], "Attention", true, "Alarm")
            self:WarningSign(icon.rain, timer.rainDuration)
            --self:DelayedBar(timer.rainDuration, L["barNextRain"], timer.nextRain - timer.rainDuration, icon.rain) -- variance too high
        end
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, L["trigger_rainGone"]) then
        -- this will not trigger, but I will leave it in case they fix this combatlog event/message
        self:RemoveWarningSign(icon.rain)
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
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(L["trigger_enrage"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(L["trigger_silence"])
	module:CheckRain(L["trigger_rainDamage"])
	module:CheckRain(L["trigger_rainGain"])
	module:CHAT_MSG_SPELL_AURA_GONE_SELF(L["trigger_rainGone"])
	
	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
