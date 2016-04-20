--[[
--
-- Big Wigs Strategy Module for Loatheb in Naxxramas.
--
-- Adds warning messages, whispers and raid icons for the groups that are next in line to get Spore
--
--	visit us at http://www.caelum.ws
--]]

------------------------------
--      Are you local?      --
------------------------------

local myname = "Loatheb Tactical"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..myname)
local boss = AceLibrary("Babble-Boss-2.2")["Loatheb"]

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "BigWigsLoathebTactical",
	
	graphic_cmd = "graphic",
	graphic_name = "Graphical Icons",
	graphic_desc = "When checked shows graphical icons",
	
	sound_cmd = "sound",
	sound_name = "Sound Effects",
	sound_desc = "When checked plays sound effects",

	doomtrigger = "afflicted by Inevitable Doom.",

	consumable_cmd = "consumable",
	consumable_name = "Do NOT warn raid to use consumables (A)",
	consumable_desc = "When check does NOT warn raid to use consambles over raidwarn. Requires Assistance (A)",
	
	shadowpot = "-- Drink Shadow Protection Potion ! --",
	bandage = "-- Use your bandages ! --",
	wrtorhs = "-- Healthstone or Whipper Root Tuber ! --",
	shadowpotandbandage = "-- Drink Shadow Protection Potion and Bandage ! --",
	noconsumable = "-- No Consumable at this time ! --",
	
	soundshadowpot = "Interface\\Addons\\BigWigs_LoathebTactical\\Sounds\\potion.wav",
	soundbandage = "Interface\\Addons\\BigWigs_LoathebTactical\\Sounds\\bandage.wav",
	soundwrtorhs = "Interface\\Addons\\BigWigs_LoathebTactical\\Sounds\\healthstone.wav",
	soundshadowpotandbandage = "Interface\\Addons\\BigWigs_LoathebTactical\\Sounds\\potionandbandage.wav",
	soundgoforbuff = "Interface\\Addons\\BigWigs_LoathebTactical\\Sounds\\goforbuff.wav",
	
	resetmsg = "Bigwigs Loatheb Tactical Module has reset"

} end )

-- timing -------------------2:10-------------2:40------------3:10---------3:40--------------4:10---------------4:40--------------5:10-----------5:25-------------5:40
-- after 5 minutes doom comes every 15seconds
local consumableslist = {L["shadowpot"],L["noconsumable"],L["bandage"],L["wrtorhs"],L["shadowpotandbandage"],L["noconsumable"],L["bandage"],L["noconsumable"],L["wrtorhs"]}

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLoathebTactical = BigWigs:NewModule(myname)
BigWigsLoathebTactical.synctoken = myname
BigWigsLoathebTactical.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsLoathebTactical.enabletrigger = { boss }
BigWigsLoathebTactical.toggleoptions = { "consumable", "graphic", "sound"}
BigWigsLoathebTactical.revision = tonumber(string.sub("$Rev: 17765 $", 12, -3))
BigWigsLoathebTactical.external = true

------------------------------
--      Initialization      --
------------------------------
function BigWigsLoathebTactical:OnRegister()
	self.frameIcon = CreateFrame("Frame",nil,UIParent)	
	
	self.frameIcon:SetFrameStrata("MEDIUM")
	self.frameIcon:SetWidth(100)
	self.frameIcon:SetHeight(100)
	self.frameIcon:SetAlpha(0.6)
	
	self.frameTexture = self.frameIcon:CreateTexture(nil,"BACKGROUND")
	
	self.frameTexture:SetTexture(nil)
	self.frameTexture:SetAllPoints(self.frameIcon)
	
	self.frameIcon:Hide()
	
	self.frameIcon2 = CreateFrame("Frame",nil,UIParent)	
	
	self.frameIcon2:SetFrameStrata("MEDIUM")
	self.frameIcon2:SetWidth(100)
	self.frameIcon2:SetHeight(100)
	self.frameIcon2:SetAlpha(0.6)
	
	self.frameTexture2 = self.frameIcon2:CreateTexture(nil,"BACKGROUND")
	
	self.frameTexture2:SetTexture(nil)
	self.frameTexture2:SetAllPoints(self.frameIcon2)
	
	self.frameIcon2:Hide()
end

function BigWigsLoathebTactical:OnEnable()
	
	self.sporespawn = 1
	self.consumableseq = 1

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	
	self:RegisterEvent("BigWigs_RecvSync")	
	
	DEFAULT_CHAT_FRAME:AddMessage(L["resetmsg"])
end

------------------------------
--      Utility             --
------------------------------

function BigWigsLoathebTactical:BigWigs_RecvSync( sync, rest, nick )
	if sync == "LoathebDoom2" and rest then		
		rest = tonumber(rest)
		if not rest then return end
		if rest == (self.consumableseq + 1) then
			self:ScheduleEvent("bwloathebconsumable "..tostring(self.consumableseq), self.ConsumableWarning, 11, self)			
		end	
	end
end

function BigWigsLoathebTactical:ConsumableWarning()
	if consumableslist[self.consumableseq] then
		if not self.db.profile.consumable then
				SendChatMessage(consumableslist[self.consumableseq], "RAID_WARNING")
				SendChatMessage(consumableslist[self.consumableseq], "SAY")
		end
		if self.db.profile.graphic then
			if consumableslist[self.consumableseq] == L["shadowpot"] then
				self.frameTexture:SetTexture("Interface\\Icons\\INV_Potion_23") --greater shadow protection
				self.frameTexture2:SetTexture(nil)
			elseif consumableslist[self.consumableseq] == L["bandage"] then
				self.frameTexture:SetTexture("Interface\\Icons\\INV_Misc_Bandage_12") -- heavy runecloth
				self.frameTexture2:SetTexture(nil)
			elseif consumableslist[self.consumableseq] == L["wrtorhs"] then
				self.frameTexture:SetTexture("Interface\\Icons\\INV_Stone_04") -- healthstone
				--self.frameTexture2:SetTexture("Interface\\Icons\\INV_Misc_Food_55") -- whipper root
			elseif consumableslist[self.consumableseq] == L["shadowpotandbandage"] then
				self.frameTexture:SetTexture("Interface\\Icons\\INV_Potion_23") --greater shadow protection
				self.frameTexture2:SetTexture("Interface\\Icons\\INV_Misc_Bandage_12") -- heavy runecloth
			elseif consumableslist[self.consumableseq] == L["noconsumable"] then
				self.frameTexture:SetTexture(nil)
				self.frameTexture2:SetTexture(nil)
			end
			
			self.frameIcon.texture = self.frameTexture
			self.frameTexture:SetTexCoord(0.0,1.0,0.0,1.0)
			self.frameIcon:SetPoint("CENTER",200,100)
			self.frameIcon:Show()
			
			self.frameIcon2.texture = self.frameTexture2
			self.frameTexture2:SetTexCoord(0.0,1.0,0.0,1.0)
			self.frameIcon2:SetPoint("CENTER",200,0)
			self.frameIcon2:Show()
			
			self:ScheduleEvent(function() 
				self.frameIcon:Hide() 
				self.frameIcon2:Hide()
			end, 5)			
		end 
		if self.db.profile.sound then
			if consumableslist[self.consumableseq] == L["shadowpot"] then
				PlaySoundFile(L["soundshadowpot"])
			elseif consumableslist[self.consumableseq] == L["bandage"] then
				PlaySoundFile(L["soundbandage"])
			elseif consumableslist[self.consumableseq] == L["wrtorhs"] then
				PlaySoundFile(L["soundwrtorhs"])
			elseif consumableslist[self.consumableseq] == L["shadowpotandbandage"] then
				PlaySoundFile(L["soundshadowpotandbandage"])
			end
		end
		self.consumableseq = self.consumableseq + 1
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsLoathebTactical:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end
