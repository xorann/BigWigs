
assert( BigWigs, "BigWigs not found!")


------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsEnrage")
local paint = AceLibrary("PaintChips-2.0")
local minscale, maxscale = 0.25, 2
local candybar = AceLibrary("CandyBar-2.1")
local surface = AceLibrary("Surface-1.0")


----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Enrage"] = true, -- module name
	["enrage"] = true, -- console command
	
	 -- console options
	["Options for the enrage plugin."] = true,
	["Show anchor"] = true,
	["Show the bar anchor frame."] = true,
	["Reset position"] = true,
	["Reset the anchor position, moving it to the original position."] = true,
	["Scale"] = true,
	["Set the frame scale."] = true,
	["Texture"] = true,
	["Set the texture for the timerbars."] = true,
    ["Health"] = true,
            
    ["Test"] = true,
    ["Close"] = true,
} end)

L:RegisterTranslations("deDE", function() return {

} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEnrage = BigWigs:NewModule(L["Enrage"])
BigWigsEnrage.revision = 20004
BigWigsEnrage.defaultDB = {
	scale = 1.0,
	texture = "BantoBar",
    
    posx = nil,
    posy = nil,
	
	bossName = nil,
}
BigWigsEnrage.consoleCmd = L["enrage"]


BigWigsEnrage.consoleOptions = {
	type = "group",
	name = L["Enrage"],
	desc = L["Options for the enrage plugin."],
	args   = {
		anchor = {
			type = "execute",
			name = L["Show anchor"],
			desc = L["Show the bar anchor frame."],
            order = 1,
			func = function() BigWigsEnrage:BigWigs_ShowAnchors() end,
		},
        reset = {
			type = "execute",
			name = L["Reset position"],
			desc = L["Reset the anchor position, moving it to the original position."],
			order = 2,
			func = function() BigWigsEnrage:RestorePosition() end,
		},
		scale = {
			type = "range",
			name = L["Scale"],
			desc = L["Set the frame scale."],
            order = 15,
			min = 0.2,
			max = 2.0,
			step = 0.1,
			get = function() return BigWigsEnrage.db.profile.scale end,
			set = function(v) BigWigsEnrage.db.profile.scale = v end,
		},
		texture = {
			type = "text",
			name = L["Texture"],
			desc = L["Set the texture for the timerbars."],
            order = 16,
			get = function() return BigWigsEnrage.db.profile.texture end,
			set = function(v) BigWigsEnrage.db.profile.texture = v end,
			validate = surface:List(),
        },
	},
}


------------------------------
--      Initialization      --
------------------------------

function BigWigsEnrage:OnRegister()
	self.consoleOptions.args.texture.validate = surface:List()
    self:RegisterEvent("Surface_Registered", function()
		self.consoleOptions.args.texture.validate = surface:List()
    end)
end

function BigWigsEnrage:OnEnable()
	if not surface:Fetch(self.db.profile.texture) then 
		self.db.profile.texture = "BantoBar" 
	end
	
	self:SetupFrames()
    self:RegisterEvent("BigWigs_Enrage", "Start")
    self:RegisterEvent("BigWigs_EnrageStop", "Stop")
	self:RegisterEvent("BigWigs_ShowAnchors")
	self:RegisterEvent("BigWigs_HideAnchors")
	--self:RegisterEvent("BigWigs_StartBar")
	--self:RegisterEvent("BigWigs_StopBar")
	
	if not self:IsEventRegistered("Surface_Registered") then 
	    self:RegisterEvent("Surface_Registered", function()
			self.consoleOptions.args[L["Texture"]].validate = surface:List()
	    end)
	end
end


------------------------------
--      Event Handlers      --
------------------------------

function BigWigsEnrage:Start(enrageTimer, bossName)
	if enrageTimer and bossName then
		self.bossName = bossName
		
		self:TimerBar(enrageTimer)
		self:HPBar(bossName)
        self:SetHPBar(100)
		
		self:RegisterEvent("UNIT_HEALTH")
	end
end

function BigWigsEnrage:Stop()
	self:UnregisterCandyBar("BigWigsEnrage " .. L["Enrage"])
	self:UnregisterCandyBar("BigWigsEnrage " .. L["Health"])
	if self:IsEventRegistered("UNIT_HEALTH") then
        self:UnregisterEvent("UNIT_HEALTH")
    end
end


function BigWigsEnrage:TimerBar(enrageTimer)
	if enrageTimer then
		local icon = "Interface\\Icons\\Spell_Shadow_UnholyFrenzy"
		local id = self:CreateBar(L["Enrage"], enrageTimer, icon, "Blue")
	end
end

function BigWigsEnrage:HPBar(bossName)
	if bossName then
		local icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
		local id = self:CreateBar(L["Health"], 100, icon, "Orange")
		
		self:PauseCandyBar(id)
		self:SetCandyBarTimeFormat(id, function(t) 
			local timetext 
			if t == 100 then 
				timetext = "100" 
			elseif t == 0 then 
				timetext = "0%%" 
			else 
				timetext = string.format("%d", t)  .. "%"
			end 
			return timetext 
		end)	
	end
end

function BigWigsEnrage:SetHPBar(value)
	if (value == nil) or (value < 0) then return end
	local id = "BigWigsEnrage " .. L["Health"]
	local bar = candybar.var.handlers[id]
	if not bar then return end
	bar.elapsed = 100 - value
	candybar:Update(id)
	if bar.time <= value then
		--BigWigsEnrage:BigWigs_StopBar(module, text)
		BigWigs:Print("BigWigsEnrage: time lesser than equal value")
	end
end

function BigWigsEnrage:CreateBar(text, time, icon, color)
	if text and time then
		local id = "BigWigsEnrage " .. text
		if not icon then
			icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01"
		end
		
		-- yes we try and register every time, we also set the point every time since people can change their mind midbar.
		self:RegisterCandyBarGroup("BigWigsEnrageGroup")
		self:SetCandyBarGroupPoint("BigWigsEnrageGroup", "BOTTOM", self.frames.anchor, "TOP", 0, 0)
		self:SetCandyBarGroupGrowth("BigWigsEnrageGroup", true)

		--local bc, balpha, txtc
		--if BigWigsColors and type(BigWigsColors) == "table" then
		--	if type(otherc) ~= "boolean" or not otherc then c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 = BigWigsColors:BarColor(time) end
		--	bc, balpha, txtc = BigWigsColors.db.profile.bgc, BigWigsColors.db.profile.bga, BigWigsColors.db.profile.txtc
		--end

		self:RegisterCandyBar(id, time, text, icon, color)
		self:RegisterCandyBarWithGroup(id, "BigWigsEnrageGroup")
		self:SetCandyBarTexture(id, surface:Fetch(self.db.profile.texture))
		--if bc then self:SetCandyBarBackgroundColor(id, bc, balpha) end
		--if txtc then self:SetCandyBarTextColor(id, txtc) end

		self:SetCandyBarScale(id, self.db.profile.scale or 1)
		self:SetCandyBarFade(id, .5)
		self:StartCandyBar(id, true)
		
		return id
	end
	
	return false
end


function BigWigsEnrage:UNIT_HEALTH(msg)
	if UnitName(msg) == self.bossName then
		local health = UnitHealth(msg) -- / UnitMaxHealth(msg) * 100
		self:SetHPBar(health)
	end
end


function BigWigsEnrage:BigWigs_ShowAnchors()
	self.frames.anchor:Show()
end


function BigWigsEnrage:BigWigs_HideAnchors()
	self.frames.anchor:Hide()
end




------------------------------
--      Slash Handlers      --
------------------------------

function BigWigsEnrage:SetScale(msg, supressreport)
	local scale = tonumber(msg)
	if scale and scale >= minscale and scale <= maxscale then
		self.db.profile.scale = scale
		if not supressreport then self.core:Print(L["Scale is set to %s"], scale) end
	end
end


------------------------------
--    Create the Anchor     --
------------------------------

function BigWigsEnrage:SetupFrames()
	local f, t	

	f, _, _ = GameFontNormal:GetFont()

	self.frames = {}
	self.frames.anchor = CreateFrame("Frame", "BigWigsEnrageAnchor", UIParent)
	self.frames.anchor.owner = self
	self.frames.anchor:Hide()

	self.frames.anchor:SetWidth(175)
	self.frames.anchor:SetHeight(75)
	self.frames.anchor:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
		})
	self.frames.anchor:SetBackdropBorderColor(.5, .5, .5)
	self.frames.anchor:SetBackdropColor(0,0,0)
	self.frames.anchor:ClearAllPoints()
	self.frames.anchor:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	self.frames.anchor:EnableMouse(true)
	self.frames.anchor:RegisterForDrag("LeftButton")
	self.frames.anchor:SetMovable(true)
	self.frames.anchor:SetScript("OnDragStart", function() this:StartMoving() end)
	self.frames.anchor:SetScript("OnDragStop", function() this:StopMovingOrSizing() this.owner:SavePosition() end)


	self.frames.cfade = self.frames.anchor:CreateTexture(nil, "BORDER")
	self.frames.cfade:SetWidth(169)
	self.frames.cfade:SetHeight(25)
	self.frames.cfade:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	self.frames.cfade:SetPoint("TOP", self.frames.anchor, "TOP", 0, -4)
	self.frames.cfade:SetBlendMode("ADD")
	self.frames.cfade:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .25, .25, .25, 1)
	self.frames.anchor.Fade = self.frames.fade

	self.frames.cheader = self.frames.anchor:CreateFontString(nil,"OVERLAY")
	self.frames.cheader:SetFont(f, 14)
	self.frames.cheader:SetWidth(150)
	self.frames.cheader:SetText(L["Enrage"])
	self.frames.cheader:SetTextColor(1, .8, 0)
	self.frames.cheader:ClearAllPoints()
	self.frames.cheader:SetPoint("TOP", self.frames.anchor, "TOP", 0, -10)
	
	self.frames.leftbutton = CreateFrame("Button", nil, self.frames.anchor)
	self.frames.leftbutton.owner = self
	self.frames.leftbutton:SetWidth(40)
	self.frames.leftbutton:SetHeight(25)
	self.frames.leftbutton:SetPoint("RIGHT", self.frames.anchor, "CENTER", -10, -15)
	self.frames.leftbutton:SetScript( "OnClick", function()  self:TriggerEvent("BigWigs_Test") end )

	
	t = self.frames.leftbutton:CreateTexture()
	t:SetWidth(50)
	t:SetHeight(32)
	t:SetPoint("CENTER", self.frames.leftbutton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	self.frames.leftbutton:SetNormalTexture(t)

	t = self.frames.leftbutton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.leftbutton)
	self.frames.leftbutton:SetPushedTexture(t)
	
	t = self.frames.leftbutton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.leftbutton)
	t:SetBlendMode("ADD")
	self.frames.leftbutton:SetHighlightTexture(t)
	self.frames.leftbuttontext = self.frames.leftbutton:CreateFontString(nil,"OVERLAY")
	self.frames.leftbuttontext:SetFontObject(GameFontHighlight)
	self.frames.leftbuttontext:SetText(L["Test"])
	self.frames.leftbuttontext:SetAllPoints(self.frames.leftbutton)
    
	self.frames.rightbutton = CreateFrame("Button", nil, self.frames.anchor)
	self.frames.rightbutton.owner = self
	self.frames.rightbutton:SetWidth(40)
	self.frames.rightbutton:SetHeight(25)
	self.frames.rightbutton:SetPoint("LEFT", self.frames.anchor, "CENTER", 10, -15)
	self.frames.rightbutton:SetScript( "OnClick", function() self:BigWigs_HideAnchors() end )
    

	
	t = self.frames.rightbutton:CreateTexture()
	t:SetWidth(50)
	t:SetHeight(32)
	t:SetPoint("CENTER", self.frames.rightbutton, "CENTER")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	self.frames.rightbutton:SetNormalTexture(t)

	t = self.frames.rightbutton:CreateTexture(nil, "BACKGROUND")
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.rightbutton)
	self.frames.rightbutton:SetPushedTexture(t)
	
	t = self.frames.rightbutton:CreateTexture()
	t:SetTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	t:SetTexCoord(0, 0.625, 0, 0.6875)
	t:SetAllPoints(self.frames.rightbutton)
	t:SetBlendMode("ADD")
	self.frames.rightbutton:SetHighlightTexture(t)
	self.frames.rightbuttontext = self.frames.rightbutton:CreateFontString(nil,"OVERLAY")
	self.frames.rightbuttontext:SetFontObject(GameFontHighlight)
	self.frames.rightbuttontext:SetText(L["Close"])
	self.frames.rightbuttontext:SetAllPoints(self.frames.rightbutton)

	self:RestorePosition()
end


function BigWigsEnrage:SavePosition()
	local f = self.frames.anchor
	local s = f:GetEffectiveScale()
		
	self.db.profile.posx = f:GetLeft() * s
	self.db.profile.posy = f:GetTop() * s	
end


function BigWigsEnrage:RestorePosition()
	local x = self.db.profile.posx
	local y = self.db.profile.posy
		
	if not x or not y then return end
				
	local f = self.frames.anchor
	local s = f:GetEffectiveScale()

	f:ClearAllPoints()
	f:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / s, y / s)
end
