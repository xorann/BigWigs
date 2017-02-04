
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("C'Thun", "Ahn'Qiraj")


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
    giant_eye_spawn_trigger = "Giant Eye Tentacle 's Ground Rupture",
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
	
    acid_cmd = "acid",
    acid_name = "Digestive Acid alert",
    acid_desc = "Shows a warning sign when you have 5 stacks of digestive acid",
    digestiveAcidTrigger = "You are afflicted by Digestive Acid [%s%(]*([%d]*).",        
    msgDigestiveAcid = "5 Acid Stacks",

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
    giant_eye_spawn_trigger =  "Riesiges Augententakel(.+) Erdriss", -- "Giant Eye Tentacle 's Ground Rupture",
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
	
    acid_cmd = "acid",
    acid_name = "Magensäure Alarm",
    acid_desc = "Zeigt ein Warnzeichen wenn du mehr als 5 Stapel der Magensäure hast.",
    digestiveAcidTrigger = "Ihr seid von Magensäure [%s%(]*([%d]*)", -- "You are afflicted by Digestive Acid (5).",  
    msgDigestiveAcid = "5 Säure Stacks",
            
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


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20008 -- To be overridden by the module!
local eyeofcthun = AceLibrary("Babble-Boss-2.2")["Eye of C'Thun"]
local cthun = AceLibrary("Babble-Boss-2.2")["C'Thun"]
module.enabletrigger = {eyeofcthun, cthun} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"rape", -1, "tentacle", "glare", "group", -1, "giant", "acid", "weakened", "proximity", "bosskill"}

-- Proximity Plugin
module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
module.proximitySilent = false


-- locals
local timer = {
	p1RandomEyeBeams = 15, -- how long does eye of c'thun target the same player at the beginning
	p1Tentacle = 45,      -- tentacle timers for phase 1
	p1TentacleStart = 45, -- delay for first tentacles from engage onwards
	p1GlareStart = 50,    -- delay for first dark glare from engage onwards
	p1Glare = 85,         -- interval for dark glare
	p1GlareCasting = 5,   -- time it takes from casting dark glare until the spell starts
	p1GlareDuration = 30, -- duration of dark glare
	
	p2Offset = 10,        -- delay for all timers to restart after the Eye dies
	p2Tentacle = 30,      -- tentacle timers for phase 2
	p2ETentacle = 40,     -- Eye tentacle timers for phase 2
	p2GiantClaw = 40,     -- Giant Claw timer for phase 2
	p2FirstGiantClaw = 25, -- first giant claw after eye of c'thun dies
	p2FirstGiantEye = 56, -- first giant eye after eye of c'thun dies
	p2FirstEyeTentacles = 45, -- first eye tentacles after eye of c'thun dies
	p2FirstGiantClawAfterWeaken = 10,
	p2FirstGiantEyeAfterWeaken = 40,
	
	reschedule = 50,      -- delay from the moment of weakening for timers to restart
	target = 1,           -- delay for target change checking on Eye of C'Thun and Giant Eye Tentacle
	weakened = 45,        -- duration of a weaken
	
	lastEyeTentaclesSpawn = 0,
	lastGiantEyeSpawn = 0,
	eyeBeam = 2,         -- Eye Beam Cast time
}
local icon = {
	giantEye = "inv_misc_eye_01", --"Interface\\Icons\\Ability_EyeOfTheOwl"
	giantClaw = "Spell_Nature_Earthquake",
	eyeTentacles = "spell_shadow_siphonmana", --"Interface\\Icons\\Spell_Nature_CallStorm"
	darkGlare = "Inv_misc_ahnqirajtrinket_04",
	weaken = "INV_ValentinesCandy",
	eyeBeamSelf = "Ability_creature_poison_05",
	digestiveAcid = "ability_creature_disease_02",
}
local syncName = {
	p2Start = "CThunP2Start1",
	weaken = "CThunWeakened2",
	weakenOver = "CThunWeakenedOver1",
	giantEyeDown = "CThunGEdown1",
	giantClawSpawn = "GiantClawSpawn1",
    giantEyeSpawn = "GiantEyeSpawn",
	giantEyeEyeBeam = "GiantEyeEyeBeam1",
	cthunEyeBeam = "CThunEyeBeam1",
}

local gianteye = "Giant Eye Tentacle"

local health = 100

local cthunstarted = nil
local phase2started = nil
local firstGlare = nil
local firstWarning = nil
--local target = nil
local tentacletime = timer.p1Tentacle
local isWeakened = nil

local doCheckForWipe = false

local eyeTarget = nil


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE", "Emote")		-- weakened triggering, does not work on nefarian
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE", "Emote")		-- weakened triggering, does not work on nefarian
	self:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS", "PlayerDamageEvents")				-- alternative weaken trigger for nefarian
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents") 				-- alternative weaken trigger for nefarian
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents") 				-- alternative weaken trigger for nefarian
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents") 			-- alternative weaken trigger for nefarian
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")	-- alternative weaken trigger for nefarian
     
    
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckEyeBeam")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "CheckTentacleSpawn")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "CheckTentacleSpawn")

    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckDigestiveAcid")
	
	--self:ThrottleSync(20, syncName.start)
	self:ThrottleSync(20, syncName.p2Start)
	self:ThrottleSync(50, syncName.weaken)
	self:ThrottleSync(3, syncName.giantEyeDown)
	self:ThrottleSync(600, syncName.weakenOver)
	self:ThrottleSync(30, syncName.giantClawSpawn)
end

-- called after module is enabled and after each wipe
function module:OnSetup()	
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
    
	self.started = nil
	eyeTarget = nil
	cthunstarted = nil
	firstGlare = nil
	firstWarning = nil
	phase2started = nil
    doCheckForWipe = false
    
	tentacletime = timer.p1Tentacle
    
    self:RemoveProximity() 
end

-- called after boss is engaged
function module:OnEngage()
	self:CThunStart()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


----------------------
--  Event Handlers  --
----------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
    BigWigs:CheckForBossDeath(msg, self)
    
	if (msg == string.format(UNITDIESOTHER, eyeofcthun)) then
		self:Sync(syncName.p2Start)
	elseif (msg == string.format(UNITDIESOTHER, gianteye)) then
		self:Sync(syncName.giantEyeDown)
	--[[elseif (msg == string.format(UNITDIESOTHER, cthun)) then
		if self.db.profile.bosskill then self:Message(string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], cthun), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)]]
	end
end

function module:CheckForWipe(event)
    if doCheckForWipe then
        BigWigs:DebugMessage("doCheckForWipe")
        BigWigs:CheckForWipe(self)
    end
end

-- does not work on nefarian
function module:Emote( msg )
	if string.find(msg, L["weakenedtrigger"]) then 
        self:Sync(syncName.weaken) 
    end
end
-- alternative weaken trigger for nefarian
function module:PlayerDamageEvents(msg)
    if not string.find(msg, "Eye of C'Thun") then
        local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"])
        if stype and dmg and school then
            if not isWeakened and tonumber(dmg) > 100 then
                -- trigger weakened
                self:Sync(syncName.weaken)
            elseif isWeakened and tonumber(dmg) == 1 then
                -- trigger weakened over
                self:DebugMessage("C'Thun weakened over trigger")
                self:Sync(syncName.weakenOver)
            end
        end
    end
end

function module:CheckEyeBeam(msg)
    if string.find(msg, L["eye_beam_trigger"]) then
        self:DebugMessage("Eye Beam trigger")
        self:Sync(syncName.giantEyeEyeBeam)
    elseif string.find(msg, L["eye_beam_trigger_cthun"]) then
        self:DebugMessage("C'Thun Eye Beam trigger")
        self:Sync(syncName.cthunEyeBeam)
        if not cthunstarted then 
            self:SendEngageSync()
        end
    end
end

function module:CheckTentacleSpawn(msg)
    self:DebugMessage("GiantClawSpawn: " .. msg)
    if string.find(msg, L["giant_claw_spawn_trigger"]) then
        self:Sync(syncName.giantClawSpawn)
    elseif string.find(msg, L["giant_eye_spawn_trigger"]) then
        timer.lastGiantEyeSpawn = GetTime()
        self:Sync(syncName.giantEyeSpawn)
    end
end

function module:CheckDigestiveAcid(msg)
    local _, _, stacks = string.find(msg, L["digestiveAcidTrigger"])
    
    if stacks then
        self:DebugMessage("Digestive Acid Stacks: " .. stacks)
        if tonumber(stacks) == 5 then
            self:DigestiveAcid()
        end
    end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.p2Start then
		self:CThunP2Start()
	elseif sync == syncName.weaken then
		self:CThunWeakened()
    elseif sync == syncName.weakenOver then
        self:CThunWeakenedOver()
	elseif sync == syncName.giantEyeDown then
		self:Message(L["gedownwarn"], "Positive")
	elseif sync == syncName.giantEyeEyeBeam then
        self:GiantEyeEyeBeam()
    elseif sync == syncName.cthunEyeBeam then
        self:EyeBeam()
    elseif sync == syncName.giantClawSpawn then
        self:GCTentacleRape()
    elseif sync == syncName.giantEyeSpawn then
        self:GTentacleRape()
    end
end

-----------------------
--   Sync Handlers   --
-----------------------

function module:CThunStart()
    self:DebugMessage("CThunStart: ")
	if not cthunstarted then
		cthunstarted = true
        doCheckForWipe = true

		self:Message(L["startwarn"], "Attention", false, false)
        self:Bar(L["barStartRandomBeams"], timer.p1RandomEyeBeams, icon.giantEye)

		if self.db.profile.tentacle then
			self:Bar(self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timer.p1TentacleStart, icon.eyeTentacles)
			self:DelayedMessage(timer.p1TentacleStart - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, "Alert")
		end

        firstGlare = true
        self:DarkGlare()
		
		firstWarning = true

		self:ScheduleEvent("bwcthuntentaclesstart", self.TentacleRape, timer.p1TentacleStart, self)
		self:ScheduleEvent("bwcthungroupwarningstart", self.GroupWarning, timer.p1GlareStart - 1, self)
		self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, timer.target, self)
        
        self:Proximity()
	end
end

function module:CThunP2Start()
	if not phase2started then
		phase2started = true
        doCheckForWipe = false -- disable wipe check since we get out of combat, enable it later again
		tentacletime = timer.p2Tentacle

		self:Message(L["phase2starting"], "Bosskill")

        -- cancel dark glare
		self:RemoveBar(L["barGlare"] )
        self:RemoveBar(L["barGlareCasting"] )
        self:RemoveBar(L["barGlareEnds"] )
        self:CancelScheduledEvent("bwcthundarkglare") -- ok
        self:CancelScheduledEvent("bwcthundarkglarestart") -- ok
        self:CancelDelayedBar(L["barGlareEnds"])
        self:CancelDelayedBar(L["barGlare"]) 
		self:RemoveWarningSign(icon.darkGlare)
        
        -- cancel eye tentacles
        
		self:RemoveBar(L["barTentacle"] )
		self:RemoveBar(L["barNoRape"] )
		self:CancelDelayedMessage(self.db.profile.rape and L["tentacle"] or L["norape"])
		self:CancelScheduledEvent("bwcthuntentacles") -- ok
        self:CancelScheduledEvent("bwcthuntentaclesstart") -- ok
		
        -- cancel dark glare group warning
		self:CancelScheduledEvent("bwcthungroupwarning") -- ok
		self:CancelScheduledEvent("bwcthuntarget") -- ok
        self:CancelScheduledEvent("bwcthungroupwarningstart") -- ok
        
        self:RemoveBar(L["barStartRandomBeams"] )
        
        -- start P2 events
		if self.db.profile.tentacle then
            -- first eye tentacles
			self:DelayedMessage(timer.p2FirstEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, nil, true)
			self:Bar(self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timer.p2FirstEyeTentacles, icon.eyeTentacles)
		end

		if self.db.profile.giant then
			self:Bar(L["barGiant"], timer.p2FirstGiantEye, icon.giantEye)
            self:DelayedMessage(timer.p2FirstGiantEye - 5, L["GiantEye"], "Urgent", false, nil, true)
            
			self:Bar(L["barGiantC"], timer.p2FirstGiantClaw, icon.giantClaw)
		end

		self:ScheduleEvent("bwcthunstarttentacles", self.TentacleRape, timer.p2FirstEyeTentacles, self )
	    self:ScheduleEvent("bwcthunstartgiant", self.GTentacleRape, timer.p2FirstGiantEye, self )
	    self:ScheduleEvent("bwcthunstartgiantc", self.GCTentacleRape, timer.p2FirstGiantClaw, self )
		self:ScheduleRepeatingEvent("bwcthuntargetp2", self.CheckTarget, timer.target, self )
        
        timer.lastEyeTentaclesSpawn = GetTime() + 10
        
        self:RemoveProximity()
	end

end

function module:CThunWeakened()
    isWeakened = true
	self:ThrottleSync(0.1, syncName.weakenOver)
    
	if self.db.profile.weakened then
		self:Message(L["weakened"], "Positive" )
        self:Sound("Murloc")
		self:Bar(L["barWeakened"], timer.weakened, icon.weaken)
		self:Message(timer.weakened - 5, L["invulnerable2"], "Urgent")
	end

	-- cancel tentacle timers
	self:CancelDelayedMessage(self.db.profile.rape and L["tentacle"] or L["norape"])
	self:CancelScheduledEvent("bwcthungtentacles") -- ok
	self:CancelScheduledEvent("bwcthungctentacles") -- ok
    self:CancelDelayedMessage(L["GiantEye"]) 
	self:CancelScheduledEvent("bwcthunstartgiant") -- ok
    
    
	self:RemoveBar(L["barTentacle"])
	self:RemoveBar(L["barNoRape"])
	self:RemoveBar(L["barGiant"])
	self:RemoveBar(L["barGiantC"])

    -- next eye tentacles 75s after last spawn / 45s delayed
	self:CancelScheduledEvent("bwcthuntentacles") -- ok
    local nextEyeTentacles = timer.p2Tentacle - (GetTime() - timer.lastEyeTentaclesSpawn) + timer.weakened;
    self:DebugMessage("nextEyeTentacles(".. nextEyeTentacles ..") = timer.p2Tentacle(".. timer.p2Tentacle ..") - (GetTime() - timer.lastEyeTentaclesSpawn)(".. (GetTime() - timer.lastEyeTentaclesSpawn) ..") + time.weakened(".. timer.weakened ..")")
    self:Bar(self.db.profile.rape and L["barTentacle"] or L["barNoRape"], nextEyeTentacles, icon.eyeTentacles)    
    self:ScheduleEvent("bwcthunstarttentacles", self.TentacleRape, nextEyeTentacles, self )
    self:DelayedMessage(nextEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, nil, true)
    
    self:ScheduleEvent("bwcthunweakenedover", self.CThunWeakenedOver, timer.weakened, self )
    timer.lastGiantEyeSpawn = 0 -- reset timer to force a refresh on the timer
end

function module:CThunWeakenedOver()
    isWeakened = nil
	self:ThrottleSync(600, syncName.weakenOver)
	
    self:CancelScheduledEvent("bwcthunweakenedover") -- ok
    
    if self.db.profile.weakened then
        self:RemoveBar(L["barWeakened"])
        self:CancelDelayedMessage(L["invulnerable2"])
		
		self:Message(L["invulnerable1"], "Important")
	end
    
    -- cancel tentacle timers
	self:CancelScheduledEvent("bwcthunstartgiantc") -- ok
	self:CancelScheduledEvent("bwcthunstartgiant") -- ok
	self:CancelDelayedMessage(L["GiantEye"]) 
	
    -- next giant claw 10s after weaken
    self:Bar(L["barGiantC"], timer.p2FirstGiantClawAfterWeaken, icon.giantClaw)
    self:ScheduleEvent("bwcthunstartgiantc", self.GCTentacleRape, timer.p2FirstGiantClawAfterWeaken, self )
    
    -- next giant eye 40s after weaken
    self:Bar(L["barGiant"], timer.p2FirstGiantEyeAfterWeaken, icon.giantEye)
	self:ScheduleEvent("bwcthunstartgiant", self.GTentacleRape, timer.p2FirstGiantEyeAfterWeaken, self )
    self:DelayedMessage(timer.p2FirstGiantEyeAfterWeaken - 5, L["GiantEye"], "Urgent", false, nil, true)
end

function module:GiantEyeEyeBeam()
    local timeSinceLastSpawn = GetTime() - timer.lastGiantEyeSpawn
    if timeSinceLastSpawn > 30 then
        timer.lastGiantEyeSpawn = GetTime()
        self:GTentacleRape()
    end
    
    self:EyeBeam()
end

function module:DelayedEyeBeamCheck()
	local name = L["Unknown"]
    self:CheckTarget()
    if eyeTarget then
        name = eyeTarget
        self:Icon(name)
        if name == UnitName("player") then
            self:WarningSign(icon.eyeBeamSelf, 2 - 0.1)
        end
    end
    self:Bar(string.format(L["eyebeam"], name), timer.eyeBeam - 0.1, icon.giantEye, true, "green")
end
function module:EyeBeam()
	self:ScheduleEvent("CThunDelayedEyeBeamCheck", self.DelayedEyeBeamCheck, 0.1, self) -- has to be done delayed since the target change is delayed
end

function module:DigestiveAcid()
    if self.db.profile.acid then
        self:Message(L["msgDigestiveAcid"], "Red", true, "RunAway")
        self:WarningSign(icon.digestiveAcid, 5) --ability_creature_disease_02
    end
end

-----------------------
-- Utility Functions --
-----------------------

function module:CheckTarget()
	local i
	local newtarget = nil
	local enemy = eyeofcthun
	
	if phase2started then
		enemy = gianteye
	end
	if UnitName("playertarget") == enemy then
		newtarget = UnitName("playertargettarget")
	else
		for i = 1, GetNumRaidMembers(), 1 do
			if UnitName("Raid"..i.."target") == enemy then
				newtarget = UnitName("Raid"..i.."targettarget")
				break
			end
		end
	end
	if newtarget then
		eyeTarget = newtarget
	end
end

-- P1
function module:DarkGlare()
    if self.db.profile.glare then
        if firstGlare then
			self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timer.p1GlareStart, self )
			
			self:Bar(L["barGlare"], timer.p1GlareStart, icon.darkGlare)
            firstGlare = nil
        else
			self:ScheduleEvent("bwcthundarkglare", self.DarkGlare, timer.p1Glare, self )
			
			self:WarningSign(icon.darkGlare, 5)
			self:Message(L["glare"], "Urgent", true, false)
			self:Bar(L["barGlareCasting"], timer.p1GlareCasting, icon.darkGlare)
		        
			self:DelayedBar(timer.p1GlareCasting, L["barGlareEnds"], timer.p1GlareDuration, icon.darkGlare)
            self:DelayedMessage(timer.p1GlareCasting + timer.p1GlareDuration - 5, L["msgGlareEnds"], "Urgent", false, nil, true)
			self:DelayedBar(timer.p1GlareCasting + timer.p1GlareDuration, L["barGlare"], timer.p1Glare - timer.p1GlareCasting - timer.p1GlareDuration, icon.darkGlare)
        end
    end
end

function module:GroupWarning()
    self:CheckTarget()
	if eyeTarget then
        BigWigs:DebugMessage("GroupWarning; target: " .. eyeTarget)
		local i, name, group, glareTarget, glareGroup, playerGroup
        local playerName = GetUnitName("player")
		for i = 1, GetNumRaidMembers(), 1 do
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if name == eyeTarget then 
                glareTarget = name
                glareGroup = group
            end
            if name == playerName then
                playerGroup = group
            end
		end
		if self.db.profile.group then
			self:Message(string.format( L["groupwarning"], glareGroup, eyeTarget), "Important")
            
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
		self:CancelScheduledEvent("bwcthungroupwarning") -- ok
		self:ScheduleRepeatingEvent("bwcthungroupwarning", self.GroupWarning, timer.p1Glare, self )
		firstWarning = nil
	end
end

-- P2
function module:GTentacleRape()
    self:ScheduleEvent("bwcthungtentacles", self.GTentacleRape, timer.p2ETentacle, self )
	if phase2started then
        if self.db.profile.giant then
            self:Bar(L["barGiant"], timer.p2ETentacle, icon.giantEye)
            self:DelayedMessage(timer.p2ETentacle - 5, L["GiantEye"], "Urgent", false, nil, true)
            
            if timer.lastGiantEyeSpawn > 0 then
                self:WarningSign(icon.giantEye, 5)
            end
        end
    end
end

function module:GCTentacleRape()
	doCheckForWipe = true
    self:CancelScheduledEvent("bwcthungctentacles") -- ok
    self:ScheduleEvent("bwcthungctentacles", self.GCTentacleRape, timer.p2GiantClaw, self )
    if phase2started then
        if self.db.profile.giant then
            self:Bar(L["barGiantC"], timer.p2GiantClaw, icon.giantClaw)
        end
    end
end

function module:TentacleRape()
    timer.lastEyeTentaclesSpawn = GetTime()
	self:ScheduleEvent("bwcthuntentacles", self.TentacleRape, tentacletime, self )
	if self.db.profile.tentacle then
		self:Bar(self.db.profile.rape and L["barTentacle"] or L["barNoRape"], tentacletime, icon.eyeTentacles)
		self:DelayedMessage(tentacletime - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", false, nil, true)
	end
end