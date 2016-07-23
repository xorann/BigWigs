------------------------------
--      Are you local?      --
------------------------------

local eyeofcthun = AceLibrary("Babble-Boss-2.2")["Eye of C'Thun"]
local cthun = AceLibrary("Babble-Boss-2.2")["C'Thun"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs" .. cthun)

local gianteye = "Giant Eye Tentacle"

local timeP1Tentacle = 90      -- tentacle timers for phase 1
local timeP1TentacleStart = 45 -- delay for first tentacles from engage onwards
local timeP1GlareStart = 5    -- delay for first dark glare from engage onwards
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
local timeP1RandomEyeBeams = 15

local cthunstarted = nil
local phase2started = nil
local firstGlare = nil
local firstWarning = nil
local target = nil
local tentacletime = timeP1Tentacle
local isWeakened = nil


----------------------------
--      Localization      --
----------------------------


L:RegisterTranslations("enUS", function() return {
	cmd = "Cthun",

	tentacle_cmd = "tentacle",
	tentacle_name = "Tentacle Alert",
	tentacle_desc = "Warn for Tentacles",

	glare_cmd = "glare",
	glare_name = "Dark Glare Alert",
	glare_desc = "Warn for Dark Glare",

	group_cmd = "group",
	group_name = "Dark Glare Group Warning",
	group_desc = "Warn for Dark Glare on Group X",

	giant_cmd = "giant",
	giant_name = "Giant Eye Alert",
	giant_desc = "Warn for Giant Eyes",

	weakened_cmd = "weakened",
	weakened_name = "Weakened Alert",
	weakened_desc = "Warn for Weakened State",

	rape_cmd = "rape",
	rape_name = "Rape jokes are funny",
	rape_desc = "Some people like hentai jokes.",

	weakenedtrigger = "is weakened!",
	tentacle	= "Tentacle Rape Party - 5 sec",

	norape		= "Tentacles in 5sec!",

	testbar		= "time",
	say		= "say",

	weakened	= "C'Thun is weakened for 45 sec",
	invulnerable2	= "Party ends in 5 seconds",
	invulnerable1	= "Party over - C'Thun invulnerable",

	GNPPtrigger	= "Nature Protection",
	GSPPtrigger	= "Shadow Protection",
	Sundertrigger	= "Sunder Armor",
	CoEtrigger	= "Curse of the Elements",
	CoStrigger	= "Curse of Shadow",
	CoRtrigger	= "Curse of Recklessness",
            
    vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) C'Thun for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
	vulnerability_dots_test = "^C'Thun suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)", 
    eye_beam_trigger = "Giant Eye Tentacle begins to cast Eye Beam.",
    eye_beam_trigger_cthun = "Eye of C'Thun begins to cast Eye Beam.",
    giant_claw_spawn_trigger = "Giant Claw Tentacle 's Ground Rupture",
            
	startwarn	= "C'Thun engaged! - 45 sec until Dark Glare and Eyes",

	glare		= "Dark glare!",

	barTentacle	= "Tentacle rape party!",
	barNoRape	= "Tentacle party!",
	barWeakened	= "C'Thun is weakened!",
	barGlare	= "Next dark glare!",
    barGlareEnds = "Dark glare ends",
    barGlareCasting = "Casting dark glare",
	barGiant	= "Giant Eye!",
	barGiantC	= "Giant Claw!",
	barGreenBeam	= "Eye tentacle spawn!",
    barStartRandomBeams = "Start of Random Beams!",
	gedownwarn	= "Giant Eye down!",
    GiantEye = "Giant Eye Tentacle in 5 sec!",

	eyebeam		= "Eye Beam on %s",
	glarewarning	= "DARK GLARE ON YOU!",
	groupwarning	= "Dark Glare on group %s (%s)",
	positions2	= "Dark Glare ends in 5 sec",
	phase2starting	= "The Eye is dead! Body incoming!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsCThun = BigWigs:NewModule(cthun)
BigWigsCThun.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsCThun.enabletrigger = { eyeofcthun, cthun }
BigWigsCThun.bossSync = "CThun"
BigWigsCThun.toggleoptions = { "rape", -1, "tentacle", "glare", "group", -1, "giant", "weakened", "bosskill" }
BigWigsCThun.revision = tonumber(string.sub("$Revision: 20000 $", 12, -3))

function BigWigsCThun:OnEnable()
    self.started = nil
	target = nil
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
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE") -- engage of Eye of C'Thun
	-- Not sure about this, since we get out of combat between the phases.
	--self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
    
    self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")   
    
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "CheckEyeBeam")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "GiantClawSpawn")
    self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "GiantClawSpawn")
    

	self:RegisterEvent("BigWigs_RecvSync")

	self:TriggerEvent("BigWigs_ThrottleSync", "CThunStart", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunP2Start", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakened1", 50)
	self:TriggerEvent("BigWigs_ThrottleSync", "CThunGEdown", 3)
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver", 600)
    self:TriggerEvent("BigWigs_ThrottleSync", "GiantClawSpawn", 30)    
end

----------------------
--  Event Handlers  --
----------------------

function BigWigsCThun:GenericBossDeath(event)
   --DEFAULT_CHAT_FRAME:AddMessage("Debug: GenericBossDeath: " .. event) 
end

function BigWigsCThun:Emote( msg )
	if string.find(msg, L["weakenedtrigger"]) then self:TriggerEvent("BigWigs_SendSync", "CThunWeakened1") end
end

function BigWigsCThun:CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE( arg1 )
	if not cthunstarted and arg1 and string.find(arg1, L["eyebeam"]) then 
        self:TriggerEvent("BigWigs_SendSync", "CThunStart")
        end
end

function BigWigsCThun:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if (msg == string.format(UNITDIESOTHER, eyeofcthun)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunP2Start")
	elseif (msg == string.format(UNITDIESOTHER, gianteye)) then
		self:TriggerEvent("BigWigs_SendSync", "CThunGEdown")
	elseif (msg == string.format(UNITDIESOTHER, cthun)) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], cthun), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsCThun:BigWigs_RecvSync(sync, rest, nick)
    if not self.started and ((sync == "BossEngaged" and rest == self.bossSync) or (sync == "CThunStart")) then
        if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then self:UnregisterEvent("PLAYER_REGEN_DISABLED") end
        self:StartFight()
		self:CThunStart()
        
	elseif sync == "CThunP2Start" then
		self:CThunP2Start()
	elseif sync == "CThunWeakened1" then
		self:CThunWeakened()
    elseif sync == "CThunWeakenedOver" then
        self:CThunWeakenedOver()
	elseif sync == "CThunGEdown" then
		self:TriggerEvent("BigWigs_Message", L["gedownwarn"], "Positive")
	elseif sync == "GiantEyeEyeBeam" then
        self:GiantEyeEyeBeam()
    elseif sync == "CThunEyeBeam" then
        self:CThunEyeBeam()
    elseif sync == "GiantClawSpawn" then
        self:GiantClawSpawn()
    end
end

-----------------------
--   Sync Handlers   --
-----------------------

function BigWigsCThun:CThunStart()
	if not cthunstarted then
		cthunstarted = true

		self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
        self:Bar(L["barStartRandomBeams"], timeP1RandomEyeBeams, "Ability_creature_disease_02")

		if self.db.profile.tentacle then
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP1TentacleStart, "Interface\\Icons\\Spell_Nature_CallStorm")
			self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", timeP1TentacleStart - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", true, "Alert")
		end

        firstGlare = true
        self:DarkGlare()
		--[[if self.db.profile.glare then
			self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1GlareStart, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
			--self:ScheduleEvent("bwcthunpositions2", "BigWigs_Message", timeP1GlareStart - 5, L["positions2"], "Urgent")
		end]]

		
		firstWarning = true

		self:ScheduleEvent("bwcthuntentaclesstart", self.StartTentacleRape, timeP1TentacleStart, self )
		--self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timeP1GlareStart, self )
		self:ScheduleEvent("bwcthungroupwarningstart", self.GroupWarning, timeP1GlareStart - 1, self )
		self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, timeTarget, self )
        --self:ScheduleRepeatingEvent("bwcthuntarget", self.CheckTarget, 1, self )
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
        self:TriggerEvent("BigWigs_HideWarningSign", "Interface\\Icons\\Ability_creature_cursed_04")
        
        -- cancel eye tentacles
		self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"] )
		self:TriggerEvent("BigWigs_StopBar", self, L["barNoRape"] )
		self:CancelScheduledEvent("bwcthuntentacle")
		self:CancelScheduledEvent("bwcthunpositions2")
        self:CancelScheduledEvent("bwcthuntentacles")
		
        -- cancel dark glare group warning
		self:CancelScheduledEvent("bwcthungroupwarning")
		self:CancelScheduledEvent("bwcthuntarget")
        
        self:TriggerEvent("BigWigs_StopBar", self, L["barStartRandomBeams"] )
        
        -- start P2 events
		if self.db.profile.tentacle then
            -- first eye tentacles
			self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", timeP2FirstEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", true, "Alert")
			self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], timeP2FirstEyeTentacles, "Interface\\Icons\\Spell_Nature_CallStorm")
		end

		if self.db.profile.giant then
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2FirstGiantEye, "Interface\\Icons\\Ability_EyeOfTheOwl")
            self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2FirstGiantEye - 5, L["GiantEye"], "Urgent", true, "Alarm")
            
			self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2FirstGiantClaw, "Interface\\Icons\\Spell_Nature_Earthquake")
		end

		self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, timeP2FirstEyeTentacles, self )
	    self:ScheduleEvent("bwcthunstartgiant", self.StartGiantRape, timeP2FirstGiantEye, self )
	    self:ScheduleEvent("bwcthunstartgiantc", self.StartGiantCRape, timeP2FirstGiantClaw, self )
		self:ScheduleRepeatingEvent("bwcthuntargetp2", self.CheckTargetP2, timeTarget, self )
        
        timeLastEyeTentaclesSpawn = GetTime() + 10
	end

end

function BigWigsCThun:CThunWeakened()
    isWeakened = true
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver", 1)
    
	if self.db.profile.weakened then
		self:TriggerEvent("BigWigs_Message", L["weakened"], "Positive" )
        self:Sound("Murloc")
		self:TriggerEvent("BigWigs_StartBar", self, L["barWeakened"], timeWeakened, "Interface\\Icons\\INV_ValentinesCandy")
		self:ScheduleEvent("bwcthunweaken2", "BigWigs_Message", timeWeakened - 5, L["invulnerable2"], "Urgent")
	end

	-- cancel tentacle timers
	self:CancelScheduledEvent("bwcthuntentacle")
	self:CancelScheduledEvent("bwcthungtentacles")
	self:CancelScheduledEvent("bwcthungctentacles")
    self:CancelScheduledEvent("bwcthungianteye")
    
	self:TriggerEvent("BigWigs_StopBar", self, L["barTentacle"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barNoRape"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiant"])
	self:TriggerEvent("BigWigs_StopBar", self, L["barGiantC"])

    -- next eye tentacles 75s after last spawn / 45s delayed
	self:CancelScheduledEvent("bwcthuntentacles")
    local nextEyeTentacles = timeP2Tentacle - (GetTime() - timeLastEyeTentaclesSpawn) + timeWeakened;
    self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], nextEyeTentacles, "Interface\\Icons\\Spell_Nature_CallStorm")    
    self:ScheduleEvent("bwcthunstarttentacles", self.StartTentacleRape, nextEyeTentacles, self )
    self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", nextEyeTentacles - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", true, "Alert")
    
    self:ScheduleEvent("bwcthunweakenedover", self.CThunWeakenedOver, timeWeakened, self )
end

function BigWigsCThun:CThunWeakenedOver()
    isWeakened = nil
    self:TriggerEvent("BigWigs_ThrottleSync", "CThunWeakenedOver", 600)
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
    self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2FirstGiantClawAfterWeaken, "Interface\\Icons\\Spell_Nature_Earthquake")
    self:ScheduleEvent("bwcthunstartgiantc", self.StartGiantCRape, timeP2FirstGiantClawAfterWeaken, self )
    
    -- next giant eye 40s after weaken
    self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2FirstGiantEyeAfterWeaken, "Interface\\Icons\\Ability_EyeOfTheOwl")
	self:ScheduleEvent("bwcthunstartgiant", self.StartGiantRape, timeP2FirstGiantEyeAfterWeaken, self )
    self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2FirstGiantEyeAfterWeaken - 5, L["GiantEye"], "Urgent", true, "Alarm")
end

function BigWigsCThun:GiantEyeEyeBeam()
    local name = "Unknown"
    if target then
        name = target
    end
    self:Bar(string.format(L["eyebeam"], name), 2, "Ability_creature_poison_05")
end

function BigWigsCThun:CThunEyeBeam()
    local name = "Unknown"
    if target then
        name = target
    end
    self:Bar(string.format(L["eyebeam"], name), 2, "Ability_creature_poison_05")
end

function BigWigsCThun:GiantClawSpawn()
    self:StartGiantCRape()
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
		target = newtarget
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
		target = newtarget
	end
end

function BigWigsCThun:GroupWarning()
	if target then
		local i, name, group, glareTarget, glareGroup, playerGroup
        local playerName = GetUnitName("player")
		for i = 1, GetNumRaidMembers(), 1 do
			name, _, group, _, _, _, _, _ = GetRaidRosterInfo(i)
			if name == target then 
                glareTarget = name
                glareGroup = group
            end
            if name == playerName then
                playerGroup = group
            end
		end
		if self.db.profile.group then
			self:TriggerEvent("BigWigs_Message", string.format( L["groupwarning"], glareGroup, target), "Important")
			--self:TriggerEvent("BigWigs_SendTell", target, L["glarewarning"])
            
            -- dark glare near you?
            if (playerGroup == glareGroup or playerGroup == glareGroup - 1 or playerGroup == glareGroup + 1 or playerGroup == glareGroup - 7 or playerGroup == glareGroup + 7) then
                 self:Sound("RunAway")
            else
                self:Sound("Beware")
            end
            
            -- announce glare group
            if glareGroup == 1 then
                self:Sound("One")
            elseif glareGroup == 2 then
                self:Sound("Two")
            elseif glareGroup == 3 then
                self:Sound("Three")
            elseif glareGroup == 4 then
                self:Sound("Four")
            elseif glareGroup == 5 then
                self:Sound("Five")
            elseif glareGroup == 6 then
                self:Sound("Six")
            elseif glareGroup == 7 then
                self:Sound("Seven")
            elseif glareGroup == 8 then
                self:Sound("Eight")
            end
            
		end
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
            self:TriggerEvent("BigWigs_StartBar", self, L["barGiant"], timeP2ETentacle, "Interface\\Icons\\Ability_EyeOfTheOwl")
            self:ScheduleEvent("bwcthungianteye", "BigWigs_Message", timeP2ETentacle - 5, L["GiantEye"], "Urgent", true, "Alarm")
        end
    end
end

function BigWigsCThun:GCTentacleRape()
    self:CancelScheduledEvent("bwcthungctentacles")
    self:ScheduleEvent("bwcthungctentacles", self.GCTentacleRape, timeP2GiantClaw, self )
    if phase2started then
        if self.db.profile.giant then
            self:TriggerEvent("BigWigs_StartBar", self, L["barGiantC"], timeP2GiantClaw, "Interface\\Icons\\Spell_Nature_Earthquake")
        end
    end
end

function BigWigsCThun:TentacleRape()
    timeLastEyeTentaclesSpawn = GetTime()
	self:ScheduleEvent("bwcthuntentacles", self.TentacleRape, tentacletime, self )
	if self.db.profile.tentacle then
		self:TriggerEvent("BigWigs_StartBar", self, self.db.profile.rape and L["barTentacle"] or L["barNoRape"], tentacletime, "Interface\\Icons\\Spell_Nature_CallStorm")
		self:ScheduleEvent("bwcthuntentacle", "BigWigs_Message", tentacletime - 5, self.db.profile.rape and L["tentacle"] or L["norape"], "Urgent", true, "Alert")
	end
end

function BigWigsCThun:DarkGlare()
    if self.db.profile.glare then
        if firstGlare then
			self:ScheduleEvent("bwcthundarkglarestart", self.DarkGlare, timeP1GlareStart, self )
			
			self:TriggerEvent("BigWigs_StartBar", self, L["barGlare"], timeP1GlareStart, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
            firstGlare = nil
        else
			self:ScheduleEvent("bwcthundarkglare", self.DarkGlare, timeP1Glare, self )
			
			self:TriggerEvent("BigWigs_ShowWarningSign", "Interface\\Icons\\Ability_creature_cursed_04", 5)
			self:Message(L["glare"], "Urgent", true, "Beware")
			self:Bar(L["barGlareCasting"], timeP1GlareCasting, "Spell_Shadow_ShadowBolt")
		        
			self:ScheduleEvent("bwcthunglarebar", "BigWigs_StartBar", timeP1GlareCasting, self, L["barGlareEnds"], timeP1GlareDuration, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
			self:ScheduleEvent("bwcthunnextglare", "BigWigs_StartBar", timeP1GlareCasting + timeP1GlareDuration, self, L["barGlare"], timeP1Glare - timeP1GlareCasting - timeP1GlareDuration, "Interface\\Icons\\Spell_Shadow_ShadowBolt")
        end
    end
	
end

function BigWigsCThun:PlayerDamageEvents(msg)
    if not string.find(msg, "Eye of C'Thun") then
        local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"])
        if stype and dmg and school then
            if tonumber(dmg) > 100 then
                -- trigger weakend
                self:TriggerEvent("BigWigs_SendSync", "CThunWeakened1")
            elseif isWeakened and tonumber(dmg) == 1 then
                -- trigger weakened over
                self:DebugMessage("C'Thun weakened over trigger")
                self:Sync("CThunWeakenedOver")
            end
        end
    end
end

function BigWigsCThun:CheckEyeBeam(msg)
    if string.find(msg, L["eye_beam_trigger"]) then
        self:DebugMessage("Eye Beam trigger")
        self:Sync("GiantEyeEyeBeam")
    elseif string.find(msg, L["eye_beam_trigger_cthun"]) then
        self:DebugMessage("C'Thun Eye Beam trigger")
        self:Sync("CThunEyeBeam")
    end
end

function BigWigsCThun:CheckGiantClawSpawn(msg)
    self:DebugMessage("GiantClawSpawn: " .. msg)
    self:Sync("GiantClawSpawn")
end