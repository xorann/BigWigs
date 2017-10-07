------------------------------
-- Variables     			--
------------------------------

local bossName = BigWigs.bossmods.other.kazzak
local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]

-- module variables
module.revision = 20014 -- To be overridden by the module!
module.enabletrigger = module.translatedName -- string or table {boss, add1, add2}
--module.wipemobs = { L["add_name"] } -- adds which will be considered in CheckForEngage
module.toggleoptions = {"markofkazzak", "puticon", "twistedreflection", "voidbolt", "corruptsoul", "supreme", "bosskill"}

-- locals
local timer = {
	supreme = 180,
	mark = 10,
	reflection = 45,
	voidboltCast = 1.5,
}
module.timer = timer

local icon = {
	supreme = "Spell_Shadow_ShadowWordPain",
	mark = "Spell_Shadow_Antishadow",
	reflection = "Spell_Arcane_PortalDarnassus",
	voidbolt = "Spell_Shadow_Haunting",
}
module.icon = icon

local syncName = {
	markStart = "LordKazzakMarkStart",
	markStop = "LordKazzakMarkStop",
	reflectionStart = "LordKazzakReflectionStart",
	reflectionStop = "LordKazzakReflectionStop",
	voidboltStart = "LordKazzakVoidBoltStart",
	voidboltStop = "LordKazzakVoidBoltStop",
	supreme = "LordKazzakSupreme",
	death = "LordKazzakDead",
	randomDeath = "LordKazzakRandomDeath",
}
module.syncName = syncName

module.voidbolttime = nil
module.castingvoidbolt = nil

------------------------------
-- Synchronization	    	--
------------------------------
function module:BigWigs_RecvSync(sync, rest, nick)
	if sync == syncName.markStart and rest ~= UnitName("player") then
		if self.db.profile.markofkazzak then
		    self:Message(string.format(L["msg_mark"], rest), "Important")
			self:Whisper(rest, L["msg_markYou"])
			self:Bar(string.format(L["bar_mark"], rest), timer.mark, icon.mark)
		end
		
		if self.db.profile.puticon then
			self:Icon(rest)
		end
	elseif sync == syncName.markStop and rest ~= UnitName("player") then
		if self.db.profile.markofkazzak then
			self:RemoveBar(string.format(L["bar_mark"], rest))
		end
		
		if self.db.profile.puticon then
			self:RemoveIcon()
		end
	elseif sync == syncName.reflectionStart and rest ~= UnitName("player") then
		if self.db.profile.twistedreflection then
			self:Message(string.format(L["msg_reflection"], rest), "Important")
			self:Bar(string.format(L["bar_reflection"], rest), timer.reflection, icon.reflection, true, "magenta")
		end
	elseif sync == syncName.reflectionStop and rest ~= UnitName("player") then
		if self.db.profile.twistedreflection then
			self:RemoveBar(string.format(L["bar_reflection"], rest))
		end
	elseif sync == syncName.randomDeath and rest ~= UnitName("player") then
		if self.db.profile.markofkazzak then
			self:RemoveBar(string.format(L["bar_mark"], rest))
		end
		
		if self.db.profile.puticon then
			self:RemoveIcon()
		end
		
		if self.db.profile.twistedreflection then
			self:RemoveBar(string.format(L["bar_reflection"], rest))
		end
		
		if self.db.profile.corruptsoul then
			self:Message(string.format(L["msg_corruptSoulOther"], rest), "Important")
		end
	elseif sync == syncName.voidboltStart then
		module.voidbolttime = GetTime()
		module.castingvoidbolt = true
		if self.db.profile.voidbolt then
			self:Bar(L["bar_voidbolt"], timer.voidboltCast, icon.voidbolt)
		end
	elseif sync == syncName.voidboltStop then
		module.castingvoidbolt = false
		if self.db.profile.voidbolt then
			self:RemoveBar(L["bar_voidbolt"])
		end
	elseif sync == syncName.supreme and self.db.profile.supreme then
		self:Message(L["bar_voidbolt"], "Important")
	end
end


------------------------------
-- Sync Handlers	    	--
------------------------------


----------------------------------
-- Module Test Function    		--
----------------------------------

-- automated test
function module:TestModuleCore()
	-- check core functions
	module:BigWigs_RecvSync(syncName.markStart, UnitName("player"))
	module:BigWigs_RecvSync(syncName.markStop, UnitName("player"))
	module:BigWigs_RecvSync(syncName.reflectionStart, UnitName("player"))
	module:BigWigs_RecvSync(syncName.reflectionStop, UnitName("player"))
	module:BigWigs_RecvSync(syncName.randomDeath, UnitName("player"))
	module:BigWigs_RecvSync(syncName.voidboltStart)
	module:BigWigs_RecvSync(syncName.voidboltStop)
	module:BigWigs_RecvSync(syncName.supreme)
end
