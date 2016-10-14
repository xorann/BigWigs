
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Viscidus", "Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Viscidus",
	volley_cmd = "volley",
	volley_name = "Poison Volley Alert",
	volley_desc = "Warn for Poison Volley",

	toxinyou_cmd = "toxinyou",
	toxinyou_name = "Toxin Cloud on You Alert",
	toxinyou_desc = "Warn if you are standing in a toxin cloud",

	toxinother_cmd = "toxinother",
	toxinother_name = "Toxin Cloud on Others Alert",
	toxinother_desc = "Warn if others are standing in a toxin cloud",

	freeze_cmd = "freeze",
	freeze_name = "Freezing States Alert",
	freeze_desc = "Warn for the different frozen states",

	slow_trigger 	= "Viscidus begins to slow.",
	freeze_trigger 	= "Viscidus is freezing up.",
	frozen_trigger 	= "Viscidus is frozen solid.",
	crack_trigger 	= "Viscidus begins to crack.",
	shatter_trigger 	= "Viscidus looks ready to shatter.",
	volley_trigger	= "afflicted by Poison Bolt Volley",
	toxin_trigger 	= "^([^%s]+) ([^%s]+) afflicted by Toxin%.$",

	you 		= "You",
	are 		= "are",

	freeze1_warn 		= "First freeze phase!",
	freeze2_warn 		= "Second freeze phase!",
	frozen_warn 		= "Viscidus is frozen!",
	crack1_warn 		= "Cracking up - little more now!",
	crack2_warn 		= "Cracking up - almost there!",
	volley_warn		= "Poison Bolt Volley!",
	volley_soon_warn		= "Poison Bolt Volley in ~3 sec!",
	toxin_warn		= " is in a toxin cloud!",
	toxin_self_warn		= "You are in the toxin cloud!",

	volley_bar	= "Poison Bolt Volley",
} end )

L:RegisterTranslations("deDE", function() return {
	volley_name = "Giftblitzsalve Alarm", -- ?
	volley_desc = "Warnt vor Giftblitzsalve", -- ?

	toxinyou_name = "Toxin Wolke",
	toxinyou_desc = "Warnung, wenn Du in einer Toxin Wolke stehst.",

	toxinother_name = "Toxin Wolke auf Anderen",
	toxinother_desc = "Warnung, wenn andere Spieler in einer Toxin Wolke stehen.",

	freeze_name = "Freeze Phasen",
	freeze_desc = "Zeigt die verschiedenen Freeze Phasen an.",

	slow_trigger 	= "wird langsamer!",
	freeze_trigger 	= "friert ein!",
	frozen_trigger 	= "ist tiefgefroren!",
	crack_trigger 	= "geht die Puste aus!", --CHECK
	shatter_trigger 	= "ist kurz davor, zu zerspringen!",
	volley_trigger	= "ist von Giftblitzsalve betroffen.",
	toxin_trigger 	= "^([^%s]+) ([^%s]+) von Toxin betroffen.$",

	you 		= "Ihr",
	are 		= "seid",

	freeze1_warn 		= "Erste Freeze Phase!",
	freeze2_warn 		= "Zweite Freeze Phase!",
	frozen_warn 		= "Dritte Freeze Phase!",
	crack1_warn 		= "Zerspringen - etwas noch!",
	crack2_warn 		= "Zerspringen - fast da!",
	volley_warn		= "Giftblitzsalve!", -- ?
	volley_soon_warn		= "Giftblitzsalve in ~3 Sekunden!", -- ?
	toxin_warn		= " ist in einer Toxin Wolke!",
	toxin_self_warn		= "Du bist in einer Toxin Wolke!",

	volley_bar        = "Giftblitzsalve",
} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20006 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"freeze", "volley", "toxinyou", "toxinother", "bosskill"}


-- locals
local timer = {
	volley = 12,
}
local icon = {
	volley = "Spell_Nature_CorrosiveBreath",
	toxin = "Spell_Nature_AbolishMagic",
}
local syncName = {}

local prior

--[[
45:39 pull
45:41 cloud 2
45:49 volley
46:01 volley 12
46:12 cloud 31
46:13 volley 12
46:42 emerge
46:50 volley
47:01 volley 11
47:05 cloud 23/53
47:14 volley 13
47:45 emerge
47:48 volley 
47:59 cloud 14/54
48:01 volley 13
48:16 volley 15
48:50 emerge
48:51 volley 
48:53 cloud 3/54
49:03 volley 14
49:16 volley 13
49:23 cloud 30
49:50 emerge
49:54 volley 
50:05 volley
50:16 volley
50:17 cloud 54

cloud: every 30s and 24s delay on explosion
]]

------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckVis")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckVis")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	prior = nil
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CheckVis(arg1)
	if not prior and self.db.profile.volley and string.find(arg1, L["volley_trigger"]) then
		self:Message(L["volley_warn"], "Urgent")
		self:DelayedMessage(timer.volley - 3, L["volley_soon_warn"], "Urgent", nil, nil, true)
		self:Bar(L["volley_bar"], timer.volley, icon.volley)
		prior = true
	elseif string.find(arg1, L["toxin_trigger"]) then
		local _,_, pl, ty = string.find(arg1, L["toxin_trigger"])
		if (pl and ty) then
			if self.db.profile.toxinyou and pl == L["you"] and ty == L["are"] then
				self:Message(L["toxin_self_warn"], "Personal", true, "RunAway")
				self:Message(UnitName("player") .. L["toxin_warn"], "Important", nil, nil, true)
				self:WarningSign("Spell_Nature_AbolishMagic", 5)
			elseif self.db.profile.toxinother then
				self:Message(pl .. L["toxin_warn"], "Important")
				--self:TriggerEvent("BigWigs_SendTell", pl, L["toxin_self_warn"]) -- can cause whisper bug on nefarian
			end
		end
	end
end

function module:Emote(arg1)
	if not self.db.profile.freeze then return end
	if arg1 == L["slow_trigger"] then
		self:Message(L["freeze1_warn"], "Atention")
	elseif arg1 == L["freeze_trigger"] then
		self:Message(L["freeze2_warn"], "Urgent")
	elseif arg1 == L["frozen_trigger"] then
		self:Message(L["frozen_warn"], "Important")
	elseif arg1 == L["crack_trigger"] then
		self:Message(L["crack1_warn"], "Urgent")
	elseif arg1 == L["shatter_trigger"] then
		self:Message(L["crack2_warn"], "Important")
	end
end

function module:BigWigs_Message(text)
	if text == L["volley_soon_warn"] then prior = nil end
end
