------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.chromaggus
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"enrage", "frenzy", "breath", "breathcd", "vulnerability", "bosskill"}


-- locals
module.timer = {
	firstBreath = 30,
	secondBreath = 60,
	breathInterval = 60,
	breathCast = 2,
	frenzy = 8,
	nextFrenzy = 11,
	vulnerability = 45,
}
local timer = module.timer

module.icon = {
	unknown = "INV_Misc_QuestionMark",
	breath1 = "Spell_Arcane_PortalOrgrimmar",
	breath2 = "Spell_Nature_Acid_01",
	breath3 = "Spell_Fire_Fire",
	breath4 = "Spell_Shadow_ChillTouch",
	breath5 = "Spell_Frost_ChillingBlast",
	frenzy = "Ability_Druid_ChallangingRoar",
	tranquil = "Spell_Nature_Drowsy",
	vulnerability = "Spell_Shadow_BlackPlague",
}
local icon = module.icon

module.syncName = {
	breath = "ChromaggusBreath",
	frenzy = "ChromaggusFrenzyStart",
	frenzyOver = "ChromaggusFrenzyStop",
	engage = "ChromaggusEngage",
	enrage = "ChromaggusEnrage",
	vulnerabilityChanged = "ChromaggusVulnerabilityChanged",
}
local syncName = module.syncName

module.lastFrenzy = 0
local _, playerClass = UnitClass("player")
module.playerClass = playerClass
module.breathCache = {}  -- in case your raid wipes

module.vulnerability = nil
module.enrageAnnounced = nil
module.frenzied = nil
module.lastVuln = 0


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.breath and rest then
		self:Breath(rest)        
	elseif sync == syncName.frenzy then
		self:Frenzy()
	elseif sync == syncName.frenzyOver then
		self:FrenzyGone()
	elseif sync == syncName.enrage then
		self:Enrage()
	elseif sync == syncName.vulnerabilityChanged then
		self:VulnerabilityChanged()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Breath(number)
	if number and self.db.profile.breath then
		local spellName = L:HasTranslation("breath"..number) and L["breath"..number] or nil
		if not spellName then 
			return 
		end
		
        if table.getn(module.breathCache) < 2 then
			module.breathCache[table.getn(module.breathCache)+1] = spellName
        end
		
        local b = "breath"..number
		self:RemoveBar(L["icon"..number]) -- remove timer bar
		self:Bar(string.format( L["bar_breathCast"], spellName), timer.breathCast, L["icon"..number]) -- show cast bar
		self:Message(string.format(L["msg_breath"], spellName), "Important")
		
		self:DelayedMessage(timer.breathInterval - 5, string.format(L["msg_breathSoon"], spellName), "Important", nil, nil, true)
		self:DelayedBar(timer.breathCast, spellName, timer.breathInterval, L["icon"..number], true, L["breathcolor"..number]) -- delayed timer bar
        
        if self.db.profile.breathcd then
            self:DelayedSound(timer.breathInterval - 10, "Ten")
            self:DelayedSound(timer.breathInterval - 3, "Three")
            self:DelayedSound(timer.breathInterval - 2, "Two")
            self:DelayedSound(timer.breathInterval - 1, "One")
        end
	end
end

function module:Frenzy()
	if self.db.profile.frenzy and not module.frenzied then
		self:Message(L["msg_frenzy"], "Attention")
		self:Bar(L["bar_frenzy"], timer.frenzy, icon.frenzy, true, "red")
		
		if module.playerClass == "HUNTER" then
			self:WarningSign(icon.tranquil, timer.frenzy, true)
		end
	end
	module.frenzied = true
	module.lastFrenzy = GetTime()
end

function module:FrenzyGone()
	if self.db.profile.frenzy and module.frenzied then
		self:RemoveBar(L["bar_frenzy"])
        if module.lastFrenzy ~= 0 then
            local NextTime = (module.lastFrenzy + timer.nextFrenzy) - GetTime()
			self:Bar(L["bar_frenzyNext"], NextTime, icon.frenzy, true, "white")
		end
	end
    self:RemoveWarningSign(icon.tranquil, true)
	module.frenzied = nil
end

function module:Enrage()
	if not module.enrageAnnounced and self.db.profile.enrage then
		self:Message(L["msg_enrage"], "Important", true, "Beware")
	end
	
	module.enrageAnnounced = true
end

function module:VulnerabilityChanged()
	if module.vulnerability and self.db.profile.vulnerability then
		self:Message(L["msg_vulnerabilityChanged"], "Positive")
		self:RemoveBar(format(L["bar_vulnerability"], module.vulnerability))
		self:Bar(format(L["bar_vulnerability"], "???"), timer.vulnerability, icon.vulnerability)
	end
	
	module.lastVuln = GetTime()
	module.vulnerability = nil
end


------------------------------
--      Utility	Functions   --
------------------------------

function module:IdentifyVulnerability(school)
    if not self.db.profile.vulnerability or not type(school) == "string" then return end
    if (module.lastVuln + 5) > GetTime() then return end -- 5 seconds delay
    
    module.vulnerability = school
    self:Message(format(L["msg_vulnerability"], school), "Positive")
    if module.lastVuln then
        self:RemoveBar(format(L["bar_vulnerability"], "???"))
        self:Bar(format(L["bar_vulnerability"], school), (module.lastVuln + timer.vulnerability) - GetTime(), icon.vulnerability)
    end
end

function module:Engaged()
	if self.db.profile.breath then
		local firstBarName  = L["bar_breathFirst"]
		local firstBarMSG   = L["msg_breathUnknown"]
		local secondBarName = L["bar_breathSecond"]
		local secondBarMSG  = L["msg_breathUnknown"]
		if table.getn(module.breathCache) == 2 then
			-- if we have 2 breaths cached this session means we have wiped already and that after discovering the two breath types
			firstBarName  = string.format(L["bar_breathCast"], module.breathCache[1])
			firstBarMSG   = string.format(L["msg_breath"], module.breathCache[1])
			secondBarName = string.format(L["bar_breathCast"], module.breathCache[2])
			secondBarMSG  = string.format(L["msg_breath"], module.breathCache[2])
		elseif table.getn(module.breathCache) == 1 then
			-- we wiped before but know at least the first breath
			firstBarName  = string.format(L["bar_breathCast"], module.breathCache[1])
			firstBarMSG   = string.format(L["msg_breath"], module.breathCache[1])
		end
		self:DelayedMessage(timer.firstBreath - 5, firstBarMSG, "Attention", nil, nil, true)
		self:Bar(firstBarName, timer.firstBreath, icon.unknown, true, "cyan")
		self:DelayedMessage(timer.secondBreath - 5, secondBarMSG, "Attention", nil, nil, true)
		self:Bar(secondBarName, timer.secondBreath, icon.unknown, true, "cyan")
	end
	if self.db.profile.breathcd then
		self:DelayedSound(timer.firstBreath - 10, "Ten", "b1_10")
		self:DelayedSound(timer.firstBreath - 3, "Three", "b1_3")
		self:DelayedSound(timer.firstBreath - 2, "Two", "b1_2")
		self:DelayedSound(timer.firstBreath - 1, "One", "b1_1")
		
		self:DelayedSound(timer.secondBreath - 10, "Ten", "b2_10")
		self:DelayedSound(timer.secondBreath - 3, "Three", "b2_3")
		self:DelayedSound(timer.secondBreath - 2, "Two", "b2_2")
		self:DelayedSound(timer.secondBreath - 1, "One", "b2_1")
	end
	if self.db.profile.frenzy then
		self:Bar(L["bar_frenzyNext"], timer.nextFrenzy, icon.frenzy, true, "white") 
	end
	self:Bar(format(L["bar_vulnerability"], "???"), timer.vulnerability, icon.vulnerability)
    
    module.lastVuln = GetTime()
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Engaged()
	module:IdentifyVulnerability("Fire")
	module:VulnerabilityChanged()
	module:Enrage()
	module:Frenzy()
	module:FrenzyGone()
	module:Breath(1)

	module:BigWigs_RecvSync(syncName.breath, 1)
	module:BigWigs_RecvSync(syncName.frenzy)
	module:BigWigs_RecvSync(syncName.frenzyOver)
	module:BigWigs_RecvSync(syncName.enrage)
	module:BigWigs_RecvSync(syncName.vulnerabilityChanged)
end
