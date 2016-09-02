
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Kel'Thuzad", "Naxxramas")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Kelthuzad",

	KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Kel'Thuzad Chamber",

	phase_cmd = "phase",
	phase_name = "Phase Warnings",
	phase_desc = "Warn for phases.",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Alerts when people are mind controlled.",

	fissure_cmd = "fissure",
	fissure_name = "Shadow Fissure",
	fissure_desc = "Alerts about incoming Shadow Fissures.",

	frostblast_cmd = "frostblast",
	frostblast_name = "Frost Blast",
	frostblast_desc = "Alerts when people get Frost Blasted.",

	frostbolt_cmd = "frostbolt",
	frostbolt_name = "Frostbolt Alert",
	frostbolt_desc = "Alerts about incoming Frostbolts",

	frostboltbar_cmd = "frostboltbar",
	frostboltbar_name = "Frostbolt Bar",
	frostboltbar_desc = "Displays a bar for Frostbolt casts",

	detonate_cmd = "detonate",
	detonate_name = "Detonate Mana Warning",
	detonate_desc = "Warns about Detonate Mana soon.",

	detonateicon_cmd = "detonateicon",
	detonateicon_name = "Raid Icon on Detonate",
	detonateicon_desc = "Place a raid icon on people with Detonate Mana.",

	guardians_cmd = "guardians",
	guardians_name = "Guardian Spawns",
	guardians_desc = "Warn for incoming Icecrown Guardians in phase 3.",
	
	fbvolley_cmd = "fbvolley",
	fbvolley_name = "Possible volley",
	fbvolley_desc = "Timer for possible Frostbolt volley/multiple",
	
	addcount_cmd = "addcount",
	addcount_name = "P1 Add counter",
	addcount_desc = "Counts number of killed adds in P1",
	
	ktmreset_cmd = "ktmreset",
	ktmreset_name = "Do not reset KTM on MC",
	ktmreset_desc = "Resets KTM on MC when disabled, does nothing when enabled.",
	
	mc_trigger1 = "Your soul, is bound to me now!",
	mc_trigger2 = "There will be no escape!",
	mc_warning = "Mind Control!",
	mc_bar = "Possible Mind Control!",

	start_trigger = "Minions, servants, soldiers of the cold dark, obey the call of Kel'Thuzad!",   
	start_trigger1 = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!",
	start_warning = "Kel'Thuzad encounter started! ~5min till he is active!",
	start_bar = "Phase 1 Timer",
	attack_trigger1 = "Kel'Thuzad attacks",
	attack_trigger2 = "Kel'Thuzad misses",
	attack_trigger3 = "Kel'Thuzad hits",
	attack_trigger4 = "Kel'Thuzad crits",
	kick_trigger1 = "Kick hits Kel'Thuzad",
	kick_trigger2 = "Kick crits Kel'Thuzad",
	kick_trigger3 = "Kick was blocked by Kel'Thuzad",
	pummel_trigger1 = "Pummel hits Kel'Thuzad",
	pummel_trigger2 = "Pummel crits Kel'Thuzad",
	pummel_trigger3 = "Pummel was blocked by Kel'Thuzad",
	shieldbash_trigger1 = "Shield Bash hits Kel'Thuzad",
	shieldbash_trigger2 = "Shield Bash crits Kel'Thuzad",
	shieldbash_trigger3 = "Shield Bash was blocked by Kel'Thuzad",
	earthshock_trigger1 = "Earth Shock hits Kel'Thuzad",
	earthshock_trigger2 = "Earth Shock crits Kel'Thuzad",

	phase1_warn = "Phase 1 ends in 20 seconds!",

	phase2_trigger1 = "Pray for mercy!",
	phase2_trigger2 = "Scream your dying breath!",
	phase2_trigger3 = "The end is upon you!",
	phase2_warning = "Phase 2, Kel'Thuzad incoming!",
	phase2_bar = "Kel'Thuzad Active!",

	phase3_soon_warning = "Phase 3 soon!",
	phase3_trigger = "Master, I require aid!",
	phase3_warning = "Phase 3, Guardians in ~15sec!",

	guardians_trigger = "Very well. Warriors of the frozen wastes, rise up! I command you to fight, kill and die for your master! Let none survive!",
	guardians_warning = "Guardians incoming in ~10sec!",
	guardians_bar = "Guardians incoming!",

--	fissure_trigger = "cast Shadow Fissure.",
--	fissure_warning = "Shadow Fissure!",

	frostbolt_trigger = "Kel'Thuzad begins to cast Frostbolt.",
	frostbolt_warning = "Frostbolt! Interrupt!",
	frostbolt_bar = "Frostbolt",

	
	frostbolt_volley = "Possible volley",
	frostbolt_volley_trigger = "afflicted by Frostbolt",
	
	add_dead_trigger = "(.*) dies",
	add_bar = "%d/14 %s",
	
	frostblast_bar = "Possible Frost Blast",
	frostblast_trigger1 = "I will freeze the blood in your veins!",  
	frostblast_warning = "Frost Blast!",
	frostblast_soon_message = "Possible Frost Blast in ~5sec!",

	phase2_mcfrostblast_warning = "Possible Frost Blast and Mind Control in ~5sec!",
	phase2_detonate_warning = "Detonate Mana in ~5sec!",
	mcfrostblast_bar = "First Frost Blast and MC",

	detonate_trigger = "^([^%s]+) ([^%s]+) afflicted by Detonate Mana",
	detonate_bar = "Detonate Mana - %s",
	detonate_possible_bar = "Detonate Mana",
	detonate_warning = "%s has Detonate Mana!",
	
	you = "You",
	are = "are",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"frostbolt", "frostboltbar", -1, "frostblast", "fissure", "mc", "ktmreset", -1, "fbvolley", -1, "detonate", "detonateicon", -1 ,"guardians", -1, "addcount", "phase", "bosskill"}

-- Proximity Plugin
-- module.proximityCheck = function(unit) return CheckInteractDistance(unit, 2) end
-- module.proximitySilent = false


-- locals
local timer = {
	charge = 10,
	teleport = 30,
}
local icon = {
	charge = "Spell_Frost_FrostShock",
	teleport = "Spell_Arcane_Blink",
}
local syncName = {
	teleport = "TwinsTeleport",
	berserk = "TestbossBerserk"
}

local timeLastFrostboltVolley = 0    -- saves time of first frostbolt 
local numFrostboltVolleyHits = 0	-- counts the number of people hit by frostbolt
local numAbominations = 0	-- counter for Unstoppable Abomination's
local numWeavers = 0 	-- counter for Soul Weaver's
local pstart = 0    -- time of p1 start, used for tracking add count


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["start_trigger"])
module:RegisterYellEngage(L["start_trigger1"])

-- Big evul hack to enable the module when entering Kel'Thuzads chamber.
function module:OnRegister()
	self:RegisterEvent("MINIMAP_ZONE_CHANGED")
end

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_PARTY_MISSES", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_MISSES", "Event")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Affliction")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Affliction")

	self:TriggerEvent("BigWigs_ThrottleSync", "KelDetonate", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFrostBlast", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFrostbolt", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelFrostboltStop", 2)
--	self:TriggerEvent("BigWigs_ThrottleSync", "KelFizzure", 2)					-- this isnt used anyway?
	self:TriggerEvent("BigWigs_ThrottleSync", "KelAddDiesAbom", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelAddDiesSoul", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelDead", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelPhase2", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "KelPhase3", 5)
	
	
	--self:ThrottleSync(10, syncName.berserk)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.warnedAboutPhase3Soon = nil
	frostbolttime = 0
end

-- called after boss is engaged
function module:OnEngage()
	self:Message(L["start_warning"], "Attention")
	self:Bar(L["start_bar"], 320 )
	self:DelayedMessage(300, L["phase1_warn"], "Important")
	
	if self.db.profile.addcount then
	pstart=GetTime() 	-- start of p1, used for tracking add counts
	numAbominations=0
	numWeavers=0
	self:Bar(string.format(L["add_bar"], numAbominations, "Unstoppable Abomination"),320)
	self:Bar(string.format(L["add_bar"], numWeavers, "Soul Weaver"),320)
	end
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:MINIMAP_ZONE_CHANGED(msg)
	if GetMinimapZoneText() ~= L["KELTHUZADCHAMBERLOCALIZEDLOLHAX"] or self.core:IsModuleActive(module.translatedName) then return end
	-- Activate the Kel'Thuzad mod!
	self.core:EnableModule(module.translatedName)
end

-- check for phase 3
function module:UNIT_HEALTH(msg)
	if self.db.profile.phase then 
		if UnitName(msg) == self.translatedName then
			local health = UnitHealth(msg)
			if health > 35 and health <= 40 and not self.warnedAboutPhase3Soon then
				self:Message(L["phase3_soon_warning"], "Attention")
				self.warnedAboutPhase3Soon = true
			elseif health > 40 and self.warnedAboutPhase3Soon then
				self.warnedAboutPhase3Soon = nil
			end
		end
	end
end

function module:CHAT_MSG_MONSTER_YELL(msg)
	if ((msg == L["phase2_trigger1"]) or (msg == L["phase2_trigger2"]) or (msg == L["phase2_trigger3"])) then
		self:Sync("KelPhase2")
	elseif msg == L["phase3_trigger"] then
		self:Sync("KelPhase3")
	elseif msg == L["mc_trigger1"] or msg == L["mc_trigger2"] then
		self:Sync("KelMindControl")
	elseif msg == L["guardians_trigger"] then
		self:Sync("KelGuardians")
	elseif msg == L["frostblast_trigger1"] then
		self:Sync("KelFrostBlast")
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
	if string.find(msg, L["frostbolt_trigger"]) then
		self:Sync("KelFrostbolt")
	end
end

--[[ function module:CHAT_MSG_SPELL_SELF_DAMAGE( msg )
	if string.find(msg, L["fissure_trigger"]) then
		self:Sync("KelFizzure")
	end
end ]]-- who needs this

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	local _,_, mob = string.find(msg, L["add_dead_trigger"])
	if self.db.profile.addcount and (mob == "Unstoppable Abomination") then
		self:Sync("KelAddDiesAbom" .. " " .. mob)
	elseif self.db.profile.addcount and (mob == "Soul Weaver") then
		self:Sync("KelAddDiesSoul" .. " " .. mob)
	elseif self.db.profile.bosskill and (mob == "Kel'Thuzad") then 
		self:SendBossDeathSync()
	end
end

--[[function module:Volley()
	self:Bar(L["frostbolt_volley"], 15, "Spell_Frost_FrostWard")
end]]
function module:Affliction(msg)
	if string.find(msg, L["detonate_trigger"]) then
		local _,_, dplayer, dtype = string.find( msg, L["detonate_trigger"])
		if dplayer and dtype then
			if dplayer == L["you"] and dtype == L["are"] then
				dplayer = UnitName("player")
			end
			self:Sync("KelDetonate" .. " ".. dplayer)
		end
	end
	
	if self.db.profile.fbvolley and string.find(msg, L["frostbolt_volley_trigger"]) then
		local now = GetTime()
		
		-- only warn if there are more than 3 players hit by frostbolt volley within 4s
		if now - timeLastFrostboltVolley > 4 then
			timeLastFrostboltVolley = now
			numFrostboltVolleyHits = 0
		else 
			numFrostboltVolleyHits = numFrostboltVolleyHits + 1
		end
		if numFrostboltVolleyHits == 3 then 
			
			self:Bar(L["frostbolt_volley"], 15, "Spell_Frost_FrostWard")
			
			--[[self:CancelScheduledEvent("bwfbvolley30")
			self:CancelScheduledEvent("bwfbvolley45")
			self:CancelScheduledEvent("bwfbvolley60") 
			self:ScheduleEvent("bwfbvolley30", self.Volley, 15, self)
			self:ScheduleEvent("bwfbvolley45", self.Volley, 30, self)
			self:ScheduleEvent("bwfbvolley60", self.Volley, 45, self) ]] -- why 3 times?
			
			self:CancelDelayedBar(L["frostbolt_volley"])
			self:DelayedBar(15, L["frostbolt_volley"], 15, "Spell_Frost_FrostWard")
		end
	end
end

function module:Event(msg)
	if GetTime() < frostbolttime + 2 then
		if string.find(msg, L["attack_trigger1"]) or string.find(msg, L["attack_trigger2"]) or string.find(msg, L["attack_trigger3"]) or string.find(msg, L["attack_trigger4"]) then
			self:RemoveBar(L["frostbolt_bar"])
			frostbolttime = 0
			self:Sync("KelFrostboltStop")
		elseif string.find(msg, L["kick_trigger1"]) or string.find(msg, L["kick_trigger2"]) or string.find(msg, L["kick_trigger3"]) or string.find(msg, L["pummel_trigger1"]) or string.find(msg, L["pummel_trigger2"]) or string.find(msg, L["pummel_trigger3"]) or string.find(msg, L["shieldbash_trigger1"]) or string.find(msg, L["shieldbash_trigger2"]) or string.find(msg, L["shieldbash_trigger3"]) or string.find(msg, L["earthshock_trigger1"]) or string.find(msg, L["earthshock_trigger2"]) then
			self:RemoveBar(L["frostbolt_bar"])
			frostbolttime = 0
			self:Sync("KelFrostboltStop")
		end
	else
		frostbolttime = 0
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == "KelPhase2" then
		self:Phase2()
	elseif sync == "KelPhase3" then
		self:Phase3()
	elseif sync == "KelGuardians" then
		self:Guardians()
	elseif sync == "KelMindControl" then
		self:MindControl()
	elseif sync == "KelFrostBlast" then
		self:FrostBlast()
	elseif sync == "KelDetonate" and rest then
		self:Detonate()
	elseif sync == "KelFrostbolt" then       -- changed from only frostbolt (thats only alert, if someone still wants to see the bar, it wouldnt work then)
		self:Frostbolt()
	elseif sync == "KelFrostboltStop" then
		self:FrostboltOver()
	elseif sync == "KelAddDiesAbom" and rest then
		self:AbominationDies(rest)
	elseif sync == "KelAddDiesSoul" and rest then
		
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

function module:Phase2()
	self:Bar(L["phase2_bar"], 15)
	self:Bar(L["detonate_possible_bar"], 35)
	self:Bar(L["mcfrostblast_bar"], 45)
	self:DelayedMessage(15, L["phase2_warning"], "Important")
	self:DelayedMessage(30, L["phase2_detonate_warning"], "Important")
	self:DelayedMessage(40, L["phase2_mcfrostblast_warning"], "Important")
	
	if self.db.profile.fbvolley then
		self:Bar(L["frostbolt_volley"], 30, "Spell_Frost_FrostWard")
		self:DelayedMessage(self.Volley, 45, self)
		self:DelayedMessage(self.Volley, 60, self)
		self:DelayedMessage(self.Volley, 75, self)
	end
	
	self:KTM_Reset()
	-- proximity silent
end

function module:Phase3()
	if self.db.profile.phase then
		self:Message(L["phase3_warning"], "Attention", nil, "Beware")
	end
end

function module:MindControl()
	self:Message(L["mc_warning"], "Urgent")
	self:Bar(L["mc_bar"], 60, "Inv_Belt_18")
	
	self:KTM_Reset()
end

function module:Guardians()
	if self.db.profile.guardians then
		self:Message(L["guardians_warning"], "Important")
		self:Bar(L["guardians_bar"], 16)
	end
end

function module:FrostBlast()
	self:Message(L["frostblast_warning"], "Attention")
	self:ScheduleEvent("bwktfbwarn", "BigWigs_Message", 25, L["frostblast_soon_message"])
	self:Bar(L["frostblast_bar"], 30, "Spell_Frost_FreezingBreath")
end

function module:Detonate(name)
	if name and self.db.profile.detonate then
		self:Message(string.format(L["detonate_warning"], name), "Attention")
		if self.db.profile.detonateicon then 
			self:Icon(name) 
		end
		self:Bar(string.format(L["detonate_bar"], name), 5, "Spell_Nature_WispSplode")
		self:Bar(L["detonate_possible_bar"], 20, "Spell_Nature_WispSplode")
	end
end

function module:Frostbolt()
	if self.db.profile.frostbolt or self.db.profile.frostboltbar then
		frostbolttime = GetTime()
		if self.db.profile.frostbolt then
			self:Message(L["frostbolt_warning"], "Personal")
		end
		if self.db.profile.frostboltbar then
			self:Bar(L["frostbolt_bar"], 2, "Spell_Frost_FrostBolt02", true, "blue")
		end
	end
end

function module:FrostboltOver()
	if self.db.profile.frostbolt then
		self:RemoveBar(L["frostbolt_bar"])
		frostbolttime = 0
	end
end

function module:AbominationDies(name)
	if name and self.db.profile.addcount then
		self:RemoveBar(string.format(L["add_bar"], numAbominations, name))
		numAbominations=numAbominations+1
		if (numAbominations<14) then 
			self:Bar(string.format(L["add_bar"], numAbominations, name),(pstart+320-GetTime())) 
		end	
	end
end

function module:WeaverDies(name)
	if name and self.db.profile.addcount then
		self:RemoveBar(string.format(L["add_bar"], numWeavers, name))
		numWeavers=numWeavers+1
		if (numWeavers<14) then 
			self:Bar(string.format(L["add_bar"], numWeavers, name),(pstart+320-GetTime())) 
		end
	end
end