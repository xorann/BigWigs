local bossName = BigWigs.bossmods.aq20.rajaxx
local serverProjectName = "Classic-WoW"
if not BigWigs:IsServerRegisteredForServerProject(serverProjectName) or not BigWigs:IsBossSupportedByServerProject(bossName, serverProjectName) then
	return
end

--BigWigs:Print("classic-wow " .. bossName)


------------------------------
-- Variables     			--
------------------------------

local module = BigWigs:GetModule(AceLibrary("Babble-Boss-2.2")[bossName])
local L = BigWigs.i18n[bossName]
local timer = module.timer
local icon = module.icon
local syncName = module.syncName

-- module variables
module.revision = 20014 -- To be overridden by the module!

-- override timers if necessary
--timer.berserk = 300


------------------------------
--      Initialization      --
------------------------------

--module:RegisterYellEngage(L["trigger1"])

-- called after module is enabled
function module:OnEnable()	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

-- called after module is enabled and after each wipe
function module:OnSetup()
end

-- called after boss is engaged
function module:OnEngage()
    --wave = 1
end

-- called after boss is disengaged (wipe(retreat) or victory)
function module:OnDisengage()
end


------------------------------
--      Event Handlers      --
------------------------------
function module:CheckForWipe()    
    -- ignore wipe check
end

function module:CHAT_MSG_MONSTER_YELL(msg)
    --if string.find(msg, L["trigger1"]) then
        
    
	--[[if self.db.profile.wave and msg and self.warnsets[msg] then
		self:Message(self.warnsets[msg], "Urgent")
        
        local i = tonumber(string.sub(L:GetReverseTranslation(self.warnsets[msg]), 5))
        if i == 0 then
            i = 1
        end        
        wave = i
        
        self:RemoveBar(L["warn" .. i])
        if i < 8 then
            self:Bar(L["warn" .. i+1], timer.wave, icon.wave)
        end
	end
    
    if self.db.profile.wave and msg and string.find(msg, L["trigger2_2"]) and wave == 1 then -- but not "Kill first ..."
        wave = 2
        self:RemoveBar(L["warn2"])
        self:Bar(L["warn3"], timer.wave - 5, icon.wave) -- kill yell around 5s later
    end]]
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

	module:OnDisengage()
	module:TestDisable()
end

-- visual test
function module:TestVisual()
	BigWigs:Print(self:ToString() .. " TestVisual not yet implemented")
end
