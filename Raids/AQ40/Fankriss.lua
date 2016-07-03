------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Fankriss the Unyielding"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local worms
----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Fankriss",
	worm_cmd = "worm",
	worm_name = "Worm Alert",
	worm_desc = "Warn for Incoming Worms",

	wormtrigger = "Fankriss the Unyielding casts Summon Worm.",
	wormwarn = "Incoming Worm! (%d)",
	wormbar = "Sandworm Enrage (%d)",
            
    entangle_cmd = "entangle",
    entangle_name = "Entangle Alert",
    entangle_desc = "Warn for Entangle and incoming Bugs",
    entangleplayer = "You are afflicted by Entangle.",
	entangleplayerother = "(.*) is afflicted by Entangle.",
    entanglewarn,
} end )

L:RegisterTranslations("deDE", function() return {
	worm_name = "Wurm beschw\195\182ren",
	worm_desc = "Warnung, wenn Fankriss einen Wurm beschw\195\182rt.",

	wormtrigger = "Fankriss der Unnachgiebige wirkt Wurm beschw\195\182ren.",
	wormwarn = "Wurm wurde beschworen! (%d)",
	wormbar = "Wurm ist w\195\188tend (%d)",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFankriss = BigWigs:NewModule(boss)
BigWigsFankriss.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsFankriss.enabletrigger = boss
BigWigsFankriss.toggleoptions = {"worm", "entangle", "bosskill"}
BigWigsFankriss.revision = tonumber(string.sub("$Revision: 20000 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFankriss:OnEnable()
	worms = 0
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")

    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
    
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FankrissWormSpawn", .1)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFankriss:Event(msg)
    if string.find(msg, L["entangleplayer"]) or string.find(msg, L["entangleplayerother"]) then 
        
        self:Sync("FankrissEntangle")
    end
end

function BigWigsFankriss:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["wormtrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FankrissWormSpawn "..tostring(worms + 1) )
	end
end

function BigWigsFankriss:BigWigs_RecvSync(sync, rest, nick)
	if sync == "FankrissEntangle" then
        self:Message(L["entanglewarn"], "Alarm", true, "Alarm")    
    end
    
    if sync ~= "FankrissWormSpawn" then return end
	if not rest then return end
	rest = tonumber(rest)
	if rest == (worms + 1) then
		-- we accept this worm
		-- Yes, this could go completely wrong when you don't reset your module and the whole raid does after a wipe
		-- or you reset your module and the rest doesn't. Anyway. it'll work a lot better than anything else.
		worms = worms + 1
		if self.db.profile.worm then
			self:TriggerEvent("BigWigs_Message", string.format(L["wormwarn"], worms), "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["wormbar"], worms), 20, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
		end	
	end
end
