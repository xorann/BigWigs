--[[
    by LYQ(Virose / MOUZU)
    https://github.com/MOUZU/BigWigs
    
    This is a small plugin which is inspired by Sulfuras of Mesmerize (Warsong/Feenix).
    It gives the RaidOfficers the opportunity to "disconnect" RaidMembers who are AFK flagged.

    The initial version of Sulfuras could be abused to kick random players in your or other raidgroups
    and therefore this feature was seen as abuse but the intent of it isn't that wrong after all.

    I therefore recreated the feature using his idea and implemented it with a couple of
    safety measures from my side.
--]]

------------------------------
--      Are you local?      --
------------------------------
local lastAFKickRequest = nil


----------------------------
--      Localization      --
----------------------------


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAFKick = BigWigs:NewModule("AFKick")

------------------------------
--      Initialization      --
------------------------------

function BigWigsAFKick:OnEnable()
    self:RegisterEvent("BigWigs_RecvSync")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsAFKick:BigWigs_RecvSync(sync, rest, nick)
    if sync == "AFKick" and rest and rest == UnitName("player") then
        -- Check the author of this Sync first
        -- only RaidOfficers are allowed to use this function
        for i=1, MAX_RAID_MEMBERS do
            local name, rank = GetRaidRosterInfo(i)
            if name and name == nick then
                if rank > 0 then
                    -- the author is at least assistant
                    break
                else
                    -- the author is a fucktard trying to abuse my system
                    return
                end
            end
        end
        
        -- if we're here the authorization check was successful
    end
end

function BigWigsAFKick:IsAfk()
    -- how do I determine if the player is really afk?
    -- simply checking for the afk flag?
    -- maybe afk flag enables a 40sec timer in which the player can return and cancel the process
    -- so after 40s the Logout window shall appear which again has a 20s timer so that the player
    -- has 1min in total to react and cancel the process of logging out
    return false
end