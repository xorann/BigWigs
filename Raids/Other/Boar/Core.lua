------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.other.boar
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
module.toggleoptions = {"engage", "charge", "proximity", "bosskill"}

-- locals
module.timer = {
	charge = 10,
	teleport = 30,
}
local timer = module.timer

module.icon = {
	charge = "Spell_Frost_FrostShock",
	teleport = "Spell_Arcane_Blink",
}
local icon = module.icon

module.syncName = {
	teleport = "TwinsTeleport",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync( sync, rest, nick )
    self:DebugMessage("boar sync: " .. sync)
    
    if sync == syncName.teleport then
		self:Teleport()
	elseif sync == "BigWigsRaidIconTest" then
		self:SetRaidIcon()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:SetRaidIcon()
	self:Icon("Dorann")
end

function module:Teleport()
	self:Bar(L["msg_teleport"], timer.teleport, icon.teleport)

	self:DelayedSound(timer.teleport - 10, "Ten")
	self:DelayedSound(timer.teleport - 3, "Three")
	self:DelayedSound(timer.teleport - 2, "Two")
	self:DelayedSound(timer.teleport - 1, "One")
	
	self:CancelDelayedSync(syncName.teleport)
	self:DelayedSync(timer.teleport, syncName.teleport)

	self:KTM_Reset()
end


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:Teleport()
	module:SetRaidIcon()
	
	module:BigWigs_RecvSync(syncName.teleport)
end
