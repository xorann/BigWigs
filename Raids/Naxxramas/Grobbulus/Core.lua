------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.naxx.grobbulus
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20015 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["misc_addName"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"youinjected", "otherinjected", "icon", "cloud", "slimespray", -1, "bombardSlime", -1, "enrage", "bosskill"}

module.defaultDB = {
    bombardSlime = false,
}

-- locals
module.timer = {
	enrage = 720,
	inject = 10,
	cloud = 15,
	firstSlimeSpray = {
		min = 20, 
		max = 30
	},
	slimeSpray = {
		min = 25, -- 26.500
		max = 45 -- 43.334
	},
	bombardSlime = 270
}
local timer = module.timer

module.icon = {
	enrage = "INV_Shield_01",
	inject = "Spell_Shadow_CallofBone",
	cloud = "Ability_Creature_Disease_02",
	slimeSpray = "INV_Misc_Slime_01",
	bombardSlime = "INV_Misc_Slime_01",
}
local icon = module.icon

module.syncName = {
	inject = "GrobbulusInject",
	cloud = "GrobbulusCloud",
	slimeSpray = "GrobbulusSlimeSpray",
	bombardSlime = "GrobbulusBombardSlime"
}
local syncName = module.syncName


------------------------------
--      Synchronization	    --
------------------------------
function module:BigWigs_RecvSync( sync, rest, nick )
	if sync == syncName.inject and rest then
		self:Inject(rest)
	elseif sync == syncName.cloud then
		self:Cloud()
	elseif sync == syncName.slimeSpray then
		self:SlimeSpray()
	elseif sync == syncName.bombardSlime then
		self:BombardSlime()
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------
function module:Inject(player)
	if player then
		if self.db.profile.youinjected and player == UnitName("player") then			
			self:Message(L["msg_bombYou"], "Personal", true, "RunAway")
			self:WarningSign(icon.inject, timer.inject)
			self:Bar(L["msg_bombYou"], timer.inject, icon.inject)
			self:Say(L["misc_bombSay"])
		elseif self.db.profile.otherinjected then
			self:Message(string.format(L["msg_bombOther"], player), "Attention", false, false)
			self:Whisper(L["msg_bombYou"], player)
			--self:Bar(string.format(L["bar_bomb"], player), timer.inject, icon.inject)
		end
		
		if self.db.profile.icon then
			self:Icon(player, -1, timer.inject)
		end
	end
end

function module:Cloud()
	if self.db.profile.cloud then
		self:Message(L["msg_cloud"], "Urgent")
		self:Bar(L["bar_cloud"], timer.cloud, icon.cloud)			
	end
end

function module:SlimeSpray()	
	if self.db.profile.slimespray then
		self:RemoveBar(L["bar_slimeSpray"])
		self:Bar(L["bar_slimeSpray"], timer.slimeSpray, icon.slimeSpray)
	end
end

-- three sewage slimes respawn timer
function module:BombardSlime()	
	if self.db.profile.bombardSlime then
		self:RemoveBar(L["bar_bombardSlime"])
		self:Bar(L["bar_bombardSlime"], timer.bombardSlime, icon.bombardSlime)
	end
end


------------------------------
-- Utility	Functions   	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions	
	module:Inject(UnitName("player"))
	module:Cloud()
	
	module:BigWigs_RecvSync(syncName.inject, UnitName("player"))
	module:BigWigs_RecvSync(syncName.cloud)
	module:BigWigs_RecvSync(syncName.slimeSpray)
end
