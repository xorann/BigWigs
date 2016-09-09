
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Nefarian", "Blackwing Lair")
local victor = AceLibrary("Babble-Boss-2.2")["Lord Victor Nefarius"]

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "Let the games begin!",
	landing_trigger = "Enough! Now you",
    landingNOW_trigger = "courage begins to wane",
	zerg_trigger = "Impossible! Rise my",
	fear_trigger = "Nefarian begins to cast Bellowing Roar",
	fear_over_trigger = "Bellowing Roar",
	shadowflame_trigger = "Nefarian begins to cast Shadow Flame",

	triggerfear = "by Panic.",
	land = "Estimated Landing",
	Mob_Spawn = "Mob Spawn",
	fear_warn = "Fear NOW!",

	triggershamans	= "Shamans, show me",
	triggerdruid	= "Druids and your silly",
	triggerwarlock	= "Warlocks, you shouldn't be playing",
	triggerpriest	= "Priests! If you're going to keep",
	triggerhunter	= "Hunters and your annoying",
	triggerwarrior	= "Warriors, I know you can hit harder",
	triggerrogue	= "Rogues%? Stop hiding",
	triggerpaladin	= "Paladins",
	triggermage		= "Mages too%?",

	landing_soon_warning = "Nefarian landing in 30 seconds!",
	landing_very_soon = "Nefarian landing in 10 seconds!",
	landing_warning = "Nefarian is landing!",
	zerg_warning = "Zerg incoming!",
	fear_warning = "Fear in 2 sec!",
	fear_soon_warning = "Possible fear in ~5 sec",
	shadowflame_warning = "Shadow Flame incoming!",
	shadowflame_bar = "Shadow Flame",
	classcall_warning = "Class call incoming!",

	warnshaman	= "Shamans - Totems spawned!",
	warndruid	= "Druids - Stuck in cat form!",
	warnwarlock	= "Warlocks - Incoming Infernals!",
	warnpriest	= "Priests - Heals hurt!",
	warnhunter	= "Hunters - Bows/Guns broken!",
	warnwarrior	= "Warriors - Stuck in berserking stance!",
	warnrogue	= "Rogues - Ported and rooted!",
	warnpaladin	= "Paladins - Blessing of Protection!",
	warnmage	= "Mages - Incoming polymorphs!",

	classcall_bar = "Class call",
	fear_bar = "Possible fear",

	cmd = "Nefarian",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	fear_cmd = "fear",
	fear_name = "Warn for Fear",
	fear_desc = "Warn when Nefarian casts AoE Fear",

	classcall_cmd = "classcall",
	classcall_name = "Class Call alert",
	classcall_desc = "Warn for Class Calls",

	otherwarn_cmd = "otherwarn",
	otherwarn_name = "Other alerts",
	otherwarn_desc = "Landing and Zerg warnings",
            
    mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",
    mcwarn = "Casting Mind Control!",
	mcplayer = "^([^%s]+) ([^%s]+) afflicted by Shadow Command.$",
	mcplayerwarn = " is mindcontrolled!",
	mcyou = "You",
	mcare = "are",
} end)

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20003 -- To be overridden by the module!
module.enabletrigger = {boss, victor} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"shadowflame", "fear", "classcall", "otherwarn", "bosskill"}


-- locals
local timer = {
	mobspawn = 10,
	classcall = 30,
	mc = 15,
	shadowflame = 19,
	shadowflameCast = 2,
	fear = 28.5,
	fearCast = 1.5,
	landing = 15,
	firstClasscall = 37,
	firstFear = 30,
}
local icon = {
	mobspawn = "Spell_Holy_PrayerOfHealing",
	classcall = "Spell_Shadow_Charm",
	mc = "Spell_Shadow_Charm",
	fear = "Spell_Shadow_Possession",
	shadowflame = "Spell_Fire_Incinerate",
	landing = "INV_Misc_Head_Dragon_Black",
}
local syncName = {
	shadowflame = "NefarianShadowflame",
	fear = "NefarianFear",
	landing = "NefarianLandingNOW",
}


local warnpairs = nil


------------------------------
--      Initialization      --
------------------------------

module:RegisterYellEngage(L["engage_trigger"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
    self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
    self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
    
	if not warnpairs then warnpairs = {
		[L["triggershamans"]] = {L["warnshaman"], true},
		[L["triggerdruid"]] = {L["warndruid"], true},
		[L["triggerwarlock"]] = {L["warnwarlock"], true},
		[L["triggerpriest"]] = {L["warnpriest"], true},
		[L["triggerhunter"]] = {L["warnhunter"], true},
		[L["triggerwarrior"]] = {L["warnwarrior"], true},
		[L["triggerrogue"]] = {L["warnrogue"], true},
		[L["triggerpaladin"]] = {L["warnpaladin"], true},
		[L["triggermage"]] = {L["warnmage"], true},
		[L["landing_trigger"]] = {L["landing_warning"]},
		[L["zerg_trigger"]] = {L["zerg_warning"]},
	} end
	
	self:ThrottleSync(10, syncName.shadowflame)
	self:ThrottleSync(15, syncName.fear)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	self.started = nil
	self.phase2 = nil
end

-- called after boss is engaged
function module:OnEngage()
	self:Message(L["landing_soon_warning"], "Important", true, "Long")
	self:Bar(L["Mob_Spawn"], timer.mobspawn, icon.mobspawn)
	
	--self:Bar(L["land"], 159, "INV_Misc_Head_Dragon_Black")
	--self:DelayedMessage(105, L["landing_soon_warning"], "Important", true, "Alarm")
	--self:DelayedMessage(125, L["landing_very_soon"], "Important", true, "Long")
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:CHAT_MSG_MONSTER_YELL(msg)
    if string.find(msg, L["landingNOW_trigger"]) then
        self:Sync(syncName.landing)
    end
    
	for i,v in pairs(warnpairs) do
		if string.find(msg, i) then
			if v[2] then
				if self.db.profile.classcall then
					self:Message(v[1], "Core")
					self:DelayedMessage(timer.classcall - 3, L["classcall_warning"], "Important")
					self:Bar(v[1], timer.classcall, icon.classcall)
					self:DelayedSound(timer.classcall - 3, "Three")
					self:DelayedSound(timer.classcall - 2, "Two")
					self:DelayedSound(timer.classcall - 1, "One")
                    
                    local localizedClass, englishClass = UnitClass("player");
                    if string.find(msg, localizedClass) then
						self:Sound("Beware")
						self:WarningSign(icon.classcall, 3)
                    end
				end
			else
				if self.db.profile.otherwarn and string.find(msg, L["landing_trigger"]) then 
					self:Message(v[1], "Important", true, "Long")
				elseif self.db.profile.otherwarn and string.find(msg, L["zerg_trigger"]) then 
					self:Message(v[1], "Important", true, "Long")
				end
			end
			return
		end
	end
end

-- mind control
function module:CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE(arg1)
	local _,_, player, type = string.find(arg1, L["mcplayer"])
	if player and type then
		if player == L["mcyou"] and type == L["mcare"] then
			player = UnitName("player")
		end
		if self.db.profile.mc then 
            self:Message(player .. L["mcplayerwarn"], "Important") 
            self:Bar(player .. L["mcplayerwarn"], timer.mc, icon.mc, "Orange")
        end
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["fear_trigger"]) then
		self:Sync(syncName.fear)
	elseif string.find(msg, L["shadowflame_trigger"]) then
		self:Sync(syncName.shadowflame)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
    if string.find(msg, L["fear_over_trigger"]) then
        --self:RemoveWarningSign(icon.fear)
    end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.shadowflame then
		self:Shadowflame()
	elseif sync == syncName.fear then
		self:Fear()
    elseif sync == syncName.landing then
		self:Landing()
    end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Shadowflame()
	if self.db.profile.shadowflame then
		self:Bar(L["shadowflame_bar"], timer.shadowflameCast, icon.shadowflame)
		self:Message(L["shadowflame_warning"], "Important", true, "Alarm")
		self:DelayedBar(timer.shadowflameCast, L["shadowflame_bar"], timer.shadowflame - timer.shadowflameCast, icon.shadowflame)
	end
end

function module:Fear()
	if self.db.profile.fear then
        self:RemoveBar(L["fear_bar"])
		self:Message(L["fear_warning"], "Important", true, "Alert")
		self:Bar(L["fear_warn"], timer.fearCast, icon.fear)
		self:DelayedBar(timer.fearCast, L["fear_bar"], timer.fear - timer.fearCast, icon.fear)
        --self:WarningSign(icon.fear, 5)
	end
end

function module:Landing()
	if not self.phase2 then
        self.phase2 = true
        self:RemoveBar(L["land"])
        self:Bar(L["landing_warning"], timer.landing, icon.landing)
        self:Message(L["landing_warning"], "Important")
		
		-- landed after 15s
		self:DelayedBar(timer.landing, L["classcall_bar"], timer.firstClasscall, icon.classcall)
        self:DelayedBar(timer.landing, L["fear_bar"], timer.firstFear, icon.fear)
        
        -- set ktm
        local function setKTM()
            self:KTM_SetTarget(self:ToString())
            self:KTM_Reset()
        end
        self:ScheduleEvent("bwnefarianktm", setKTM, timer.landing + 1, self)
	end
end
