local bossName = BigWigs.bossmods.bwl.chromaggus
if BigWigs:IsBossSupportedByAnyServerProject(bossName) then
	return
end
-- no implementation found => use default implementation
--BigWigs:Print("default " .. bossName)


------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(bossName)
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20013 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

-- called after module is enabled
function module:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("UNIT_HEALTH")
	
	self:ThrottleSync(10, syncName.engage)
	self:ThrottleSync(1, syncName.breath)
	self:ThrottleSync(5, syncName.frenzy)
	self:ThrottleSync(5, syncName.frenzyOver)
end

-- called after module is enabled and after each wipe
function module:OnSetup()
	module.vulnerability = nil
	module.enrageAnnounced = nil
	module.frenzied = nil
    module.lastVuln = 0
end

-- called after boss is engaged
function module:OnEngage()        
	self:Engaged()
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------

function module:UNIT_HEALTH( msg )
	if not module.enrageAnnounced and UnitName(msg) == module.translatedName then
		local maxHealth = UnitHealthMax(msg)
		local currentHealth = UnitHealth(msg)
		local health = currentHealth / maxHealth * 100
		
		if health > 15 and health <= 20 then
			self:Sync(syncName.enrage)
		end
	end
end

function module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	local _,_, spellName = string.find(msg, L["trigger_breath"])
	if spellName then
		local breath = L:HasReverseTranslation(spellName) and L:GetReverseTranslation(spellName) or nil
		if breath then 
			breath = string.sub(breath, -1)
			self:Sync(syncName.breath .. " " ..breath)
		end
	end
end

function module:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, L["trigger_frenzy"]) and arg2 == boss then
		self:Sync(syncName.frenzy)
	elseif string.find(msg, L["trigger_vulnerability"]) then
		self:Sync(syncName.vulnerabilityChanged)
	end
end

function module:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["trigger_frenzyGone"] then
		self:Sync(syncName.frenzyOver)
	end
end

function module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
	if not self.db.profile.vulnerability then 
		return 
	end
	
	if not module.vulnerability then
		local _, _, dmg, school, userspell, partial = string.find(msg, L["trigger_vulnerability_dot"])
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

function module:PlayerDamageEvents(msg)
	if not self.db.profile.vulnerability then 
		return 
	end
	
	if not module.vulnerability then
		local _, _, userspell, stype, dmg, school, partial = string.find(msg, L["trigger_vulnerability_direct"]) 
		-- "^[%w]+[%s's]* ([%w%s:]+) ([%w]+) Chromaggus for ([%d]+) ([%w]+) damage%.[%s%(]*([%d]*)"
		-- [Fashu's] [Firebolt] [hits] Battleguard Sartura for [44] [Fire] damage. ([14] resisted)
		-- [Fashu's] [Feuerblitz] [trifft] Schlachtwache Sartura für [44] [Feuerschaden]. ([14] widerstanden)
		-- userspell: Firebolt; stype: hits; dmg: 44; school: Fire; partial: 14
		
		-- Kan's Life Steal crits Battleguard Sartura for 45 Shadow damage. (15 resisted)
		-- Kan's Lebensdiebstahl trifft Schlachtwache Sartura kritisch für 45 Schattenschaden. (15 widerstanden)
		
        
		if stype and dmg and school then
			-- german combat log entries for a crit are a bit special (<name> hits <enemy> critically for <x> damage.)
			if GetLocale() == "deDE" then
				if string.find(msg, L["crit"]) then 
					stype = L["crit"] 
				else 
					stype = L["hit"] 
				end
				school = string.gsub(school, "schaden", "") -- turn "Feuerschaden" into "Feuer"
			end
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
 

----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModule()
	module:OnEnable()
	module:OnSetup()
	module:OnEngage()

	module:TestModuleCore()

	-- check event handlers
	module:PlayerDamageEvents(L["trigger_vulnerability_direct"])
	module:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(L["trigger_vulnerability_dot"])
	module:CHAT_MSG_SPELL_AURA_GONE_OTHER(L["trigger_frenzyGone"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_frenzy"])
	module:CHAT_MSG_MONSTER_EMOTE(L["trigger_vulnerability"])
	module:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(L["trigger_breath"])
	module:UNIT_HEALTH(module.translatedName)

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
