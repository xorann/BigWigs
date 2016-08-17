------------------------------
--      Are you local?      --
------------------------------

local eyeofcthun = AceLibrary("Babble-Boss-2.2")["Eye of C'Thun"]
local cthun = AceLibrary("Babble-Boss-2.2")["C'Thun"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. cthun)

local gianteye = "Giant Eye Tentacle"

local timeP1Tentacle = 90      -- tentacle timers for phase 1
local timeP1TentacleStart = 45 -- delay for first tentacles from engage onwards
local timeP1GlareStart = 45    -- delay for first dark glare from engage onwards
local timeP1Glare = 90         -- interval for dark glare
local timeP1GlareCasting = 5   -- time it takes from casting dark glare until the spell starts
local timeP1GlareDuration = 40 -- duration of dark glare
local timeP2Offset = 10        -- delay for all timers to restart after the Eye dies
local timeP2Tentacle = 30      -- tentacle timers for phase 2
local timeP2ETentacle = 40     -- Eye tentacle timers for phase 2
local timeP2GiantClaw = 40     -- Giant Claw timer for phase 2
local timeReschedule = 50      -- delay from the moment of weakening for timers to restart
local timeTarget = 1           -- delay for target change checking on Eye of C'Thun and Giant Eye Tentacle
local timeWeakened = 45        -- duration of a weaken
local timeP2FirstGiantClaw = 25 -- first giant claw after eye of c'thun dies
local timeP2FirstGiantEye = 56 -- first giant eye after eye of c'thun dies
local timeP2FirstEyeTentacles = 40 -- first eye tentacles after eye of c'thun dies
local timeP2FirstGiantClawAfterWeaken = 10
local timeP2FirstGiantEyeAfterWeaken = 40
local timeLastEyeTentaclesSpawn = 0
local timeLastGiantEyeSpawn = 0
local timeP1RandomEyeBeams = 15
local timeEyeBeam = 2         -- Eye Beam Cast time

local iconGiantEye = "inv_misc_eye_01" --"Interface\\Icons\\Ability_EyeOfTheOwl"
local iconGiantClaw = "Spell_Nature_Earthquake"
local iconEyeTentacles = "spell_shadow_siphonmana" --"Interface\\Icons\\Spell_Nature_CallStorm"
local iconDarkGlare = "Inv_misc_ahnqirajtrinket_04"
local iconWeaken = "INV_ValentinesCandy"
local iconEyeBeamSelf = "Ability_creature_poison_05"
local iconDigestiveAcid = "ability_creature_disease_02"

local health = 100

local cthunstarted = nil
local phase2started = nil
local firstGlare = nil
local firstWarning = nil
--local target = nil
local tentacletime = timeP1Tentacle
local isWeakened = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Cthun",

	startwarn	= "C'Thun engaged! - 45 sec until Dark Glare and Eyes",
	barStartRandomBeams = "Start of Random Beams!",
	
	eye_beam_trigger = "Giant Eye Tentacle begins to cast Eye Beam.",
    eye_beam_trigger_cthun = "Eye of C'Thun begins to cast Eye Beam.",
	eyebeam		= "Eye Beam on %s",
	Unknown = "Unknown", -- Eye Beam on Unknown
	
	tentacle_cmd = "tentacle",
	tentacle_name = "Tentacle Alert",
	tentacle_desc = "Warn for Tentacles",
	rape_cmd = "rape",
	rape_name = "Rape jokes are funny",
	rape_desc = "Some people like hentai jokes.",
	tentacle	= "Tentacle Rape Party - 5 sec",
	norape		= "Tentacles in 5sec!",
	barTentacle	= "Tentacle rape party!",
	barNoRape	= "Tentacle party!",
	
	glare_cmd = "glare",
	glare_name = "Dark Glare Alert",
	glare_desc = "Warn for Dark Glare",
	glare		= "Dark Glare!",
	msgGlareEnds	= "Dark Glare ends in 5 sec",
	barGlare	= "Next Dark Glare!",
    barGlareEnds = "Dark Glare ends",
    barGlareCasting = "Casting Dark Glare",
	glarewarning	= "DARK GLARE ON YOU!",
	groupwarning	= "Dark Glare on group %s (%s)",
	
	group_cmd = "group",
	group_name = "Dark Glare Group Warning",
	group_desc = "Warn for Dark Glare on Group X",

	phase2starting	= "The Eye is dead! Body incoming!",
	
	giant_cmd = "giant",
	giant_name = "Giant Eye Alert",
	giant_desc = "Warn for Giant Eyes",
	giant_claw_spawn_trigger = "Giant Claw Tentacle 's Ground Rupture",
	barGiant	= "Giant Eye!",
	barGiantC	= "Giant Claw!",
	GiantEye = "Giant Eye Tentacle in 5 sec!",
	gedownwarn	= "Giant Eye down!",
	
	weakened_cmd = "weakened",
	weakened_name = "Weakened Alert",
	weakened_desc = "Warn for Weakened State",
	weakenedtrigger = "is weakened!",
	vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) C'Thun for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
	vulnerability_dots_test = "^C'Thun suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)", 
	weakened	= "C'Thun is weakened for 45 sec",
	invulnerable2	= "Party ends in 5 seconds",
	invulnerable1	= "Party over - C'Thun invulnerable",
	barWeakened	= "C'Thun is weakened!",
	
    digestiveAcidTrigger = "You are afflicted by Digestive Acid [%s%(]*([%d]*).",        
    msgDigestiveAcid = "5 Acid Stacks",
            
	FleshTentacle = "Flesh Tentacle",

	--[[GNPPtrigger	= "Nature Protection",
	GSPPtrigger	= "Shadow Protection",
	Sundertrigger	= "Sunder Armor",
	CoEtrigger	= "Curse of the Elements",
	CoStrigger	= "Curse of Shadow",
	CoRtrigger	= "Curse of Recklessness",]]
            
            
    proximity_cmd = "proximity",
    proximity_name = "Proximity Warning",
    proximity_desc = "Show Proximity Warning Frame",
} end )

L:RegisterTranslations("deDE", function() return {
    --cmd = "Cthun",
            
	startwarn	= "C'Thun angegriffen! - 45 sec bis Dunkles Starren und Augen", --"C'Thun engaged! - 45 sec until Dark Glare and Eyes",
	barStartRandomBeams = "Beginn zufälliger Strahlen!",
	
	eye_beam_trigger = "Riesiges Augententakel beginnt Augenstrahl zu wirken", --"Giant Eye Tentacle begins to cast Eye Beam.", -- Riesiges Augententakel beginnt Augenstrahl zu wirken
    eye_beam_trigger_cthun = "Auge von C'Thun beginnt Augenstrahl zu wirken", --"Eye of C'Thun begins to cast Eye Beam.", -- 
	eyebeam		= "Augenstrahl auf %s", --"Eye Beam on %s",
	Unknown = "Unbekannt", -- Eye Beam on Unknown
	
	--tentacle_cmd = "tentacle",
	tentacle_name = "Tentakel Alarm",
	tentacle_desc = "Warnung vor Tentakeln", --"Warn for Tentacles",
	--rape_cmd = "rape",
	rape_name = "Rape jokes are funny",
	rape_desc = "Some people like hentai jokes.",
	tentacle	= "Tentakel Rape Party - 5 sec", --"Tentacle Rape Party - 5 sec",
	norape		=  "Tentakel in 5sec!", --"Tentacles in 5sec!",
	barTentacle	= "Tentakel Rape Party!", -- "Tentacle rape party!",
	barNoRape	= "Tentakel Party", --"Tentacle party!",
	
	--glare_cmd = "glare",
	glare_name = "Dunkles Starren Alarm", --"Dark Glare Alert", -- Dunkles Starren
	glare_desc = "Warnung for Dunklem Starren", --"Warn for Dark Glare",
	glare		= "Dunkles Starren!", -- "Dark Glare!",
	msgGlareEnds	= "Dunkles Starren endet in 5 sec", -- "Dark Glare ends in 5 sec",
	barGlare	= "Nächstes Dunkles Starren!", -- "Next Dark Glare!",
    barGlareEnds = "Dunkles Starren endet", -- Dark Glare ends",
    barGlareCasting = "Zaubert Dunkles Starren", -- "Casting Dark Glare",
	glarewarning	= "DUNKLES STARREN AUF DIR!", --"DARK GLARE ON YOU!",
	groupwarning	= "Dunkles Starren auf Gruppe %s (%s)", -- "Dark Glare on group %s (%s)",
	
	--group_cmd = "group",
	group_name = "Dunkles Starren Gruppenwarnung", -- "Dark Glare Group Warning",
	group_desc = "Warnt vor Dunkles Starren auf Gruppe X", -- "Warn for Dark Glare on Group X",

	phase2starting	= "Das Auge ist tot! Phase 2 beginnt.", -- "The Eye is dead! Body incoming!",
	
	--giant_cmd = "giant",
	giant_name = "Riesiges Augententakel Alarm", --Giant Eye Alert",
	giant_desc = "Warnung vor Riesigem Augententakel", -- "Warn for Giant Eyes",
	giant_claw_spawn_trigger = "Riesiges Klauententakel(.+) Erdriss", -- "Giant Claw Tentacle 's Ground Rupture",
	barGiant	= "Riesiges Augententakel!",
	barGiantC	= "Riesiges Klauententakel!",
	GiantEye = "Riesiges Augententakel Tentacle in 5 sec!",
	gedownwarn	= "Riesiges Augententakel tot!",
	
	--weakened_cmd = "weakened",
	weakened_name = "Schwäche Alarm", --"Weakened Alert",
	weakened_desc = "Warnung für Schwäche Phase", -- "Warn for Weakened State",
	weakenedtrigger = "ist geschwächt", -- "is weakened!",
	vulnerability_direct_test = "^[%w]+[%ss]* ([%w%s:]+) ([%w]+) C'Thun für ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
	vulnerability_dots_test = "^C'Thun suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)", 
	weakened	= "C'Thun ist für 45 sec geschwächt", --"C'Thun is weakened for 45 sec",
	invulnerable2	= "Party endet in 5 sec", --"Party ends in 5 seconds",
	invulnerable1	= "Party vorbei - C'Thun unverwundbar", -- "Party over - C'Thun invulnerable",
	barWeakened	= "C'Thun ist geschwächt", --"C'Thun is weakened!",
	
    digestiveAcidTrigger = "Ihr seid von Magensäure [%s%(]*([%d]*)", -- "You are afflicted by Digestive Acid (5).",  
    msgDigestiveAcid = "5 Säure Stacks",
            
	FleshTentacle = "Fleischtentakel",

	--[[GNPPtrigger	= "Nature Protection",
	GSPPtrigger	= "Shadow Protection",
	Sundertrigger	= "Sunder Armor",
	CoEtrigger	= "Curse of the Elements",
	CoStrigger	= "Curse of Shadow",
	CoRtrigger	= "Curse of Recklessness",]]
            
    proximity_cmd = "proximity",
    proximity_name = "Nähe Warnungsfenster",
    proximity_desc = "Zeit das Nähe Warnungsfenster",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCThun = BigWigs:NewModule(cthun)
BigWigsCThun.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsCThun.enabletrigger = { eyeofcthun, cthun }
BigWigsCThun.bossSync = "CThun"
BigWigsCThun.toggleoptions = { "rape", -1, "tentacle", "glare", "group", -1, "giant", "weakened", "proximity", "bosskill" }
BigWigsCThun.revision = tonumber(string.sub("$Revision: 20003 $", 12, -3))
BigWigsCThun.target = nil
BigWigsCThun.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
BigWigsCThun.proximitySilent = false

function BigWigsCThun:OnEnable()
    self.started = nil
	BigWigsCThun.target = nil
	cthunstarted = nil
	firstGlare = nil
	firstWarning = nil
	phase2started = nil

	tentacletime = timeP1Tentacle

	-- register events
    self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath") -- override since we get out of combat between phases.

    
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	--self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	--self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	--self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")		-- weakened triggering
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")		-- weakened triggering
	--self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	--self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	-- Not sure about this, since we get out of combat between the phases.
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
    
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")   
    
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckEyeBeam")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckGiantClawSpawn")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckGiantClawSpawn")

    self:RegisterEvent("UNIT_HEALTH", "CheckFleshTentacles")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckDigestiveAcid")
    
	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "CThunStart"..BigWigsCThun.revision, 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunP2Start", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakened1"..BigWigsCThun.revision, 50)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunGEdown"..BigWigsCThun.revision, 3)
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver"..BigWigsCThun.revision, 600)
    self:TriggerEvent("BigWigs_ThrottleSync", "GiantClawSpawn"..BigWigsCThun.revision, 30)
    self:TriggerEvent("BigWigs_ThrottleSync", "FleshTentacleHealthCheck"..BigWigsCThun.revision, 5)
end

----------------------
--  Event Handlers  --
----------------------

function BigWigsCThun:GenericBossDeath(event)
   --DEFAULT_CHAT_FRAME:AddMessage("Debug: GenericBossDeath: " .. event) 
end

function BigWigsCThun:Emote( msg )
	if string.find(msg, L["weakenedtrigger"]) then 
        self:TriggerEvent("BigWigs_SendSync", "CThunWeakened1"..BigWigsCThun.revision) 
    end
end

--[[function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE( arg1 )
	if not cthunstarted and arg1 and string.find(arg1, L["eye_beam_trigger_cthun"]) then 
        self:TriggerEvent("BigWigs_SendSync", "CThunStart"..BigWigsCThun.revision)
    end
end]]

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    self:DebugMessage("death: "..msg)
	if (msg == string.format(UNITDIESOTHER, eyeofcthun)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunP2Start")
	elseif (msg == string.format(UNITDIESOTHER, gianteye)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunGEdown"..BigWigsCThun.revision)
	elseif (msg == string.format(UNITDIESOTHER, cthun)) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], cthun), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsCThun:BigWigs_RecvSync(sync, rest, nick)
    --self:DebugMessage("BigWigs_RecvSync: " .. sync .. " " .. rest)
    if not self.started and ((sync == "BossEngaged" and rest == self.bossSync) or (sync == "CThunStart"..BigWigsCThun.revision)) then
        if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
        self:StartFight()
		self:CThunStart()
        
	elseif sync == "CThunP2Start" then
        self:TriggerEvent("BigWigs_SendSync", "CThunP2Start"..BigWigsCThun.revision)
		self:CThunP2Start()
	elseif sync == "CThunWeakened1"..BigWigsCThun.revision then
		self:CThunWeakened()
    elseif sync == "CThunWeakenedOver"..BigWigsCThun.revision then
        self:CThunWeakenedOver()
	elseif sync == "CThunGEdown"..BigWigsCThun.revision then
		self:TriggerEvent("BigWigs_Message", L["gedownwarn"], "Positive")
	elseif sync == "GiantEyeEyeBeam"..BigWigsCThun.revision then
        self:GiantEyeEyeBeam()
    elseif sync == "CThunEyeBeam"..BigWigsCThun.revision then
        self:CThunEyeBeam()
    elseif sync == "GiantClawSpawn"..BigWigsCThun.revision then
        self:GiantClawSpawn()
    elseif sync == "FleshTentacleHealthCheck"..BigWigsCThun.revision then
        self:FleshTentacleHealthCheck()
    end
end

-----------------------
--   Sync Handlers   --
-----------------------

function BigWigsCThun:CThunStart()
    self:DebugMessage("CThunStart: ")
	if not cthunstarted then
		cthunstarted = true

		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention", false, false)
        self:Bar(L["barStartRandomBeams"], timeP1RandomEyeBeams, iconGiantEye)

		if self.db.profile.tentacle then
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP1TentacleStart, "Interface\\Icons\\"..iconEyeTentacles)
			self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", timeP1TentacleStart - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, "Alert")
		end

        firstGlare = true
        self:DarkGlare()
		
		firstWarning = true

		self:ScheduleEvent("bwcthuntentaclesstart", self.StartTentacleRape, timeP1TentacleStart, self )
		self:ScheduleEvent("bwcthungroupwarningstart", self.GroupWarning, timeP1GlareStart - 1, self )
		self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, timeTarget, self )
        
        BigWigsProximity:BigWigs_ShowProximity(self)
	end
end

function BigWigsCThun:CThunP2Start()
	if not phase2started then
		phase2started = true
		tentacletime = timeP2Tentacle

		self:TriggerEvent("BigWigs_Message", L["phase2starting"], "Bosskill")

        -- cancel dark glare
		self:TriggerEvent("BigWigs_StopBar", self, L["barGlare"] )
        self:TriggerEvent("BigWigs_StopBar", self, L["barGlareCasting"] )
        self:TriggerEvent("BigWigs_StopBar", self, L["barGlareEnds"] )
        self:CancelScheduledEvent("bwcthundarkglare")
        self:CancelScheduledEvent("bwcthundarkglarestart")
        self:CancelScheduledEvent("bwcthunglarebar")
        self:CancelScheduledEvent("bwcthunnextglare")
        self:TriggerEvent("BigWigs_HideWarningSign")
        
        -- cancel eye tentacles
		self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barNoRape"] )
		self:CancelScheduledEvent("bwcthuntentacle")
        self:CancelScheduledEvent("bwcthuntentacles")
        self:CancelScheduledEvent("bwcthuntentaclesstart")
		
        -- cancel dark glare group warning
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:CancelScheduledEvent("bwcthuntarget")
        self:CancelScheduledEvent("bwcthungroupwarningstart")
        self:CancelScheduledEvent("bwcthunglareendsmessage")
        
        self:TriggerEvent("BigWigs_StopBar", self, L["barStartRandomBeams"] )
        
        -- start P2 events
		if self.db.profile.tentacle then
            -- first eye tentacles
			self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", timeP2FirstEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP2FirstEyeTentacles, "Interface\\Icons\\"..iconEyeTentacles)
		end

		if self.db.profile.giant then
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2FirstGiantEye, "Interface\\Icons\\"..iconGiantEye)
            self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2FirstGiantEye - 5, L["GiantEye"], "Urgent", false, "Alarm")
            
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2FirstGiantClaw, "Interface\\Icons\\"..iconGiantClaw)
		end

		self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, timeP2FirstEyeTentacles, self )
	    self:ScheduleEvent("bwcthunstartgiant", self.StartGiantRape, timeP2FirstGiantEye, self )
	    self:ScheduleEvent("bwcthunstartgiantc", self.StartGiantCRape, timeP2FirstGiantClaw, self )
		self:ScheduleRepeatingEvent("bwcthuntargetp2", self.CheckTargetP2, timeTarget, self )
        
        timeLastEyeTentaclesSpawn = GetTime() + 10
        
        BigWigsProximity:BigWigs_HideProximity(self)
	end

end

function BigWigsCThun:CThunWeakened()
    isWeakened = true
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver"..BigWigsCThun.revision, 1)
    
	if self.db.profile.weakened then
		self:TriggerEvent("BigWigs_Message", L["weakened"], "Positive" )
        self:Sound("Murloc")
		self:TriggerEvent("BigWigs_StartBar", self, L["barWeakened"], timeWeakened, "Interface\\Icons\\"..iconWeaken)
		self:ScheduleEvent("bwcthunweaken2", "BigWigs_Message", timeWeakened - 5, L["invulnerable2"], "Urgent")
	end

	-- cancel tentacle timers
	self:CancelScheduledEvent("bwcthuntentacle")
	self:CancelScheduledEvent("bwcthungtentacles")
	self:CancelScheduledEvent("bwcthungctentacles")
    self:CancelScheduledEvent("bwcthungianteye")
    self:CancelScheduledEvent("bwcthunstartgiant")
    
    
	self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barNoRape"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiant"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiantC"])

    -- next eye tentacles 75s after last spawn / 45s delayed
	self:CancelScheduledEvent("bwcthuntentacles")
    local nextEyeTentacles = timeP2Tentacle - (GetTime() - timeLastEyeTentaclesSpawn) + timeWeakened;
    self:DebugMessage("nextEyeTentacles(".. nextEyeTentacles ..") = timeP2Tentacle(".. timeP2Tentacle ..") - (GetTime() - timeLastEyeTentaclesSpawn)(".. (GetTime() - timeLastEyeTentaclesSpawn) ..") + timeWeakened(".. timeWeakened ..")")
    self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], nextEyeTentacles, "Interface\\Icons\\"..iconEyeTentacles)    
    self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, nextEyeTentacles, self )
    self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", nextEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, "Alert")
    
    self:ScheduleEvent("bwcthunweakenedover", self.CThunWeakenedOver, timeWeakened, self )
    timeLastGiantEyeSpawn = 0 -- reset timer to force a refresh on the timer
end

function BigWigsCThun:CThunWeakenedOver()
    isWeakened = nil
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver"..BigWigsCThun.revision, 600)
    self:CancelScheduledEvent("bwcthunweakenedover")
    
    if self.db.profile.weakened then
        self:TriggerEvent("BigWigs_StopBar", self, L["barWeakened"])
        self:CancelScheduledEvent("bwcthunweaken2")
		self:TriggerEvent("BigWigs_Message", L["invulnerable1"], "Important" )
	end
    
    -- cancel tentacle timers
	self:CancelScheduledEvent("bwcthunstartgiantc")
	self:CancelScheduledEvent("bwcthunstartgiant")
	self:CancelScheduledEvent("bwcthungianteye")
    
    -- next giant claw 10s after weaken
    self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2FirstGiantClawAfterWeaken, "Interface\\Icons\\"..iconGiantClaw)
    self:ScheduleEvent("bwcthunstartgiantc", self.StartGiantCRape, timeP2FirstGiantClawAfterWeaken, self )
    
    -- next giant eye 40s after weaken
    self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2FirstGiantEyeAfterWeaken, "Interface\\Icons\\"..iconGiantEye)
	self:ScheduleEvent("bwcthunstartgiant", self.StartGiantRape, timeP2FirstGiantEyeAfterWeaken, self )
    self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2FirstGiantEyeAfterWeaken - 5, L["GiantEye"], "Urgent", false, "Alarm")
end

function BigWigsCThun:GiantEyeEyeBeam()
    local timeSinceLastSpawn = GetTime() - timeLastGiantEyeSpawn
    if timeSinceLastSpawn > 30 then
        timeLastGiantEyeSpawn = GetTime()
        self:StartGiantRape()
    end
    
    local name = L["Unknown"]
    self:CheckTargetP2()
    if BigWigsCThun.target then
        name = BigWigsCThun.target
        self:TriggerEvent("BigWigs_SetRaidIcon", name)
        if name == UnitName("player") then
            self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\"..iconEyeBeamSelf, 2)
        end
    end
    self:Bar(string.format(L["eyebeam"], name), timeEyeBeam, iconGiantEye, "green")
end

function BigWigsCThun:CThunEyeBeam()
    local name = L["Unknown"]
    self:CheckTarget()
    if BigWigsCThun.target then
        name = BigWigsCThun.target
        self:TriggerEvent("BigWigs_SetRaidIcon", name)
        if name == UnitName("player") then
            self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\"..iconEyeBeamSelf, 2)
        end
    end
    self:Bar(string.format(L["eyebeam"], name), timeEyeBeam, iconGiantEye, true, "green")
end

function BigWigsCThun:GiantClawSpawn()
    self:StartGiantCRape()
end

function BigWigsCThun:FleshTentacleHealthCheck()
   self:DebugMessage("Flesh Tentacle Health: " .. health .. "%") 
end

function BigWigsCThun:DigestiveAcid()
    self:Message(L["msgDigestiveAcid"], "Red", true, "RunAway")
    self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\"..iconDigestiveAcid, 5) --ability_creature_disease_02
end

-----------------------
-- Utility Functions --
-----------------------

function BigWigsCThun:StartTentacleRape()
	self:TentacleRape()
end

function BigWigsCThun:StartGiantRape()
	self:GTentacleRape()
end

function BigWigsCThun:StartGiantCRape()
	self:GCTentacleRape()
	--self:ScheduleRepeatingEvent("bwcthungctentacles", self.GCTentacleRape, timeP2GiantClaw, self )
end


function BigWigsCThun:CheckTarget()
	local i
	local newtarget = nil
	if( UnitName("playertarget") == eyeofcthun ) then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == eyeofcthun then
				newtarget = UnitName("Raid"..i.."targettarget")
				break
			end
		end
	end
	if( newtarget ) then
		BigWigsCThun.target = newtarget
	end
end

function BigWigsCThun:CheckTargetP2()
	local i
	local newtarget = nil
	if( UnitName("playertarget") == gianteye ) then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == gianteye then
				newtarget = UnitName("Raid"..i.."targettarget")
				break
			end
		end
	end
	if( newtarget ) then
		BigWigsCThun.target = newtarget
	end
end

function BigWigsCThun:GroupWarning()
    self:CheckTarget()
	if BigWigsCThun.target then
		local i, name, group, glareTarget, glareGroup, playerGroup
        local playerName = GetUnitName("player")
		for i = 1, GetNumRaidMembers(), 1 do
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if name == BigWigsCThun.target then 
                glareTarget = name
                glareGroup = group
            end
            if name == playerName then
                playerGroup = group
            end
		end
		if self.db.profile.group then
			self:TriggerEvent("BigWigs_Message", string.format( L["groupwarning"], glareGroup, BigWigsCThun.target), "Important")
			--self:TriggerEvent("BigWigs_SendTell", target, L["glarewarning"])
            
            -- dark glare near you?
            if (playerGroup == glareGroup or playerGroup == glareGroup - 1 or playerGroup == glareGroup + 1 or playerGroup == glareGroup - 7 or playerGroup == glareGroup + 7) then
                 self:Sound("RunAway")
            else
                self:Sound("Beware")
            end
            
            -- announce glare group
            local number = "Eight"
            if glareGroup == 1 then
                number = "One"
            elseif glareGroup == 2 then
                number = "Two"
            elseif glareGroup == 3 then
                number = "Three"
            elseif glareGroup == 4 then
                number = "Four"
            elseif glareGroup == 5 then
                number = "Five"
            elseif glareGroup == 6 then
                number = "Six"
            elseif glareGroup == 7 then
                number = "Seven"
            end
            self:DelayedSound(1, number)
            
		end
	else
        self:Sound("Beware")
    end
	if firstWarning then
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:ScheduleRepeatingEvent("bwcthungroupwarning", self.GroupWarning, timeP1Glare, self )
		firstWarning = nil
	end
end

function BigWigsCThun:GTentacleRape()
    self:ScheduleEvent("bwcthungtentacles", self.GTentacleRape, timeP2ETentacle, self )
	if phase2started then
        if self.db.profile.giant then
            self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2ETentacle, "Interface\\Icons\\"..iconGiantEye)
            self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2ETentacle - 5, L["GiantEye"], "Urgent", false, "Alarm")
            
            if timeLastGiantEyeSpawn > 0 then
                self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\"..iconGiantEye, 5)
            end
        end
    end
end

function BigWigsCThun:GCTentacleRape()
    self:CancelScheduledEvent("bwcthungctentacles")
    self:ScheduleEvent("bwcthungctentacles", self.GCTentacleRape, timeP2GiantClaw, self )
    if phase2started then
        if self.db.profile.giant then
            self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2GiantClaw, "Interface\\Icons\\"..iconGiantClaw)
        end
    end
end

function BigWigsCThun:TentacleRape()
    timeLastEyeTentaclesSpawn = GetTime()
	self:ScheduleEvent("bwcthuntentacles", self.TentacleRape, tentacletime, self )
	if self.db.profile.tentacle then
		self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], tentacletime, "Interface\\Icons\\"..iconEyeTentacles)
		self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", tentacletime - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, "Alert")
	end
end

function BigWigsCThun:DarkGlare()
    if self.db.profile.glare then
        if firstGlare then
			self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timeP1GlareStart, self )
			
			self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1GlareStart, "Interface\\Icons\\"..iconDarkGlare)
            firstGlare = nil
        else
			self:ScheduleEvent("bwcthundarkglare", self.DarkGlare, timeP1Glare, self )
			
			self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\"..iconDarkGlare, 5)
			self:Message(L["glare"], "Urgent", true, false)
			self:Bar(L["barGlareCasting"], timeP1GlareCasting, iconDarkGlare)
		        
			self:ScheduleEvent("bwcthunglarebar", "BigWigs_StartBar", timeP1GlareCasting, self, L["barGlareEnds"], timeP1GlareDuration, "Interface\\Icons\\"..iconDarkGlare)
            self:ScheduleEvent("bwcthunglareendsmessage", "BigWigs_Message", timeP1GlareCasting + timeP1GlareDuration - 5, L["msgGlareEnds"], "Urgent", false, "Alarm")
			self:ScheduleEvent("bwcthunnextglare", "BigWigs_StartBar", timeP1GlareCasting + timeP1GlareDuration, self, L["barGlare"], timeP1Glare - timeP1GlareCasting - timeP1GlareDuration, "Interface\\Icons\\"..iconDarkGlare)
        end
    end
	
end

function BigWigsCThun:PlayerDamageEvents(msg)
    if not string.find(msg, "Eye of C'Thun") then
        local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"])
        if stype and dmg and school then
            if tonumber(dmg) > 100 then
                -- trigger weakend
                self:TriggerEvent("BigWigs_SendSync", "CThunWeakened1"..BigWigsCThun.revision)
            elseif isWeakened and tonumber(dmg) == 1 then
                -- trigger weakened over
                self:DebugMessage("C'Thun weakened over trigger")
                self:Sync("CThunWeakenedOver"..BigWigsCThun.revision)
            end
        end
    end
end

function BigWigsCThun:CheckEyeBeam(msg)
    if string.find(msg, L["eye_beam_trigger"]) then
        self:DebugMessage("Eye Beam trigger")
        self:Sync("GiantEyeEyeBeam"..BigWigsCThun.revision)
    elseif string.find(msg, L["eye_beam_trigger_cthun"]) then
        self:DebugMessage("C'Thun Eye Beam trigger")
        self:Sync("CThunEyeBeam"..BigWigsCThun.revision)
        if not cthunstarted then 
            self:TriggerEvent("BigWigs_SendSync", "CThunStart"..BigWigsCThun.revision)
        end
    end
end

function BigWigsCThun:CheckGiantClawSpawn(msg)
    self:DebugMessage("GiantClawSpawn: " .. msg)
    if string.find(msg, L["giant_claw_spawn_trigger"]) then
        self:Sync("GiantClawSpawn"..BigWigsCThun.revision)
    end
end

function BigWigsCThun:CheckFleshTentacles(msg)
    if UnitName(msg) == L["FleshTentacle"] then
		health = UnitHealth(msg)
        self:Sync("FleshTentacleHealthCheck"..BigWigsCThun.revision)
	end
end

function BigWigsCThun:CheckDigestiveAcid(msg)
    local _, _, stacks = string.find(msg, L["digestiveAcidTrigger"])
    
    if stacks then
        self:DebugMessage("Digestive Acid Stacks: " .. stacks)
        if tonumber(stacks) == 5 then
            self:DigestiveAcid()
        end
    end
    --[[self:DebugMessage("a: "..a.." b: "..b.." c: "..c)
    self:DebugMessage("Digestive Acid: "..msg .. " trigger: " .. L["digestiveAcidTrigger"])
    if string.find(msg, L["digestiveAcidTrigger"]) then
        self:DebugMessage("Digestive Acid: "..msg) 
        self:DigestiveAcid()
    end]]
end