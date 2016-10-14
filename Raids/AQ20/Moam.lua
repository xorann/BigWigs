
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Moam", "Ruins of Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Moam",

	adds_cmd = "adds",
	adds_name = "Mana Fiend Alert",
	adds_desc = "Warn for Mana fiends",

	paralyze_cmd = "paralyze",
	paralyze_name = "Paralyze Alert",
	paralyze_desc = "Warn for Paralyze",

	starttrigger = "%s senses your fear.",
	startwarn = "Moam Engaged! 90 Seconds until adds!",
	addsbar = "Adds",
	addsincoming = "Mana Fiends incoming in %s seconds!",
	addstrigger = "drains your mana and turns to stone.",
	addswarn = "Mana Fiends spawned! Moam Paralyzed for 90 seconds!",
	paralyzebar = "Paralyze",
	returnincoming = "Moam unparalyzed in %s seconds!",
	returntrigger = "Energize fades from Moam.",
    returntrigger2 = "bristles with energy",
	returnwarn = "Moam unparalyzed! 90 seconds until Mana Fiends!",	
} end )

L:RegisterTranslations("deDE", function() return {
	adds_name = "Elementare",
	adds_desc = "Warnung, wenn Elementare erscheinen.",

	paralyze_name = "Steinform",
	paralyze_desc = "Warnung, wenn Moam in Steinform.",

	starttrigger = "%s sp\195\188rt Eure Angst.",
	startwarn = "Moam angegriffen! Elementare in 90 Sekunden!",

	addsbar = "Elementare",
	addsincoming = "Elementare in %s Sekunden!",
	addstrigger = "entzieht Euch Euer Mana und versteinert Euch.",
	addswarn = "Elementare! Moam in Steinform f\195\188r 90 Sekunden.",

	paralyzebar = "Steinform",
	returnincoming = "Moam erwacht in %s Sekunden!",
	returntrigger = "Energiezufuhr schwindet von Moam.",
	returnwarn = "Moam erwacht! Elementare in 90 Sekunden!",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20005 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"adds", "paralyze", "bosskill"}

-- locals
local timer = {
	paralyze = 90,
	unparalyze = 90,
}
local icon = {
	paralyze = "Spell_Shadow_CurseOfTounges",
	unparalyze = "Spell_Shadow_CurseOfTounges"
}
local syncName = {
	paralyze = "MoamParalyze",
	unparalyze = "MoamUnparalyze",
}

local firstunparalyze = nil


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
    self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	
	self:ThrottleSync(10, syncName.paralyze)
	self:ThrottleSync(10, syncName.unparalyze)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	firstunparalyze = true
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.adds then 
		self:Message(L["startwarn"], "Important") 
	end
	self:Unparalyze()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_RAID_BOSS_EMOTE(msg)
    self:DebugMessage("moam raid boss emote: " .. msg)
    if string.find(msg, L["addstrigger"]) then -- alternative trigger: Moam gains Energize.
		self:Sync(syncName.paralyze)
	elseif string.find(msg, L["returntrigger2"]) then
        self:Sync(syncName.unparalyze)
	end
end
function module:CHAT_MSG_MONSTER_EMOTE(msg)
    self:DebugMessage("moam monster emote: " .. msg)
	if string.find(msg, L["addstrigger"]) then -- alternative trigger: Moam gains Energize.
		self:Sync(syncName.paralyze)
	elseif string.find(msg, L["returntrigger2"]) then
        self:Sync(syncName.unparalyze)
    end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find( msg, L["returntrigger"]) then
		self:Sync(syncName.unparalyze)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.paralyze then
		self:Paralyze()
	elseif sync == syncName.unparalyze then
		self:Unparalyze()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Paralyze()
	if self.db.profile.adds then
		self:Message(L["addswarn"], "Important")
	end
	if self.db.profile.paralyze then
		self:DelayedMessage(timer.paralyze - 60, format(L["returnincoming"], 60), "Attention", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 30, format(L["returnincoming"], 30), "Attention", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 15, format(L["returnincoming"], 15), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.paralyze - 5, format(L["returnincoming"], 5), "Important", nil, nil, true)
		self:Bar(L["paralyzebar"], timer.paralyze, icon.paralyze)
	end
end

function module:Unparalyze()
	if firstunparalyze then
		firstunparalyze = false
	elseif self.db.profile.paralyze then 
		self:Message(L["returnwarn"], "Important") 
	end
	
	if self.db.profile.adds then
		self:DelayedMessage(timer.unparalyze - 60, format(L["addsincoming"], 60), "Attention", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 30, format(L["addsincoming"], 30), "Attention", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 15, format(L["addsincoming"], 15), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.unparalyze - 5, format(L["addsincoming"], 5), "Important", nil, nil, true)
		self:Bar(L["addsbar"], timer.unparalyze, icon.unparalyze) 
	end
end
