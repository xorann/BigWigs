------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.bwl.vaelastrasz
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20013 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = { "start", "flamebreath", "adrenaline", "whisper", "tankburn", "icon", "bosskill" }


-- locals
module.timer = {
	adrenaline = 20,
	flamebreath = 2,
	tankburn = 44.9,
	start1 = 38,
	start2 = 28,
	start3 = 12,
}
local timer = module.timer

module.icon = {
	adrenaline = "INV_Gauntlets_03",
	flamebreath = "Spell_Fire_Fire",
	tankburn = "INV_Gauntlets_03",
	start = "Spell_Holy_PrayerOfHealing",
}
local icon = module.icon

module.syncName = {
	adrenaline = "VaelAdrenaline",
	flamebreath = "VaelBreath",
	tankburn = "VaelTankBurn",
}
local syncName = module.syncName

module.barstarted = nil


------------------------------
-- Synchronization	    --
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.flamebreath then
		self:Flamebreath()
	elseif sync == syncName.adrenaline and rest and rest ~= "" then
		self:Adrenaline(rest)
	elseif sync == syncName.tankburn then
		self:Tankburn()
	end
end


------------------------------
-- Sync Handlers	    --
------------------------------
function module:Tankburn()
	if self.db.profile.tankburn then
		self:Bar(L["bar_tankburn"], timer.tankburn, icon.tankburn, true, "Black")
		self:DelayedMessage(timer.tankburn - 5, L["msg_tankBurnSoon"], "Urgent", nil, nil, true)
	end
end

function module:Flamebreath()
	if self.db.profile.flamebreath then
		self:Bar(L["bar_breath"], timer.flamebreath, icon.flamebreath)
		self:Message(L["msg_breath"], "Urgent")
	end
end

function module:Adrenaline(name)
	if name then
		-- send whisper
		if self.db.profile.whisper and name ~= UnitName("player") then
			self:TriggerEvent("BigWigs_SendTell", name, L["msg_adrenalineYou"])
		end

		-- bar and message
		if self.db.profile.adrenaline then
			self:Bar(string.format(L["bar_adrenaline"], name), timer.adrenaline, icon.adrenaline, true, "White")
			self:SetCandyBarOnClick("BigWigsBar " .. string.format(L["bar_adrenaline"], name), function(name, button, extra) TargetByName(extra, true) end, name)
			if name == UnitName("player") then
				self:Message(L["msg_adrenalineYou"], "Attention", true, "Beware")
				self:WarningSign(icon.adrenaline, timer.adrenaline)
			else
				self:Message(string.format(L["msg_adrenaline"], name), "Urgent")
			end
		end

		-- set icon
		if self.db.profile.icon then
			self:Icon(name, -1, timer.adrenaline)
		end

		-- tank burn
		for i = 1, GetNumRaidMembers() do
			if UnitExists("raid" .. i .. "target") and UnitName("raid" .. i .. "target") == self.translatedName and UnitExists("raid" .. i .. "targettarget") and UnitName("raid" .. i .. "targettarget") == name then
				self:Sync(syncName.tankburn)
				break
			end
		end
	end
end


------------------------------
-- Utility				    --
------------------------------
function module:PlayerDeath(name)
	if self.db.profile.adrenaline then
		self:RemoveBar(string.format(L["bar_adrenaline"], name))
	end
end

function module:StartSoon(time)
	if self.db.profile.start then
		if time == timer.start1 then
			self:Bar(L["bar_engage"], timer.start1, icon.start, true, "Cyan")
			self.barstarted = true
		elseif time == timer.start2 and not self.barstarted then
			self:Bar(L["bar_engage"], timer.start2, icon.start, true, "Cyan")
			self.barstarted = true
		elseif time == timer.start3 and not self.barstarted then
			self:Bar(L["bar_engage"], timer.start3, icon.start, true, "Cyan")
		end
	end
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:StartSoon(timer.start1)
	module:StartSoon(timer.start2)
	module:StartSoon(timer.start3)
	module:PlayerDeath(UnitName("player"))
	module:Adrenaline(UnitName("player"))
	module:Flamebreath()
	module:Tankburn()

	module:BigWigs_RecvSync(syncName.flamebreath)
	module:BigWigs_RecvSync(syncName.adrenaline, UnitName("player"))
	module:BigWigs_RecvSync(syncName.tankburn)
end
