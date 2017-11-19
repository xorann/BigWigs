--[[

created by Hosq
modified by Dorann

Gives timer bars to see when world buffs are going out.

--]]

assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local name = "World Buff Timers"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	-- commands
	worldbuffs_cmd = "worldbuffs",
	worldbuffs_name = "World Buff Timers",
	worldbuffs_desc = "Gives timer bars to see when world buffs are going out.",
	
	-- triggers
	trigger_onyHeadHorde = "People of the Horde, citizens of Orgrimmar, come, gather round and celebrate a hero of the Horde. On this day",
	trigger_nefHeadHorde = "NEFARIAN IS SLAIN! People of Orgrimmar, bow down before the might of",

	trigger_onyHeadAlliance = "Citizens and allies of Stormwind, on this day, history has been made.",
	trigger_nefHeadAlliance = "Citizens of the Alliance, the Lord of Blackrock is slain! Nefarian has been subdued by the combined might of",

	trigger_zgHeart = "Now, only one step remains to rid us of the Soulflayer's threat...",
	trigger_zgHeart2 = "Begin the ritual, my servants. We must banish the heart of Hakkar back into the void!",
	trigger_rendHead = "Honor your heroes! On this day, they have dealt a great blow against one of our most hated enemies! The false Warchief, Rend Blackhand, has fallen!",

	-- bars
	bar_dragonslayer = "Rallying Cry of the Dragonslayer",
	bar_zandalar = "Spirit of Zandalar",
	bar_blessing = "Warchief's Blessing",

	-- misc
	misc_EnableName = "Enable",
	misc_EnableDesc = "Enable timers",
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	worldbuffs_cmd = "worldbuffs",
	worldbuffs_name = "World Buff Timer",
	worldbuffs_desc = "Zeigt Timer für Worldbuffs.",
	
	-- triggers
	trigger_onyHeadHorde = "People of the Horde, citizens of Orgrimmar, come, gather round and celebrate a hero of the Horde. On this day",
	trigger_nefHeadHorde = "NEFARIAN IS SLAIN! People of Orgrimmar, bow down before the might of",

	trigger_onyHeadAlliance = "Citizens and allies of Stormwind, on this day, history has been made.",
	trigger_nefHeadAlliance = "Citizens of the Alliance, the Lord of Blackrock is slain! Nefarian has been subdued by the combined might of",

	trigger_zgHeart = "Now, only one step remains to rid us of the Soulflayer's threat...",
	trigger_rendHead = "Honor your heroes! On this day, they have dealt a great blow against one of our most hated enemies! The false Warchief, Rend Blackhand, has fallen!",

	-- bars
	bar_dragonslayer = "Schlachtruf der Drachentöter",
	bar_zandalar = "Geist von Zandalar",
	bar_blessing = "Segen des Kriegshäuptlings",

	-- misc
	misc_EnableName = "Aktivieren",
	misc_EnableDesc = "Aktiviert Timer",
} end )


------------------------------
--      Module              --
------------------------------
BigWigsWorldBuffs = BigWigs:NewModule(name)
BigWigsWorldBuffs.defaultDB = {
	enabled = true,
}

BigWigsWorldBuffs.consoleCmd = L["worldbuffs_cmd"]
BigWigsWorldBuffs.consoleOptions = {
	type = "group",
	name = L["worldbuffs_name"],
	desc = L["worldbuffs_desc"],
	args   = {
		enable = {
			type = "toggle",
			name = L["misc_EnableName"],
			desc = L["misc_EnableDesc"],
			get = function() return BigWigsWorldBuffs.db.profile.enabled end,
			set = function(v) BigWigsWorldBuffs.db.profile.enabled = v end,
		},
	}
}
BigWigsWorldBuffs.revision = 20014
BigWigsWorldBuffs.external = true

------------------------------
--      Initialization      --
------------------------------
local timer = {
	onyHeadHorde = 15,
	nefHeadHorde = 17,
	onyHeadAlliance = 17,
	nefHeadAlliance = 17,
	zgHeart = 59,
	rendHead = 12,
}
local icon = {
	dragonslayer = "inv_misc_head_dragon_01",
	blessing = "spell_arcane_teleportorgrimmar",
	zandalar = "ability_creature_poison_05",
}
local syncName = {
	onyHeadHorde = "WorldBuffsOnyHeadHorde",
	nefHeadHorde = "WorldBuffsNefHeadHorde",
	onyHeadAlliance = "WorldBuffsOnyHeadAlliance",
	nefHeadAlliance = "WorldBuffsNefHeadAlliance",
	zgHeart = "WorldBuffsZgHeart",
	zgHeart2 = "WorldBuffsZgHeart2",
	rendHead = "WorldBuffsRendHead",
}


function BigWigsWorldBuffs:OnEnable()
	self:RegisterEvent("BigWigs_RecvSync")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	
	self:CombatlogFilter(L["trigger_zgHeart"], self.ZgEvent)
	self:CombatlogFilter(L["trigger_zgHeart2"], self.ZgEvent2)
	self:CombatlogFilter(L["trigger_onyHeadHorde"], self.OnyEvent)
	self:CombatlogFilter(L["trigger_nefHeadHorde"], self.NefEvent)
	self:CombatlogFilter(L["trigger_rendHead"], self.RendEvent)
end


------------------------------
--      Events              --
------------------------------
function BigWigsWorldBuffs:CHAT_MSG_MONSTER_SAY(msg)
	if string.find(msg, L["trigger_zgHeart"]) then
		self:Sync(syncName.zgHeart)
	end
end

function BigWigsWorldBuffs:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["trigger_onyHeadHorde"]) then
		self:Sync(syncName.onyHeadHorde)
	elseif string.find(msg, L["trigger_nefHeadHorde"]) then
		self:Sync(syncName.nefHeadHorde)
	elseif string.find(msg, L["trigger_onyHeadAlliance"]) then
		self:Sync(syncName.onyHeadAlliance)
	elseif string.find(msg, L["trigger_nefHeadAlliance"]) then
		self:Sync(syncName.nefHeadAlliance)
	elseif string.find(msg, L["trigger_rendHead"]) then
		self:Sync(syncName.rendHead)
	elseif string.find(msg, L["trigger_zgHeart2"]) then
		self:Sync(syncName.zgHeart2)
	end
end

function BigWigsWorldBuffs:ZgEvent(event, msg)
	BigWigs:Print("ZgEvent")
	BigWigs:Print(event)
	BigWigs:Print(msg)
end

function BigWigsWorldBuffs:ZgEvent2(event, msg)
	BigWigs:Print("ZgEvent2")
	BigWigs:Print(event)
	BigWigs:Print(msg)
end

function BigWigsWorldBuffs:OnyEvent(event, msg)
	BigWigs:Print("OnyEvent")
	BigWigs:Print(event)
	BigWigs:Print(msg)
end
function BigWigsWorldBuffs:NefEvent(event, msg)
	BigWigs:Print("NefEvent")
	BigWigs:Print(event)
	BigWigs:Print(msg)
end
function BigWigsWorldBuffs:RendEvent(event, msg)
	BigWigs:Print("RendEvent")
	BigWigs:Print(event)
	BigWigs:Print(msg)
end

------------------------------
--      Synchronization	    --
------------------------------
function BigWigsWorldBuffs:BigWigs_RecvSync( sync, rest, nick )
	if sync == syncName.onyHeadHorde then
		self:Dragonslayer(timer.onyHeadHorde)
	elseif sync == syncName.nefHeadHorde then
		self:Dragonslayer(timer.nefHeadHorde)
	elseif sync == syncName.onyHeadAlliance then
		self:Dragonslayer(timer.onyHeadAlliance)
	elseif sync == syncName.nefHeadAlliance then
		self:Dragonslayer(timer.nefHeadAlliance)
	elseif sync == syncName.zgHeart then
		self:Hakkar(timer.zgHeart)
	elseif sync == syncName.rendHead then
		self:Warchief(timer.rendHead)
	end
end

function BigWigsWorldBuffs:Dragonslayer(time)
	if self.db.profile.enabled and time then
		self:Bar(L["bar_dragonslayer"], time, icon.dragonslayer)
	end
end

function BigWigsWorldBuffs:Warchief(time)
	if self.db.profile.enabled and time then
		self:Bar(L["bar_blessing"], time, icon.blessing)
	end
end

function BigWigsWorldBuffs:Hakkar(time)
	if self.db.profile.enabled and time then
		self:Bar(L["bar_zandalar"], time, icon.zandalar)
	end
end