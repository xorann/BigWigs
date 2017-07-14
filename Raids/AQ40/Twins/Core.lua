
------------------------------
--      Are you local?      --
------------------------------

local bossName = "The Twin Emperors"
local L = BigWigs.i18n[bossName]
local veklor = AceLibrary("Babble-Boss-2.2")["Emperor Vek'lor"]
local veknilash = AceLibrary("Babble-Boss-2.2")["Emperor Vek'nilash"]
local module = BigWigs:GetModule(bossName)
local L = BigWigs.I18n[bossName]

-- module variables
module.revision = 20012 -- To be overridden by the module!
module.enabletrigger = {veklor, veknilash} -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"bug", "teleport", "enrage", "heal", "blizzard", "bosskill"}

-- locals
module.timer = {
	teleport = 29.8,
	enrage = 900,
	blizzard = 10,
}
local timer = module.timer

module.icon = {
	teleport = "Spell_Arcane_Blink",
	enrage = "Spell_Shadow_UnholyFrenzy",
	blizzard = "Spell_Frost_IceStorm",
}
local icon = module.icon

module.syncName = {
	teleport = "TwinsTeleport43",
	teleport_old = "TwinsTeleport",
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------

function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.teleport then
        self:Teleport()
	end
end


------------------------------
--      Sync Handlers	    --
------------------------------

function module:Teleport()
	if self.db.profile.teleport then
		self:Bar(L["bartext"], timer.teleport, icon.teleport)
        
        self:DelayedSync(timer.teleport, syncName.teleport_old)
        self:DelayedSync(timer.teleport, syncName.teleport)
        self:KTM_Reset()
        
        self:DelayedSound(timer.teleport - 10, "Ten")
        self:DelayedSound(timer.teleport - 3, "Three")
        self:DelayedSound(timer.teleport - 2, "Two")
        self:DelayedSound(timer.teleport - 1, "One")
        self:DelayedMessage(timer.teleport - 0.1, L["portwarn"], "Attention", false, "Alarm")
	end
end
