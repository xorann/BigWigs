
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Princess Huhuran", "Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Huhuran",

	wyvern_cmd = "wyvern",
	wyvern_name = "Wyvern Sting Alert",
	wyvern_desc = "Warn for Wyvern Sting",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for Frenzy",

	berserk_cmd = "berserk",
	berserk_name = "Berserk Alert",
	berserk_desc = "Warn for Berserk",

	frenzytrigger = "%s gains Frenzy.",
	berserktrigger = "%s gains Berserk!",
	frenzywarn = "Frenzy - Tranq Shot!",
	berserkwarn = "Berserk! Berserk! Berserk!",
	berserksoonwarn = "Berserk Soon!",
	stingtrigger = "afflicted by Wyvern Sting",
	stingwarn = "Wyvern Sting!",
	stingdelaywarn = "Possible Wyvern Sting in ~3 seconds!",
	bartext = "Wyvern Sting",

	startwarn = "Huhuran engaged, 5 minutes to berserk!",
	berserkbar = "Berserk",
	berserkwarn1 = "Berserk in 1 minute!",
	berserkwarn2 = "Berserk in 30 seconds!",
	berserkwarn3 = "Berserk in 5 seconds!",

} end )

L:RegisterTranslations("deDE", function() return {
	wyvern_name = "Stich des Fl\195\188geldrachen",
	wyvern_desc = "Warnung, wenn Huhuran Stich des Fl\195\188geldrachen wirkt.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Huhuran in Raserei ger\195\164t.",

	berserk_name = "Berserkerwut",
	berserk_desc = "Warnung, wenn Huhuran in Berserkerwut verf\195\164llt.",

	frenzytrigger = "%s ger\195\164t in Raserei!", -- translation missing
	berserktrigger = "%s verf\195\164llt in Berserkerwut!", -- translation missing
	frenzywarn = "Raserei - Einlullender Schuss!",
	berserkwarn = "Berserkerwut!",
	berserksoonwarn = "Berserkerwut in K\195\188rze!",
	stingtrigger = "von Stich des Flügeldrachen betroffen",
	stingwarn = "Stich des Fl\195\188geldrachen!",
	stingdelaywarn = "M\195\182glicher Stich des Fl\195\188geldrachen in ~3 Sekunden!",
	bartext = "Stich",

	startwarn = "Huhuran angegriffen! Berserkerwut in 5 Minuten!",
	berserkbar = "Berserkerwut",
	berserkwarn1 = "Berserkerwut in 1 Minute!",
	berserkwarn2 = "Berserkerwut in 30 Sekunden!",
	berserkwarn3 = "Berserkerwut in 5 Sekunden!",

} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"wyvern", "frenzy", "berserk", "bosskill"}


-- locals
local timer = {
	berserk = 300,
	sting = 20,
}
local icon = {
	berserk = "INV_Shield_01",
	sting = "INV_Spear_02",
}
local syncName = {
    sting = "HuhuranWyvernSting",
}

local berserkannounced = false

--[[
38:47 pull
39:09 wyvern
39:28 wyvern
39:48 wyvern
40:08 wyvern
]]

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSting")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSting")
    
    self:ThrottleSync(5, syncName.sting)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	berserkannounced = false
	self.started = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.berserk then
		self:Message(L["startwarn"], "Important")
		self:Bar(L["berserkbar"], timer.berserk, icon.berserk)
		self:DelayedMessage(timer.berserk - 60, L["berserkwarn1"], "Attention", nil, nil, true)
		self:DelayedMessage(timer.berserk - 30, L["berserkwarn2"], "Urgent", nil, nil, true)
		self:DelayedMessage(timer.berserk - 5, L["berserkwarn3"], "Important", nil, nil, true)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_MONSTER_EMOTE(arg1)
	if self.db.profile.frenzy and arg1 == L["frenzytrigger"] then
		self:Message(L["frenzywarn"], "Urgent")
	elseif self.db.profile.berserk and arg1 == L["berserktrigger"] then
		self:CancelDelayedMessage(L["berserkwarn1"])
		self:CancelDelayedMessage(L["berserkwarn2"])
		self:CancelDelayedMessage(L["berserkwarn3"])
		self:RemoveBar(L["berserkbar"])

		self:Message(L["berserkwarn"], "Urgent", false, "Beware")
		berserkannounced = true
	end
end

function module:UNIT_HEALTH(arg1)
	if self.db.profile.berserk then 
		if UnitName(arg1) == module.translatedName then
			local health = UnitHealth(arg1)
			if health > 30 and health <= 33 and not berserkannounced then
				self:Message(L["berserksoonwarn"], "Important", false, "Alarm")
				berserkannounced = true
			elseif (health > 40 and berserkannounced) then
				berserkannounced = false
			end
		end
	end
end

function module:checkSting(arg1)
	if self.db.profile.wyvern then 
		if string.find(arg1, L["stingtrigger"]) then
			self:Sync(syncName.sting)
		end
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.sting then
        self:Message(L["stingwarn"], "Urgent")
        self:Bar(L["bartext"], timer.sting, icon.sting)
        self:DelayedMessage(timer.sting - 3, L["stingdelaywarn"], "Urgent", nil, nil, true)
    end
end

