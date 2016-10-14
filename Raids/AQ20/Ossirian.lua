
----------------------------------
--      Module Declaration      --
----------------------------------

local module, L = BigWigs:ModuleDeclaration("Ossirian the Unscarred", "Ruins of Ahn'Qiraj")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Ossirian",

	supreme_cmd = "supreme",
	supreme_name = "Supreme Alert",
	supreme_desc = "Warn for Supreme Mode",

	debuff_cmd = "debuff",
	debuff_name = "Debuff Alert",
	debuff_desc = "Warn for Defuff",

	supremetrigger = "Ossirian the Unscarred gains Strength of Ossirian.",
	supremewarn = "Ossirian Supreme Mode!",
	supremedelaywarn = "Supreme in %d seconds!",
	debufftrigger = "Ossirian the Unscarred is afflicted by (.+) Weakness.",
	crystaltrigger = "Ossirian Crystal Trigger dies.",
	debuffwarn = "Ossirian now weak to %s!",
	supreme_bar = "Supreme",
	expose = "Expose",

	["Shadow"] = true,
	["Fire"] = true,
	["Frost"] = true,
	["Nature"] = true,
	["Arcane"] = true,
	
	["ShadowIcon"] = "Spell_Shadow_ChillTouch",
	["FireIcon"] = "Spell_Fire_Fire",
	["FrostIcon"] = "Spell_Frost_ChillingBlast",
	["NatureIcon"] = "Spell_Nature_Acid_01",
	["ArcaneIcon"] = "Spell_Arcane_PortalOrgrimmar",
} end )

L:RegisterTranslations("deDE", function() return {
	supreme_name = "Stärke des Ossirian",
	supreme_desc = "Warnung vor Stärke des Ossirian.",

	debuff_name = "Debuff",
	debuff_desc = "Warnung vor Debuff.",

	supremetrigger = "Ossirian der Narbenlose bekommt 'Stärke des Ossirian'.",
	supremewarn = "Stärke des Ossirian!",
	supremedelaywarn = "Stärke des Ossirian in %d Sekunden!",
	debufftrigger = "Ossirian der Narbenlose ist von (.*)schwäche betroffen.",
	crystaltrigger = "Ossirian Crystal Trigger dies.", -- translation missing
	debuffwarn = "Ossirian für 45 Sekunden anfällig gegen: %s",
	supreme_bar = "Stärke des Ossirian",
	expose = "Schwäche",

	["Shadow"] = "Schatten",
	["Fire"] = "Feuer",
	["Frost"] = "Frost",
	["Nature"] = "Natur",
	["Arcane"] = "Arkan",
	
	["ShadowIcon"] = "Spell_Shadow_ChillTouch",
	["FireIcon"] = "Spell_Fire_Fire",
	["FrostIcon"] = "Spell_Frost_ChillingBlast",
	["NatureIcon"] = "Spell_Nature_Acid_01",
	["ArcaneIcon"] = "Spell_Arcane_PortalOrgrimmar",
} end )


---------------------------------
--      	Variables 		   --
---------------------------------

-- module variables
module.revision = 20005 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"supreme", "debuff", "bosskill"}

-- locals
local timer = {
	weakness = 45,
	supreme = 45,
}
local icon = {
	supreme = "Spell_Shadow_CurseOfTounges",
}
local syncName = {
	weakness = "OssirianWeakness",
	crystal = "OssirianCrystal",
	supreme = "OssirianSupreme",
}

local currentWeakness = nil
local timeLastWeaken = nil


------------------------------
--      Initialization      --
------------------------------

--module:RegisterYellEngage(L["start_trigger"])

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	
	self:ThrottleSync(3, syncName.weakness)
	self:ThrottleSync(3, syncName.crystal)
	self:ThrottleSync(3, syncName.supreme)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	timeLastWeaken = GetTime()
    self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

-- called after boss is engaged
function module:OnEngage()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers	    --
------------------------------

function module:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	BigWigs:CheckForBossDeath(msg, self)
	
	-- if the same weakness triggers back to back, the normal combat log entry is missing for the weakness
	-- this event is triggered 2s later
	if string.find(msg, L["crystaltrigger"]) then
		self:Sync(syncName.crystal)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE( msg )
	local _, _, debuffName = string.find(msg, L["debufftrigger"])
	if debuffName and debuffName ~= L["expose"] and L:HasReverseTranslation(debuffName) then
		self:Sync(syncName.weakness .. " " .. L:GetReverseTranslation(debuffName))
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if string.find(msg, L["supremetrigger"]) then
		self:Sync(syncName.supreme)
	end
end


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.weakness and rest then
		self:Weakness(rest)
	elseif sync == syncName.crystal then
		self:Crystal()
	elseif sync == syncName.supreme then
		self:Supreme()
	end
end

------------------------------
--      Sync Handlers	    --
------------------------------

function module:Weakness(weakness, delay)
	if not weakness then
        return
    end
    if not delay then
		delay = 0
	end
	
	timeLastWeaken = GetTime()
	currentWeakness = weakness

	if self.db.profile.debuff then
		self:Message(string.format(L["debuffwarn"], L[tostring(weakness)]), "Important")
		self:Bar(L[weakness], timer.weakness - delay, L[weakness .. "Icon"])
	end

	self:RemoveBar(L["supreme_bar"])
	self:CancelDelayedMessage(string.format(L["supremedelaywarn"], 15))
	self:CancelDelayedMessage(string.format(L["supremedelaywarn"], 10))
	self:CancelDelayedMessage(string.format(L["supremedelaywarn"], 5))

	if self.db.profile.supreme then
		self:DelayedMessage(timer.supreme - delay, string.format(L["supremedelaywarn"], 15), "Attention", nil, nil, true)
		self:DelayedMessage(timer.supreme - delay, string.format(L["supremedelaywarn"], 10), "Urgent", nil, nil, true)
		self:DelayedMessage(timer.supreme - delay, string.format(L["supremedelaywarn"], 5), "Important", nil, nil, true)
		self:Bar(L["supreme_bar"], timer.supreme - delay, icon.supreme)
	end
end

function module:Crystal()
	if timeLastWeaken + 3 < GetTime() then -- crystal trigger occurs 2s after weaken trigger
		self:Weakness(currentWeakness, 2)
	end
end

function module:Supreme()
	if self.db.profile.supreme then
		self:Message(L["supremewarn"], "Attention", nil, "Beware")
	end
end
