
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Grobbulus", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Grobbulus",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for Enrage",

	youinjected_cmd = "youinjected",
	youinjected_name = "You're injected Alert",
	youinjected_desc = "Warn when you're injected",

	otherinjected_cmd = "otherinjected",
	otherinjected_name = "Others injected Alert",
	otherinjected_desc = "Warn when others are injected",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on an injected person. (Requires promoted or higher)",

	cloud_cmd = "cloud",
	cloud_name = "Poison Cloud",
	cloud_desc = "Warn for Poison Clouds",

	inject_trigger = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",

	you = "You",
	are = "are",

	startwarn = "Grobbulus engaged, 12min to enrage!",
	enragebar = "Enrage",
	enrage10min = "Enrage in 10min",
	enrage5min = "Enrage in 5min",
	enrage1min = "Enrage in 1min",
	enrage30sec = "Enrage in 30sec",
	enrage10sec = "Enrage in 10sec",
	bomb_message_you = "You are injected!",
	bomb_message_other = "%s is injected!",
	bomb_bar = "%s injected",

	cloud_trigger = "Grobbulus casts Poison Cloud.",
	cloud_warn = "Poison Cloud next in ~15 seconds!",
	cloud_bar = "Poison Cloud",

} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"youinjected", "otherinjected", "icon", "cloud", -1, "enrage", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false


-- locals
local timer = {
	enrage = 720,
	inject = 10,
	cloud = 15,
}
local icon = {
	enrage = "INV_Shield_01",
	inject = "Spell_Shadow_CallofBone",
	cloud = "Ability_Creature_Disease_02",
}
local syncName = {
	inject = "GrobbulusInject",
	cloud = "GrobbulusCloud",
}

local berserkannounced = nil


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "InjectEvent")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	
	self:ThrottleSync(3, syncName.inject)
	self:ThrottleSync(5, syncName.cloud)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
end

-- called after boss is engaged
function module:OnEngage()
	if self.db.profile.enrage then
		self:Message(L["startwarn"], "Attention")
		self:Bar(L["enragebar"], timer.enrage, icon.enrage)
		self:DelayedMessage(timer.enrage - 10 * 60, L["enrage10min"], "Attention")
		self:DelayedMessage(timer.enrage - 5 * 60, L["enrage5min"], "Urgent")
		self:DelayedMessage(timer.enrage - 1 * 50, L["enrage1min"], "Important")
		self:DelayedMessage(timer.enrage - 30, L["enrage30sec"], "Important")
		self:DelayedMessage(timer.enrage - 10, L["enrage10sec"], "Important")
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if string.find( msg, L["cloud_trigger"] ) then
		self:Sync(syncName.cloud)
	end
end

function module:InjectEvent( msg )
	local _, _, eplayer, etype = string.find(msg, L["inject_trigger"])
	if eplayer and etype then
		if eplayer == L["you"] and etype == L["are"] then
			eplayer = UnitName("player")
		end
		self:Sync(syncName.inject .. " " .. eplayer)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync( sync, rest, nick )
	if sync == syncName.inject and rest then
		self:Inject(rest)
	elseif sync == syncName.cloud then
		self:Cloud()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Inject(player)
	if player then
		if self.db.profile.youinjected and player == UnitName("player") then
			self:Message(L["bomb_message_you"], "Personal", true, "Beware")
			self:WarningSign(icon.inject, timer.inject)
			
			self:Message(string.format(L["bomb_message_other"], player), "Attention", nil, nil, true)
			self:Bar(string.format(L["bomb_bar"], player), timer.inject, icon.inject)
		elseif self.db.profile.otherinjected then
			self:Message(string.format(L["bomb_message_other"], player), "Attention")
			--self:TriggerEvent("BigWigs_SendTell", player, L["bomb_message_you"]) -- can cause whisper bug on nefarian
			self:Bar(string.format(L["bomb_bar"], player), timer.inject, icon.inject)
		end
		if self.db.profile.icon then
			self:Icon(player)
		end
	end
end

function module:Cloud()
	if self.db.profile.cloud then
		self:Message(L["cloud_warn"], "Urgent")
		self:Bar(L["cloud_bar"], timer.cloud, icon.cloud)			
	end
end
