
----------------------------------
--      Module Declaration      --
----------------------------------

-- override
local bossName = "Testboss"

-- do not override
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local module = BigWigs:NewModule(boss)
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
--module.bossSync = bossName -- untranslated string

-- override
module.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = boss -- string or table {boss, add1, add2}
module.toggleoptions = {"berserk", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false

---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
	charge = 10,
	teleport = 30,
}
local icon = {
	charge = "Spell_Frost_FrostShock",
	teleport = "Spell_Arcane_Blink",
}
local syncName = {
	teleport = "TwinsTeleport",
	berserk = "TestbossBerserk"
}

local berserkannounced = nil


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Testboss",

	start_trigger = "Let the games begin."
	
	berserk_cmd = "berserk",
	berserk_name = "Berserk",
	berserk_desc = "Warn for when Testboss goes berserk",

	berserktrigger = "%s goes into a berserker rage!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserk Soon - Get Ready!",
	
	add_name = "Dragon",
} end )

L:RegisterTranslations("deDE", function() return {
	start_trigger = "Lasst die Spiele beginnen."

	berserk_name = "Berserk",
	berserk_desc = "Warn for when Testboss goes berserk",

	berserktrigger = "%s bekommt Berserkerwut!",
	berserkannounce = "Berserk - Berserk!",
	berserksoonwarn = "Berserkerwut in Kürze - Bereit machen!",
	
	add_name = "Drache",
} end )


------------------------------
--      Initialization      --
------------------------------

module.wipemobs = { L["add_name"] }
module:RegisterYellEngage(L["start_trigger"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	
	self:ThrottleSync(10, syncName.berserk)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = false
	berserkannounced = false
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers	    --
------------------------------

function module:UNIT_HEALTH(msg)
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not berserkannounced then
			if self.db.profile.berserk then
				self:Message(L["berserksoonwarn"], "Important")
			end
			berserkannounced = true
		elseif health > 30 and berserkannounced then
			berserkannounced = false
		end
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["berserktrigger"] then
		self:Sync(syncName.berserk)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and sync == "BossEngaged" and rest == self.bossSync then
        self.started = true
	elseif sync == syncName.berserk then
		self:Berserk()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Berserk()
	if self.db.profile.berserk then
		self:Message(L["berserkannounce"], "Important", true, "Beware")
	end
end

------------------------------
--      Utility	Functions   --
------------------------------

----------------------------------
--      Module Test Function    --
----------------------------------

function module:Test()
    local function berserkSoon()
        self:UNIT_HEALTH(boss)
    end
    
    local function berserk()
        self:CHAT_MSG_MONSTER_EMOTE(L["berserktrigger"])
    end
    local function deactivate()
        self.core:DisableModule(self:ToString())
    end
    
    BigWigs:Print("BigWigsTestboss Test started")
    BigWigs:Print("  Berserk Soon Warning after 5s")
    BigWigs:Print("  Berserk after 10s")
    
    -- immitate CheckForEngage
    self:SendEngageSync()    
    
    -- berserk soon warning after 5s
    self:ScheduleEvent(self:ToString().."Test_berserkSoon", berserkSoon, 5, self)
    
    -- berserk after 10s
    self:ScheduleEvent(self:ToString().."Test_sandblast", berserk, 10, self)
    
    -- reset after 15s
    self:ScheduleEvent(self:ToString().."Test_deactivate", deactivate, 15, self)
    
end