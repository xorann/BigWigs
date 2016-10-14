-- tank burn on enable

----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Vaelastrasz the Corrupt", "Blackwing Lair")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Vaelastrasz",

	adrenaline_trigger = "^(.+) (.+) afflicted by Burning Adrenaline\.",
	start_trigger = "afflicted by Essence of the Red",
	flamebreath_trigger = "Vaelastrasz the Corrupt begins to cast Flame Breath\.",
	yell1 = "^Too late, friends",
	yell2 = "^I beg you, mortals",
	yell3 = "^FLAME! DEATH! DESTRUCTION!",
	start_bar = "Start",
	tankburn_bar = "Tank Burn",
	adrenaline_bar = "Burning Adrenaline: %s",
	breath_bar = "Flame Breath",
	breath_message = "Casting Flame Breath!",
	tankburnsoon = "Burning Adrenaline on tank in 5 seconds!",
	adrenaline_message = "%s has Burning Adrenaline!",
	adrenaline_message_you = "You have Burning Adrenaline! Go away!",
	deathyou_trigger = "You die\.",
	deathother_trigger = "(.+) dies\.",

	are = "are",

	start_cmd = "start",
	start_name = "Start",
	start_desc = "Starts a bar for estimating the beginning of the fight.",

	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flame Breath",
	flamebreath_desc = "Warns when boss is casting Flame Breath.",

	adrenaline_cmd = "adrenaline",
	adrenaline_name = "Burning Adrenaline",
	adrenaline_desc = "Announces who received Burning Adrenaline and starts a clickable bar for easier selection.",

	whisper_cmd = "whisper",
	whisper_name = "Whisper",
	whisper_desc = "Whispers the players that got Burning Adrenaline, telling them to move away.",

	tankburn_cmd = "tankburn",
	tankburn_name = "Tank Burn",
	tankburn_desc = "Shows a bar for the Burning Adrenaline that will be applied on boss' target.",

	icon_cmd = "icon",
	icon_name = "Raid Icon",
	icon_desc = "Marks the player with Burning Adrenaline for easier localization.\n\n(Requires assistant or higher)",
} end)

L:RegisterTranslations("deDE", function() return {
	cmd = "Vaelastrasz",

	adrenaline_trigger = "^(.+) (.+) von Brennendes Adrenalin betroffen\.",
	start_trigger = "von Essenz der Roten betroffen",
	flamebreath_trigger = "Vaelastrasz the Corrupt beginnt Flammenatem zu wirken\.",
	yell1 = "^Too late, friends",
	yell2 = "^I beg you, mortals",
	yell3 = "^FLAME! DEATH! DESTRUCTION!",
	start_bar = "Start",
	tankburn_bar = "Tank brennen",
	adrenaline_bar = "Brennendes Adrenalin: %s",
	breath_bar = "Flammenatem",
	breath_message = "Wirkt Flammenatem!",
	tankburnsoon = "Brennendes Adrenalin am Tank in 5 Sekunden!",
	adrenaline_message = "%s hat Brennendes Adrenalin!",
	adrenaline_message_you = "Sie haben Brennendes Adrenalin! Geh weg!",
	deathyou_trigger = "Du stirbst\.",
	deathother_trigger = "(.+) stirbt\.",

	are = "seid",

	start_cmd = "start",
	start_name = "Start",
	start_desc = "Startet eine Balken f\195\188r die Sch\195\164tzung der Beginn des Kampfes.",

	flamebreath_cmd = "flamebreath",
	flamebreath_name = "Flammenatem",
	flamebreath_desc = "Warnt, wenn Boss wirft Flammenatem.",

	adrenaline_cmd = "adrenaline",
	adrenaline_name = "Brennendes Adrenalin",
	adrenaline_desc = "Gibt bekannt, die Brennendes Adrenalin empfangen und startet einen anklickbaren Balken f\195\188r eine einfachere Auswahl.",

	whisper_cmd = "whisper",
	whisper_name = "Fl\195\188stern",
	whisper_desc = "Fl\195\188stern die Spieler mit Brennendes Adrenalin, ihnen zu sagen, sich zu entfernen.",

	tankburn_cmd = "tankburn",
	tankburn_name = "Tank brennen",
	tankburn_desc = "Zeigt eine Balken f\195\188r die Brennendes Adrenalin, die auf Bosses Ziel angewendet wird.",

	icon_cmd = "icon",
	icon_name = "Schlachtzugsymbol",
	icon_desc = "Markiert den Spieler mit Brennendes Adrenalin zur leichteren Lokalisierung.\n\n(Ben\195\182tigt Schlachtzugleiter oder Assistent)",
} end)


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20006 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"start", "flamebreath", "adrenaline", "whisper", "tankburn", "icon", "bosskill"}


-- locals
local timer = {
	adrenaline = 20,
	flamebreath = 2,
	tankburn = 44.9,
	start1 = 38,
	start2 = 28,
	start3 = 12,
}
local icon = {
	adrenaline = "INV_Gauntlets_03",
	flamebreath = "Spell_Fire_Fire",
	tankburn = "INV_Gauntlets_03",
	start = "Spell_Holy_PrayerOfHealing",
}
local syncName = {
	adrenaline = "VaelAdrenaline",
	flamebreath = "VaelBreath",
	tankburn = "VaelTankBurn",
}


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	
	
	self:ThrottleSync(2, syncName.adrenaline)
	self:ThrottleSync(3, syncName.flamebreath)
	self:ThrottleSync(5, syncName.tankburn)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
	self.barstarted = false
	self.started = false
end

-- called after boss is engaged
function module:OnEngage()
	self:Tankburn()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:CheckForEngage()
    local function IsHostile()
        if UnitExists("target") and UnitName("target") == self:ToString() and UnitIsEnemy("player", "target") then
            return true
        end

        local num = GetNumRaidMembers()
        for i = 1, num do
            local raidUnit = string.format("raid%starget", i)
            if UnitExists(raidUnit) and UnitName(raidUnit) == self:ToString() and UnitIsEnemy("raid" .. i, raidUnit) then
                return true
            end
        end
        
        return false
    end
    
    if IsHostile() then
        BigWigs:CheckForEngage(self)
    end
    --[[
    local running = module:IsEventScheduled(module:ToString().."_CheckStart")
		if IsHostile() then
			module:DebugMessage("Vael is hostile.")
			module:CancelScheduledEvent(module:ToString().."_CheckStart")

			BigWigs:CheckForEngage(self)
		elseif not running then
			module:ScheduleRepeatingEvent(module:ToString().."_CheckStart", module.CheckForEngage, .5, module)
		end
	end
    if module and module:IsBossModule() then
        local function IsBossInCombat()
            local t = module.enabletrigger
            local a = module.wipemobs
            if not t then return false end
            if type(t) == "string" then t = {t} end
            if a then
                if type(a) == "string" then a = {a} end
                for k,v in pairs(a) do table.insert(t, v) end
            end

            if UnitExists("target") and UnitAffectingCombat("target") then
                local target = UnitName("target")
                for _, mob in pairs(t) do
                    if target == mob then
                        return true
                    end
                end
            end

            local num = GetNumRaidMembers()
            for i = 1, num do
                local raidUnit = string.format("raid%starget", i)
                if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
                    local target = UnitName(raidUnit)
                    for _, mob in pairs(t) do
                        if target == mob then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local inCombat = IsBossInCombat()
        local running = module:IsEventScheduled(module:ToString().."_CheckStart")
        if inCombat then
            module:DebugMessage("Scan returned true, engaging ["..module:ToString().."].")
            module:CancelScheduledEvent(module:ToString().."_CheckStart")

            module:SendEngageSync()
        elseif not running then
            module:ScheduleRepeatingEvent(module:ToString().."_CheckStart", module.CheckForEngage, .5, module)
        end
    end
	]]
end
function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["flamebreath_trigger"] then
		self:Sync(syncName.flamebreath)
	end
end

function module:CHAT_MSG_COMBAT_FRIENDLY_DEATH(msg)
	BigWigs:CheckForWipe(self)
	
	local _, _, deathother = string.find(msg, L["deathother_trigger"])
	if msg == L["deathyou_trigger"] then
		if self.db.profile.adrenaline then
			self:RemoveBar(string.format(L["adrenaline_bar"], UnitName("player")))
		end
	elseif deathother then
		if self.db.profile.adrenaline then
			self:RemoveBar(string.format(L["adrenaline_bar"], deathother))
		end
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["yell1"]) and self.db.profile.start then
		self:Bar(L["start_bar"], timer.start1, icon.start, true, "Cyan")
		self.barstarted = true
	elseif string.find(msg, L["yell2"]) and self.db.profile.start and not self.barstarted then
		self:Bar(L["start_bar"], timer.start2, icon.start, true, "Cyan")
		self.barstarted = true
	elseif string.find(msg, L["yell3"]) and self.db.profile.start and not self.barstarted then
		self:Bar(L["start_bar"], timer.start3, icon.start, true, "Cyan")
	end
end

function module:Event(msg)
	local _, _, name, detect = string.find(msg, L["adrenaline_trigger"])
	if name and detect then
		if detect == L["are"] then
			name = UnitName("player")
		end
		self:Sync(syncName.adrenaline .. " "..name)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.flamebreath then
		self:Flamebreath()
	elseif sync == syncName.adrenaline and rest and rest ~= "" then
		self:Adrenaline(rest)
	elseif sync == syncName.tankburn then
		self:Tankburn()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Tankburn()
	if self.db.profile.tankburn then
		self:Bar(L["tankburn_bar"], timer.tankburn, icon.tankburn, true, "Black")
		self:DelayedMessage(timer.tankburn - 5, L["tankburnsoon"], "Urgent", nil, nil, true)
	end
end

function module:Flamebreath()
	if self.db.profile.flamebreath then
		self:Bar(L["breath_bar"], timer.flamebreath, icon.flamebreath, true, "Red")
		self:Message(L["breath_message"], "Urgent")
	end
end

function module:Adrenaline(name)
	if name then
		-- send whisper
		if self.db.profile.whisper and name ~= UnitName("player") then
			self:TriggerEvent("BigWigs_SendTell", name, L["adrenaline_message_you"])
		end
		
		-- bar and message
		if self.db.profile.adrenaline then
			self:Bar(string.format(L["adrenaline_bar"], name), timer.adrenaline, icon.adrenaline, true, "White")
			self:SetCandyBarOnClick("BigWigsBar "..string.format(L["adrenaline_bar"], name), function(name, button, extra) TargetByName(extra, true) end, name)
			if name == UnitName("player") then
				self:Message(L["adrenaline_message_you"], "Attention", true, "Beware")
                self:WarningSign(icon.adrenaline, timer.adrenaline)
			else
				self:Message(string.format(L["adrenaline_message"], name), "Urgent")
			end
		end
		
		-- set icon
		if self.db.profile.icon then
			self:Icon(name)
		end
		
		-- tank burn
		for i = 1, GetNumRaidMembers() do
			if UnitExists("raid" .. i .. "target") and UnitName("raid" .. i .. "target") == self.translatedName and UnitExists("raid" .. i .. "targettarget") and UnitName("raid" .. i .. "targettarget") == name then
				self:Sync(syncName.tankburn)
				break
			end
		end
	end
end
