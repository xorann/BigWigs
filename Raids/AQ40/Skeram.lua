
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("The Prophet Skeram", "Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Skeram",

	-- commands
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",

	split_cmd = "split",
	split_name = "Split Alert",
	split_desc = "Warn before Splitting",

	-- triggers
	trigger_mcGainPlayer = "You are afflicted by True Fulfillment.",
	trigger_mcGainOther = "(.*) is afflicted by True Fulfillment.",
	trigger_mcPlayerGone = "True Fulfillment fades from you.",
	trigger_mcOtherGone = "True Fulfillment fades from (.*).",
	trigger_deathPlayer = "You die.",
	trigger_deathOther = "(.*) dies.",
	["You have slain %s!"] = true,

	-- messages
	msg_mcPlayer = "You are mindcontrolled!",
	msg_mcOther = "%s is mindcontrolled!",
	msg_splitSoon = "Split soon! Get ready!",
	msg_split = "Split!",

	-- bars
	bar_mc = "MC: %s",

} end )

L:RegisterTranslations("deDE", function() return {
	-- commands
	mc_name = "Gedankenkontrolle",
	mc_desc = "Warnen, wenn jemand übernommen ist",

	split_name = "Abbilder",
	split_desc = "Alarm vor der Aufteilung",

	-- triggers
	trigger_mcGainPlayer = "Ihr seid von Wahre Erfüllung betroffen.",
	trigger_mcGainOther = "(.*) ist von Wahre Erfüllung betroffen.",
	trigger_mcPlayerGone = "Wahre Erfüllung\' schwindet von Euch.",
	trigger_mcOtherGone = "Wahre Erfüllung schwindet von (.*).",
	trigger_deathPlayer = "Du stirbst.",
	trigger_deathOther = "(.*) stirbt.",

	["You have slain %s!"] = "Ihr habt %s getötet!",

	-- messages
	msg_mcPlayer = "Ihr seid von Wahre Erfüllung betroffen.",
	msg_mcOther = "%s steht unter Gedankenkontrolle!",
	msg_splitSoon = "Abbilder bald! Sei bereit!",
	msg_split = "Abbilder!",

	-- bars
	bar_mc = "GK: %s",

} end )

---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"mc", "split", "bosskill"}

-- locals
local timer = {
	mc = 20,
}
local icon = {
	mc = "Spell_Shadow_Charm",
}
local syncName = {
	mc = "SkeramMC",
	mcOver = "SkeramMCEnd",
	split80 = "SkeramSplit80Soon",
	split75 = "SkeramSplit75Now",
	split55 = "SkeramSplit55Soon",
	split50 = "SkeramSplit50Now",
	split30 = "SkeramSplit30Soon",
	split25 = "SkeramSplit25Now",
}

module.splittime = false


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_PARTY", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER", "Event")
	--self:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH", "Event")
	self:RegisterEvent("UNIT_HEALTH")

	
	self:ThrottleSync(1, syncName.mc)
	self:ThrottleSync(1, syncName.mcOver)

	self:ThrottleSync(100, syncName.split80)
	self:ThrottleSync(100, syncName.split75)
	self:ThrottleSync(100, syncName.split55)
	self:ThrottleSync(100, syncName.split50)
	self:ThrottleSync(100, syncName.split30)
	self:ThrottleSync(100, syncName.split25)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.splittime = false
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end



------------------------------
--      Event Handlers      --
------------------------------

-- override
function module:CheckForBossDeath(msg)
    if msg == string.format(UNITDIESOTHER, self:ToString()) 
        or msg == string.format(L["You have slain %s!"], self.translatedName) then
		-- check that it wasn't only a copy
		local function IsBossInCombat()
            local t = module.enabletrigger
            if not t then return false end
            if type(t) == "string" then t = {t} end

            if UnitExists("target") and UnitAffectingCombat("target") then
                local target = UnitName("target")
                for _, mob in pairs(t) do
                    if target == mob then
                        return true
                    end
                end
            end

            local num = GetNumRaidMembers()
            for i = 1, num do
                local raidUnit = string.format("raid%starget", i)
                if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
                    local target = UnitName(raidUnit)
                    for _, mob in pairs(t) do
                        if target == mob then
                            return true
                        end
                    end
                end
            end
            return false
        end
		
		if not IsBossInCombat() then
			self:SendBossDeathSync()
		end
	end
end

function module:Event(msg)
	local _,_, mindcontrolother, mctype = string.find(msg, L["trigger_mcGainOther"])
	local _,_, mindcontrolotherend, mctype = string.find(msg, L["trigger_mcOtherGone"])
	local _,_, mindcontrolotherdeath,mctype = string.find(msg, L["trigger_deathOther"])
	if string.find(msg, L["trigger_mcGainPlayer"]) then
		self:Sync(syncName.mc .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_mcPlayerGone"]) then
		self:Sync(syncName.mcOver .. " " .. UnitName("player"))
	elseif string.find(msg, L["trigger_deathPlayer"]) then
		self:Sync(syncName.mcOver .. " " .. UnitName("player"))
	elseif mindcontrolother then
		self:Sync(syncName.mc .. " " .. mindcontrolother)
	elseif mindcontrolotherend then
		self:Sync(syncName.mcOver .. " " .. mindcontrolotherend)
	elseif mindcontrolotherdeath then
		self:Sync(syncName.mcOver .. " " .. mindcontrolotherdeath)
	end
end

function module:UNIT_HEALTH(arg1)
	if UnitName(arg1) == boss then
		local health = UnitHealth(arg1)
		local maxhealth = UnitHealthMax(arg1)
		if (health > 424782 and health <= 453100) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit80Soon")
		elseif (health > 283188 and health <= 311507) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit55Soon")
		elseif (health > 141594 and health <= 169913) and maxhealth == 566375 and not module.splittime then
			self:Sync("SkeramSplit30Soon")
		elseif (health > 311508 and health <= 424781) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit75Now")
		elseif (health > 169914 and health <= 283187) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit50Now")
		elseif (health > 1 and health <= 141593) and maxhealth == 566375 and module.splittime then
			self:Sync("SkeramSplit25Now")
		end
	end
end

------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
    if sync == syncName.split80 then
		self:SplitSoon()
	elseif sync == syncName.split55 then
		self:SplitSoon()
	elseif sync == syncName.split30 then
		self:SplitSoon()
	elseif sync == syncName.split75 then
		self:Split()
	elseif sync == syncName.split50 then
		self:Split()
	elseif sync == syncName.split25 then
		self:Split()
	elseif sync == syncName.mc then
		self:MindControl(rest)
	elseif sync == syncName.mcOver then
		self:MindControlGone(rest)
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

function module:MindControl(name)
	if self.db.profile.mc then
		if name == UnitName("player") then
			self:Bar(string.format(L["bar_mc"], UnitName("player")), timer.mc, icon.mc, true, "White")
			self:Message(L["msg_mcPlayer"], "Attention")
		else
			self:Bar(string.format(L["bar_mc"], rest), timer.mc, icon.mc, true, "White")
			self:Message(string.format(L["msg_mcOther"], rest), "Urgent")
		end
	end
end

function module:MindControlGone(name)
	if self.db.profile.mc then
		self:RemoveBar(string.format(L["bar_mc"], name))
	end
end

function module:SplitSoon()
	module.splittime = true
	if self.db.profile.split then
		self:Message(L["msg_splitSoon"], "Urgent")
	end
end

function module:Split()
	module.splittime = false
	if self.db.profile.split then
		self:Message(L["msg_split"], "Important", "Alarm")
	end
end
