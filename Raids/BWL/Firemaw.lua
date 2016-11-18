
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Firemaw", "Blackwing Lair")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Firemaw begins to cast Wing Buffet.",
	shadowflame_trigger = "Firemaw begins to cast Shadow Flame.",
	flamebuffetafflicted_trigger = "afflicted by Flame Buffet",
	flamebuffetresisted_trigger = "Firemaw 's Flame Buffet was resisted",
	flamebuffetimmune_trigger = "Firemaw 's Flame Buffet fail(.+) immune\.",
	flamebuffetabsorb1_trigger = "You absorb Firemaw 's Flame Buffet",
	flamebuffetabsorb2_trigger = "Firemaw 's Flame Buffet is absorbed",

	wingbuffet_message = "Wing Buffet! Next one in 30 seconds!",
	wingbuffet_warning = "TAUNT now! Wing Buffet soon!",
	shadowflame_warning = "Shadow Flame incoming!",

	wingbuffetcast_bar = "Wing Buffet",
	wingbuffet_bar = "Next Wing Buffet",
	wingbuffet1_bar = "Initial Wing Buffet",
	shadowflame_bar = "Shadow Flame",
	shadowflame_Nextbar = "Possible Shadow Flame",
	flamebuffet_bar = "Flame Buffet",

	cmd = "Firemaw",

	flamebuffet_cmd = "flamebuffet",
	flamebuffet_name = "Flame Buffet alert",
	flamebuffet_desc = "Warn when Flamegor casts Flame Buffet.",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn when Flamegor casts Wing Buffet.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn when Flamegor casts Shadow Flame.",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Ebonroc beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Ebonroc beginnt Schattenflamme zu wirken.",
	flamebuffetafflicted_trigger = "von Flammenpuffer betroffen",
	flamebuffetresisted_trigger = "Flammenpuffer(.+) widerstanden",
	flamebuffetimmune_trigger = "Flammenpuffer(.+) immun",
	flamebuffetabsorb1_trigger = "Ihr absorbiert Firemaws Flammenpuffer",
	flamebuffetabsorb2_trigger = "Flammenpuffer von Firemaw wird absorbiert von",

	wingbuffet_message = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	wingbuffet_warning = "Jetzt TAUNT! Fl\195\188gelsto\195\159 bald!",
	shadowflame_warning = "Schattenflamme bald!",

	wingbuffetcast_bar = "Fl\195\188gelsto\195\159",
	wingbuffet_bar = "N\195\164chster Fl\195\188gelsto\195\159",
	wingbuffet1_bar = "Erster Fl\195\188gelsto\195\159",
	shadowflame_bar = "Schattenflamme",
	shadowflame_Nextbar = "Mögliche Schattenflamme",
	flamebuffet_bar = "Flammenpuffer",

	cmd = "Firemaw",

	flamebuffet_cmd = "flamebuffet",
	flamebuffet_name = "Alarm f\195\188r Flammenpuffer",
	flamebuffet_desc = "Warnung f\195\188r Flammenpuffer.",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Alarm f\195\188r Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Ebonroc Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Alarm f\195\188r Schattenflamme",
	shadowflame_desc = "Warnung, wenn Ebonroc Schattenflamme wirkt.",
} end)


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20006 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"wingbuffet", "shadowflame", "flamebuffet", "bosskill"}


-- locals
local timer = {
	firstWingbuffet = 25,
	wingbuffet = 30,
	wingbuffetCast = 1,
	shadowflame = 16,
	shadowflameCast = 2,
}
local icon = {
	wingbuffet = "INV_Misc_MonsterScales_14",
	shadowflame = "Spell_Fire_Incinerate",	
}
local syncName = {
	wingbuffet = "FiremawWingBuffetX",
	shadowflame = "FiremawShadowflameX",
}


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	
	self:ThrottleSync(10, syncName.wingbuffet)
	self:ThrottleSync(10, syncName.shadowflame)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.wingbuffet then
		self:DelayedMessage(timer.firstWingbuffet - 5, L["wingbuffet_warning"], "Attention", nil, nil, true)
		self:Bar(L["wingbuffet1_bar"], timer.firstWingbuffet, icon.wingbuffet)
	end
	if self.db.profile.shadowflame then
		self:Bar(L["shadowflame_Nextbar"], timer.shadowflame, icon.shadowflame)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end

------------------------------
--      Event Handlers      --
------------------------------

function module:Event(msg)
	if msg == L["wingbuffet_trigger"] then
		self:Sync(syncName.wingbuffet)
	elseif msg == L["shadowflame_trigger"] then 
		self:Sync(syncName.shadowflame)
	-- flamebuffet triggers too often on nefarian and therefor this warning doesn't make any sense
	--elseif (string.find(msg, L["flamebuffetafflicted_trigger"]) or string.find(msg, L["flamebuffetresisted_trigger"]) or string.find(msg, L["flamebuffetimmune_trigger"]) or string.find(msg, L["flamebuffetabsorb1_trigger"]) or string.find(msg, L["flamebuffetabsorb2_trigger"])) and self.db.profile.flamebuffet then
	--	self:Bar(L["flamebuffet_bar"], 5, "Spell_Fire_Fireball", true, "White")
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.wingbuffet and self.db.profile.wingbuffet then
        self:Message(L["wingbuffet_message"], "Important")
		self:RemoveBar(L["wingbuffet_bar"]) -- remove timer bar
		self:Bar(L["wingbuffetcast_bar"], timer.wingbuffetCast, icon.wingbuffet, true, "Black") -- show cast bar
		self:DelayedBar(timer.wingbuffetCast, L["wingbuffet_bar"], timer.wingbuffet, icon.wingbuffet) -- delayed timer bar
        self:DelayedMessage(timer.wingbuffet - 5, L["wingbuffet_warning"], "Attention", nil, nil, true)
	elseif sync == syncName.shadowflame and self.db.profile.shadowflame then
        self:Message(L["shadowflame_warning"], "Important", true, "Alarm")
		self:RemoveBar(L["shadowflame_Nextbar"]) -- remove timer bar
		self:Bar(L["shadowflame_bar"], timer.shadowflameCast, icon.shadowflame) -- show cast bar
        self:DelayedBar(timer.shadowflameCast, L["shadowflame_Nextbar"], timer.shadowflame, icon.shadowflame) -- delayed timer bar
	end
end
