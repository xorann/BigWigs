------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Chromaggus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local lastFrenzy = 0
local _, playerClass = UnitClass("player")
local breathCache = {}  -- in case your raid wipes

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Chromaggus",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn before the Enrage phase at 20%.",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy",
	frenzy_desc = "Warn for Frenzy.",

	breath_cmd = "breath",
	breath_name = "Breaths",
	breath_desc = "Warn for Breaths.",

	vulnerability_cmd = "vulnerability",
	vulnerability_name = "Vulnerability",
	vulnerability_desc = "Warn for Vulnerability changes.",

	breath_trigger = "Chromaggus begins to cast (.+)\.",
	vulnerability_direct_test = "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)",
	vulnerability_dots_test = "^Chromaggus suffers ([%d]+) ([%w]+) damage from [%w]+[%s's]* ([%w%s:]+)%.[%s%(]*([%d]*)",
	frenzy_trigger = "goes into a killing frenzy",
	frenzyfade_trigger = "Frenzy fades from Chromaggus\.",
	vulnerability_trigger = "flinches as its skin shimmers.",

	hit = "hits",
	crit = "crits",

	firstbreaths_warning = "Breath in 5 seconds!",
	breath_warning = "%s in 5 seconds!",
	breath_message = "%s is casting!",
	vulnerability_message = "Vulnerability: %s!",
	vulnerability_warning = "Spell vulnerability changed!",
	frenzy_message = "Frenzy! TRANQ NOW!",
	enrage_warning = "Enrage soon!",

	breath1 = "Time Lapse",
	breath2 = "Corrosive Acid",
	breath3 = "Ignite Flesh",
	breath4 = "Incinerate",
	breath5 = "Frost Burn",
	
	breathcolor1 = "black",
	breathcolor2 = "green",
	breathcolor3 = "orange",
	breathcolor4 = "red",
	breathcolor5 = "blue",

	icon1 = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 = "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 = "Interface\\Icons\\Spell_Fire_Fire",
	icon4 = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 = "Interface\\Icons\\Spell_Frost_ChillingBlast",

	castingbar = "Cast %s",
	frenzy_bar = "Frenzy",
    frenzy_Nextbar = "Next Frenzy",
	first_bar = "First Breath",
	second_bar = "Second Breath",
    vuln_bar = "%s Vulnerability",
	
	fire = "Fire",
	frost = "Frost",
	shadow = "Shadow",
	nature = "Nature",
	arcane = "Arcane",
	
	curseofdoom = "Curse of Doom",
	ignite = "Ignite",
	starfire = "Starfire",
	thunderfury = "Thunderfury",
} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Chromaggus w\195\188tend wird (ab 20%).",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Chromaggus in Raserei ger\195\164t.",

	breath_name = "Atem",
	breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt.",

	vulnerability_name = "Zauber-Verwundbarkeiten",
	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich \195\164ndert.",

	breath_trigger = "^Chromaggus beginnt (.+) zu wirken\.",
	vulnerability_direct_test = "^(.+) trifft Chromaggus(.+) ([%d]+) ([%w]+)%.[%s%(]*([%d]*)",
	vulnerability_dots_test = "^Chromaggus erleidet ([%d]+) ([%w]+)schaden[%svon]*[%s%w]* %(durch ([%w%s:]+)%)%.[%s%(]*([%d]*)",
	frenzy_trigger = "goes into a killing frenzy",
	frenzyfade_trigger = "Raserei schwindet von Chromaggus\.",
	vulnerability_trigger = "flinches as its skin shimmers.",

	hit = "trifft",
	crit = "kritisch",

	firstbreaths_warning = "Atem in 5 Sekunden!",
	breath_warning = "%s in 5 Sekunden!",
	breath_message = "Chromaggus wirkt: %s Atem!",
	vulnerability_message = "Zauber-Verwundbarkeit: %s",
	vulnerability_warning = "Zauber-Verwundbarkeit ge\195\164ndert!",
	frenzy_message = "Raserei - Einlullender Schuss!",
	enrage_warning = "Wutanfall steht kurz bevor!",

	breath1 = "Zeitraffer",
	breath2 = "\195\132tzende S\195\164ure",
	breath3 = "Fleisch entz\195\188nden",
	breath4 = "Verbrennen",
	breath5 = "Frostbeulen",

	breathcolor1 = "black",
	breathcolor2 = "green",
	breathcolor3 = "orange",
	breathcolor4 = "red",
	breathcolor5 = "blue",

	icon1 = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 = "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 = "Interface\\Icons\\Spell_Fire_Fire",
	icon4 = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 = "Interface\\Icons\\Spell_Frost_ChillingBlast",

	castingbar = "Wirkt %s",
	frenzy_bar = "Raserei",
    frenzy_Nextbar = "Nächste Raserei",
	first_bar = "Erster Atem",
	second_bar = "Zweite Atem",
    vuln_bar = "%s Verwundbarkeit",
	
	fire = "Feuer",
	frost = "Frost",
	shadow = "Schatten",
	nature = "Natur",
	arcane = "Arkan",
	
	curseofdoom = "Fluch der Verdammnis",
	ignite = "Entz\195\188nden",
	starfire = "Sternenfeuer",
	thunderfury = "Zorn der Winde",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsChromaggus = BigWigs:NewModule(boss)
BigWigsChromaggus.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsChromaggus.enabletrigger = boss
BigWigsChromaggus.bossSync = "Chromaggus"
BigWigsChromaggus.toggleoptions = { "enrage", "frenzy", "breath", "vulnerability", "bosskill"}
BigWigsChromaggus.revision = tonumber(string.sub("$Revision: 11211 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsChromaggus:OnEnable()
	self.vulnerability = nil
	self.twenty = nil
	self.started = nil
	self.frenzied = nil
        self.lastVuln = 0

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusEngage", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusBreath", 20)
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusFrenzyStart", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusFrenzyStop", 5)
end

function BigWigsChromaggus:UNIT_HEALTH( msg )
	if self.db.profile.enrage and UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 431240 and health <= 495926 and not self.twenty then
			self:TriggerEvent("BigWigs_Message", L["enrage_warning"], "Important")
			self.twenty = true
		elseif health > 862480 and self.twenty then
			self.twenty = nil
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	local _,_, spellName = string.find(msg, L["breath_trigger"])
	if spellName then
		local breath = L:HasReverseTranslation(spellName) and L:GetReverseTranslation(spellName) or nil
		if not breath then return end
		breath = string.sub(breath, -1)
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusBreath "..breath)
	end
end

function BigWigsChromaggus:BigWigs_RecvSync(sync, rest, nick)
	if not self.started and ((sync == "BossEngaged" and rest == "Chromaggus") or (sync == "ChromaggusEngage") ) then
		self:StartFight()
        if sync ~= "ChromaggusEngage" then self:TriggerEvent("BigWigs_SendSync", "ChromaggusEngage") end
        
		if self.db.profile.breath then
            local firstBarName  = L["first_bar"]
            local firstBarMSG   = L["firstbreaths_warning"]
            local secondBarName = L["second_bar"]
            local secondBarMSG  = L["firstbreaths_warning"]
            if table.getn(breathCache) == 2 then
                -- if we have 2 breaths cached this session means we have wiped already and that after discovering the two breath types
                firstBarName  = string.format(L["castingbar"], breathCache[1])
                firstBarMSG   = string.format(L["breath_message"], breathCache[1])
                secondBarName = string.format(L["castingbar"], breathCache[2])
                secondBarMSG  = string.format(L["breath_message"], breathCache[2])
            elseif table.getn(breathCache) == 1 then
                -- we wiped before but know at least the first breath
                firstBarName  = string.format(L["castingbar"], breathCache[1])
                firstBarMSG   = string.format(L["breath_message"], breathCache[1])
            end
			self:ScheduleEvent("BigWigs_Message", 23.5, firstBarMSG, "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, firstBarName, 28.5, "Interface\\Icons\\INV_Misc_QuestionMark", true, "cyan")
			self:ScheduleEvent("BigWigs_Message", 53.5, secondBarMSG, "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, secondBarName, 58.5, "Interface\\Icons\\INV_Misc_QuestionMark", true, "cyan")
		end
        if self.db.profile.frenzy then
            self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_Nextbar"], 13, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "white") 
        end
        self:TriggerEvent("BigWigs_StartBar", self, format(L["vuln_bar"], "???"), 45, "Interface\\Icons\\Spell_Shadow_BlackPlague")
	elseif sync == "ChromaggusBreath" and self.db.profile.breath then
		local spellName = L:HasTranslation("breath"..rest) and L["breath"..rest] or nil
		if not spellName then return end
        if table.getn(breathCache) < 2 then
            breathCache[table.getn(breathCache)+1] = spellName
        end
		self:TriggerEvent("BigWigs_StartBar", self, string.format( L["castingbar"], spellName), 2, L["icon"..rest])
		self:TriggerEvent("BigWigs_Message", string.format(L["breath_message"], spellName), "Important")
		self:ScheduleEvent("bwchromaggusbreath"..spellName, "BigWigs_Message", 55, string.format(L["breath_warning"], spellName), "Important")
		self:ScheduleEvent("BigWigs_StartBar", 2, self, spellName, 58, L["icon"..rest], true, L["breathcolor"..rest])
	elseif sync == "ChromaggusFrenzyStart" then
		if self.db.profile.frenzy and not self.frenzied then
			self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_bar"], 8, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "red")
		end
        if playerClass == "HUNTER" then
            self:TriggerEvent("BigWigs_ShowIcon", "Interface\\Icons\\Spell_Nature_Drowsy", 8, true)
        end
		self.frenzied = true
        lastFrenzy = GetTime()
	elseif sync == "ChromaggusFrenzyStop" then
		if self.db.profile.frenzy and self.frenzied then
			self:TriggerEvent("BigWigs_StopBar", self, L["frenzy_bar"])
            if lastFrenzy ~= 0 then
                local NextTime = (lastFrenzy + 15) - GetTime()
                self:TriggerEvent("BigWigs_StartBar", self, L["frenzy_Nextbar"], NextTime, "Interface\\Icons\\Ability_Druid_ChallangingRoar", true, "white")
            end
		end
        self:TriggerEvent("BigWigs_HideIcon", "Interface\\Icons\\Spell_Nature_Drowsy")
		self.frenzied = nil
	end
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["frenzy_trigger"]) and arg2 == boss then
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusFrenzyStart")
	elseif string.find(msg, L["vulnerability_trigger"]) then
		if self.db.profile.vulnerability then
			self:TriggerEvent("BigWigs_Message", L["vulnerability_warning"], "Positive")
            if self.vulnerability then
                self:TriggerEvent("BigWigs_StopBar", self, format(L["vuln_bar"], self.vulnerability))
            end
            self:TriggerEvent("BigWigs_StartBar", self, format(L["vuln_bar"], "???"), 45, "Interface\\Icons\\Spell_Shadow_BlackPlague")
		end
        self.lastVuln = GetTime()
		self.vulnerability = nil
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["frenzyfade_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusFrenzyStop")
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.db.profile.vulnerability then return end
	if not self.vulnerability then
		local _, _, dmg, school, userspell, partial = string.find(msg, L["vulnerability_dots_test"])
		if dmg and school and userspell then
			if school == L["arcane"] then
				if partial and partial ~= "" then
					if tonumber(dmg)+tonumber(partial) >= 250 then
						self:IdentifyVulnerability(school)
					end
				else
					if tonumber(dmg) >= 250 then
						self:IdentifyVulnerability(school)
					end
				end
			elseif school == L["fire"] and not string.find(userspell, L["ignite"]) then
				if partial and partial ~= "" then
					if tonumber(dmg)+tonumber(partial) >= 400 then
						self:IdentifyVulnerability(school)
					end
				else
					if tonumber(dmg) >= 400 then
						self:IdentifyVulnerability(school)
					end
				end
			elseif school == L["nature"] then
				if partial and partial ~= "" then
					if tonumber(dmg)+tonumber(partial) >= 300 then
						self:IdentifyVulnerability(school)
					end
				else
					if tonumber(dmg) >= 300 then
						self:IdentifyVulnerability(school)
					end
				end
			elseif school == L["shadow"] then
				if string.find(userspell, L["curseofdoom"]) then
					if partial and partial ~= "" then
						if tonumber(dmg)+tonumber(partial) >= 3000 then
							self:IdentifyVulnerability(school)
						end
					else
						if tonumber(dmg) >= 3000 then
							self:IdentifyVulnerability(school)
						end
					end
				else
					if partial and partial ~= "" then
						if tonumber(dmg)+tonumber(partial) >= 500 then
							self:IdentifyVulnerability(school)
						end
					else
						if tonumber(dmg) >= 500 then
							self:IdentifyVulnerability(school)
						end
					end
				end
			end
		end
	end
end

function BigWigsChromaggus:PlayerDamageEvents(msg)
	if not self.db.profile.vulnerability then return end
	if not self.vulnerability then
		local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["vulnerability_direct_test"])
		if GetLocale() == "deDE" then
			if string.find(stype, L["crit"]) then stype = L["crit"] else stype = L["hit"] end
			school = string.gsub(school, "schaden", "")
		end
		if stype and dmg and school then
			if school == L["arcane"] then
				if string.find(userspell, L["starfire"]) then
					if partial and partial ~= "" then
						if (tonumber(dmg)+tonumber(partial) >= 800 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					else
						if (tonumber(dmg) >= 800 and stype == L["hit"]) or (tonumber(dmg) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					end
				else
					if partial and partial ~= "" then
						if (tonumber(dmg)+tonumber(partial) >= 600 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					else
						if (tonumber(dmg) >= 600 and stype == L["hit"]) or (tonumber(dmg) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					end
				end
			elseif school == L["fire"] then
				if partial and partial ~= "" then
					if (tonumber(dmg)+tonumber(partial) >= 1300 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 2600 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				else
					if (tonumber(dmg) >= 1300 and stype == L["hit"]) or (tonumber(dmg) >= 2600 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				end
			elseif school == L["frost"] then
				if partial and partial ~= "" then
					if (tonumber(dmg)+tonumber(partial) >= 800 and stype == L["hit"])	or (tonumber(dmg)+tonumber(partial) >= 1600 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				else
					if (tonumber(dmg) >= 800 and stype == L["hit"]) or (tonumber(dmg) >= 1600 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				end
			elseif school == L["nature"] then
				if string.find(userspell, L["thunderfury"]) then
					if partial and partial ~= "" then
						if (tonumber(dmg)+tonumber(partial) >= 800 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					else
						if (tonumber(dmg) >= 800 and stype == L["hit"]) or (tonumber(dmg) >= 1200 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					end
				else
					if partial and partial ~= "" then
						if (tonumber(dmg)+tonumber(partial) >= 900 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 1800 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					else
						if (tonumber(dmg) >= 900 and stype == L["hit"]) or (tonumber(dmg)>= 1800 and stype == L["crit"]) then
							self:IdentifyVulnerability(school)
						end
					end
				end
			elseif school == L["shadow"] then
				if partial and partial ~= "" then
					if (tonumber(dmg)+tonumber(partial) >= 1700 and stype == L["hit"]) or (tonumber(dmg)+tonumber(partial) >= 3400 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				else
					if (tonumber(dmg) >= 1700 and stype == L["hit"]) or (tonumber(dmg) >= 3400 and stype == L["crit"]) then
						self:IdentifyVulnerability(school)
					end
				end
			end
		end
	end
 end

function BigWigsChromaggus:IdentifyVulnerability(school)
    if not self.db.profile.vulnerability or not type(school) == "string" then return end
    if (self.lastVuln + 5) > GetTime() then return end -- 5 seconds delay
    
    self.vulnerability = school
    self:TriggerEvent("BigWigs_Message", format(L["vulnerability_message"], school), "Positive")
    if self.lastVuln then
        self:TriggerEvent("BigWigs_StopBar", self, format(L["vuln_bar"], "???"))
        self:TriggerEvent("BigWigs_StartBar", self, format(L["vuln_bar"], school), (self.lastVuln + 45) - GetTime(), "Interface\\Icons\\Spell_Shadow_BlackPlague")
    end
end
