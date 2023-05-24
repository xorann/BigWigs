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

L:RegisterTranslations("ruRU", function() return {
	-- commands

	worldbuffs_name = "Таймеры Мировых баффов",
	worldbuffs_desc = "Дает таймеры, чтобы видеть, когда появляются мировые баффы.",

	-- triggers (dbcscript_string)
	trigger_onyHeadHorde = "Народы Орды, жители Оргриммара! Приходите, собирайтесь и поздравляйте героя Орды! В этот день", --vmangos\locales_broadcast_text\9491 (.additem 19003 .additem 18422 .go creature 4770 .modify faction 2 1 .go creature 6499)
	trigger_nefHeadHorde = "НЕФАРИАН УБИТ! Жители Оргриммара", --vmangos\locales_broadcast_text\9867

	trigger_onyHeadAlliance = "Граждане и союзники Штормграда, в этот день вершилась история.", --vmangos\locales_broadcast_text\9495 (.additem 18423 .additem 19003 .go creature Bolvar .go creature 79656)
	trigger_nefHeadAlliance = "Граждане Альянса! Владыка Черной горы повержен!", --vmangos\locales_broadcast_text\9870

	trigger_zgHeart = "Теперь остался лишь один шаг до избавления от Свежевателя Душ...", --vmangos\locales_broadcast_text\10473 (.additem 19802 .go creature Molthor .modify faction 1 0 2 .quest remove 8183)
	trigger_zgHeart2 = "Начинайте ритуал, слуги мои. Мы должны отправить сердце Хаккара обратно в Пустоту!", --vmangos\locales_broadcast_text\10474
	trigger_rendHead = "Чествуйте своих героев! Сегодня они нанесли сокрушающий удар нашим самым ненавистным врагам! Самозванец Ренд Чернорук мертв!", --vmangos\locales_broadcast_text\6013 (.additem 12630)

	-- bars (spell_template)\(Spell.dbc)
	bar_dragonslayer = "Ободряющий клич Драконоборца", --22888
	bar_zandalar = "Дух Зандалара", --24425
	bar_blessing = "Благословление вождя", --16609

	-- misc
	misc_EnableName = "Включить",
	misc_EnableDesc = "Включить таймеры",
} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	worldbuffs_cmd = "worldbuffs",
	worldbuffs_name = "World Buff Timer",
	worldbuffs_desc = "Zeigt Timer für Worldbuffs.",
	
	-- triggers
	trigger_onyHeadHorde = "Bewohner von Orgrimmar, kommt versammelt euch und feiert unsere Helden, die gemeinsam gegen den schwarzen Drachenschwarm einen Sieg erringen konnten!",
	trigger_nefHeadHorde = "NEFARIAN IS SLAIN! People of Orgrimmar, bow down before the might of",

	trigger_onyHeadAlliance = "Citizens and allies of Stormwind, on this day, history has been made.",
	trigger_nefHeadAlliance = "Citizens of the Alliance, the Lord of Blackrock is slain! Nefarian has been subdued by the combined might of",

	trigger_zgHeart = "Now, only one step remains to rid us of the Soulflayer's threat...",
	trigger_zgHeart2 = "Beginnt mit dem Ritual. Wir müssen das Herz von Hakkar zurück in die Leere verbannen!",
	trigger_rendHead = "Ehret Eure Helden! Heute haben sie einem unserer verhasstesten Feinde einen schweren Schlag beigebracht! Rend Blackhand, der falsche Kriegshäuptling, ist gefallen!",

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
	onyHeadHorde = 28,
	nefHeadHorde = 27.5,	
	onyHeadAlliance = 18.4, 
	nefHeadAlliance = 18.4, -- ??
	zgHeart = 59, -- ??
	zgHeart2 = 34,
	rendHead = 16, -- test
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

function BigWigsWorldBuffs:ZgEvent(msg, event)
	BigWigs:DebugMessage("ZgEvent")
	BigWigs:DebugMessage(event)
	BigWigs:DebugMessage(msg)
end

function BigWigsWorldBuffs:ZgEvent2(msg, event)
	BigWigs:DebugMessage("ZgEvent2")
	BigWigs:DebugMessage(event)
	BigWigs:DebugMessage(msg)
	self:Sync(syncName.zgHeart2)
end

function BigWigsWorldBuffs:OnyEvent(msg, event)
	BigWigs:DebugMessage("OnyEvent")
	BigWigs:DebugMessage(event)
	BigWigs:DebugMessage(msg)
end

function BigWigsWorldBuffs:NefEvent(msg, event)
	BigWigs:DebugMessage("NefEvent")
	BigWigs:DebugMessage(event)
	BigWigs:DebugMessage(msg)
end

function BigWigsWorldBuffs:RendEvent(msg, event)
	BigWigs:DebugMessage("RendEvent")
	BigWigs:DebugMessage(event)
	BigWigs:DebugMessage(msg)
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
	elseif sync == syncName.zgHeart2 then
		self:Hakkar(timer.zgHeart2)
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
