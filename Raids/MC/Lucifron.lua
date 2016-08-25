
----------------------------------
--      Module Declaration      --
----------------------------------

-- override
local bossName = "Lucifron"

-- do not override
local boss = AceLibrary("Babble-Boss-2.2")[bossName]
local module = BigWigs:NewModule(boss)
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
--BigWigsTestboss = module
module.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
--module.bossSync = bossName -- untranslated string

-- override
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = boss -- string or table {boss, add1, add2}

module.toggleoptions = {"adds", "curse", "doom", "shock", "mc", "bosskill"}


---------------------------------
--      Module specific Locals --
---------------------------------

local timer = {
}
local icon = {
}
local syncName = {
}


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	trigger1 = "afflicted by Lucifron",
	trigger2 = "afflicted by Impending Doom",
	trigger3 = "s Shadow Shock hits",
	trigger4 = "s Shadow Shock was resisted",
	trigger5 = " Lucifron(.*) Curse was resisted",
	trigger6 = "s Impending Doom was resisted",
	warn1 = "5 seconds until Lucifron's Curse!",
	warn2 = "Lucifron's Curse - 20 seconds until next!",
	warn3 = "5 seconds until Impending Doom!",
	warn4 = "Impending Doom - 20 seconds until next!",
	mindcontrolyou_trigger = "You are afflicted by Dominate Mind.",
	mindcontrolother_trigger = "(.*) is afflicted by Dominate Mind.",
	mindcontrolyouend_trigger = "Dominate Mind fades from you.",
	mindcontrolotherend_trigger = "Dominate Mind fades from (.*).",
	deathyou_trigger = "You die.",
	deathother_trigger = "(.*) dies.",
	deadaddtrigger = "Flamewaker Protector dies",
	add_name = "Flamewaker Protector",
	
	mindcontrol_message = "%s is mindcontrolled!",
	mindcontrol_message_you = "You are mindcontrolled!",
	mindcontrol_bar = "MC: %s",
	addmsg = "%d/2 Flamewaker Protectors dead!",

	bar1text = "Lucifron's Curse",
	bar2text = "Impending Doom",
	bar3text = "Shadow Shock",

	cmd = "Lucifron",
	
	adds_cmd = "adds",
	adds_name = "Dead adds counter",
	adds_desc = "Announces dead Flamewaker Protectors",
	
	mc_cmd = "mc",
	mc_name = "Dominate Mind",
	mc_desc = "Alert when someone is mind controlled.",
	
	curse_cmd = "curse",
	curse_name = "Lucifron's Curse alert",
	curse_desc = "Warn for Lucifron's Curse",
	
	doom_cmd = "doom",
	doom_name = "Impending Doom alert",
	doom_desc = "Warn for Impending Doom",
	
	shock_cmd = "shock",
	shock_name = "Shadow Shock alert",
	shock_desc  = "Warn for Shadow Shock",
} end)

L:RegisterTranslations("deDE", function() return {
	trigger1 = "von Lucifrons Fluch betroffen",
	trigger2 = "von Drohende Verdammnis betroffen",
	trigger3 = "Schattenschock trifft",
	trigger4 = "Schattenschock(.+) widerstanden",
	trigger5 = "Lucifrons Fluch wurde von(.+) widerstanden",
	trigger6 = "Drohende Verdammnis wurde von(.+) widerstanden",
	
	warn1 = "5 Sekunden bis Lucifrons Fluch!",
	warn2 = "Lucifrons Fluch - 20 Sekunden bis zu n\195\164chsten!",
	warn3 = "5 Sekunden bis Drohende Verdammnis!",
	warn4 = "Drohende Verdammnis - 20 Sekunden bis zu n\195\164chsten!",
	mindcontrolyou_trigger = "Ihr seid von Gedanken beherrschen betroffen.",
	mindcontrolother_trigger = "(.*) ist von Gedanken beherrschen betroffen.",
	mindcontrolyouend_trigger = "Gedanken beherrschen\' schwindet von Euch.",
	mindcontrolotherend_trigger = "Gedanken beherrschen schwindet von (.*).",
	deathyou_trigger = "Du stirbst.",
	deathother_trigger = "(.*) stirbt.",
	deadaddtrigger = "Feuerschuppenbesch\195\188tzer stirbt", --"Besch\195\188tzer der Flammensch\195\188rer stirbt.",
	add_name = "Feuerschuppenbesch\195\188tzer",
	
	mindcontrol_message = "%s ist ferngesteuert!",
	mindcontrol_message_you = "Du bist ferngesteuert!",
	mindcontrol_bar = "GK: %s",
	addmsg = "%d/2 Feuerschuppenbesch\195\188tzer tot!",

	bar1text = "Lucifrons Fluch",
	bar2text = "Drohende Verdammnis",
	bar3text = "Schattenschock",

	--cmd = "Lucifron",

	--adds_cmd = "adds",
	adds_name = "Z\195\164hler f\195\188r tote Adds",
	adds_desc = "Verk\195\188ndet Flamewaker Protectors Tod",
	
	--mc_cmd = "mc",
	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnen, wenn jemand \195\188bernommen ist",
	
	--curse_cmd = "curse",
	curse_name = "Alarm f\195\188r Lucifrons Fluch",
	curse_desc = "Warnen vor Lucifrons Fluch",
	
	--doom_cmd = "doom",
	doom_name = "Alarm f\195\188r Drohende Verdammnis",
	doom_desc = "Warnen vor Drohender Verdammnis",
	
	--shock_cmd = "shock",
	shock_name = "Alarm f\195\188r Schattenschock ",
	shock_desc  = "Warnen vor Schattenschock",
} end)


------------------------------
--      Initialization      --
------------------------------

module.wipemobs = { L["add_name"] }

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronMC_(.*)", 0.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronMCEnd_(.*)", 0.5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronCurseRep1", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronShock1", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LucifronDoomRep1", 5)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	self.protector = 0
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.curse then
		self:DelayedMessage(15, L["warn1"], "Attention")
		self:Bar(L["bar1text"], 20, "Spell_Shadow_BlackPlague")
	end
	if self.db.profile.doom then
		self:DelayedMessage(5, L["warn3"], "Attention")
		self:Bar(L["bar1text"], 10, "Spell_Shadow_NightOfTheDead")
	end
	self:Sync("LucifronShock")
end

-- called after boss is disengaged (wipe/retreat or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	local _,_,mindcontrolother,_ = string.find(msg, L["mindcontrolother_trigger"])
	local _,_,mindcontrolotherend,_ = string.find(msg, L["mindcontrolotherend_trigger"])
	local _,_,mindcontrolotherdeath,_ = string.find(msg, L["deathother_trigger"])
	if ((string.find(msg, L["trigger1"])) or (string.find(msg, L["trigger5"]))) then
		self:Sync("LucifronCurseRep1")
	elseif ((string.find(msg, L["trigger2"])) or (string.find(msg, L["trigger6"]))) then
		self:Sync("LucifronDoomRep1")
	elseif ((string.find(msg, L["trigger3"])) or (string.find(msg, L["trigger4"]))) then
		self:Sync("LucifronShock1")
	elseif string.find(msg, L["mindcontrolyou_trigger"]) then
		self:Sync("LucifronMC_"..UnitName("player"))
	elseif string.find(msg, L["mindcontrolyouend_trigger"]) then
		self:Sync("LucifronMCEnd_"..UnitName("player"))
	elseif string.find(msg, L["deathyou_trigger"]) then
		self:Sync("LucifronMCEnd_"..UnitName("player"))
	elseif mindcontrolother then
		self:Sync("LucifronMC_"..mindcontrolother)
	elseif mindcontrolotherend then
		self:Sync("LucifronMCEnd_"..mindcontrolotherend)
	elseif mindcontrolotherdeath then
		self:Sync("LucifronMCEnd_"..mindcontrolotherdeath)
	end
end

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if string.find(msg, L["deadaddtrigger"]) then
		self:Sync("LucifronAddDead " .. tostring(self.protector + 1))
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == "LucifronCurseRep1" and self.db.profile.curse then
		self:DelayedMessage(15, L["warn1"], "Attention")
		self:Bar(L["bar1text"], 20, "Spell_Shadow_BlackPlague")
	elseif sync == "LucifronDoomRep1" and self.db.profile.doom then
		self:DelayedMessage(10, L["warn3"], "Attention")
		self:Bar(L["bar1text"], 15, "Spell_Shadow_NightOfTheDead")
	elseif sync == "LucifronShock1" and self.db.profile.shock then
		--self:Bar(L["bar3text"], 6, "Spell_Shadow_Shadowbolt")
	elseif string.find(sync, "LucifronMC_") then
		if self.db.profile.mc then
			chosenone = string.sub(sync,12)
			if chosenone == UnitName("player") then
				self:Message(L["mindcontrol_message_you"], "Attention")
				self:Bar(string.format(L["mindcontrol_bar"], UnitName("player")), 15, "Spell_Shadow_ShadowWordDominate")
			else
				self:Message(string.format(L["mindcontrol_message"], chosenone), "Urgent")
				self:Bar(string.format(L["mindcontrol_bar"], chosenone), 15, "Spell_Shadow_ShadowWordDominate")
			end
		end
	elseif string.find(sync, "LucifronMCEnd_") then
		if self.db.profile.mc then
			luckyone = string.sub(sync,15)
			self:RemoveBar(string.format(L["mindcontrol_bar"], luckyone))
		end
	elseif sync == "LucifronAddDead" and rest and rest ~= "" then
        rest = tonumber(rest)
        if rest <= 4 and self.protector < rest then
            self.protector = rest
            if self.db.profile.adds then
				self:Message(string.format(L["addmsg"], self.protector), "Positive")
            end
        end
	end
end
