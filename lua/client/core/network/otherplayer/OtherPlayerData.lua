--- @class OtherPlayerData
OtherPlayerData = Class(OtherPlayerData)

--- @return void
function OtherPlayerData:Ctor()
    --- @type number
    self.friendId = nil

    ---@type OtherPlayerInfoInBound
    self.otherPlayerInfoInBound = nil
    ---@type number
    self.lastTimeRequestPlayerInfo = nil
end

--- @return OtherPlayerData
--- @param onSuccess function
function OtherPlayerData:GetOtherPlayerInfoInBound(onSuccess)
    local callback = function()
        if self.otherPlayerInfoInBound ~= nil then
            --self.lastTimeRequestPlayerInfo = zg.timeMgr:GetServerTime()
            if onSuccess ~= nil then
                onSuccess(self.otherPlayerInfoInBound)
            end
        end
    end
    local requestArenaFormation = function()
        NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(self.friendId, GameMode.ARENA, function (_otherPlayerInfoInBound)
            self.otherPlayerInfoInBound = _otherPlayerInfoInBound
            callback()
        end, function()
            self.otherPlayerInfoInBound = nil
            callback()
        end)
    end
    --if self.otherPlayerInfoInBound == nil or self.lastTimeRequestPlayerInfo == nil or zg.timeMgr:GetServerTime() - self.lastTimeRequestPlayerInfo > 10 then
        NetworkUtils.SilentRequestOtherPlayerInfoInBoundByGameMode(self.friendId, GameMode.FRIEND_BATTLE, function (_otherPlayerInfoInBound)
            self.otherPlayerInfoInBound = _otherPlayerInfoInBound
            if self.otherPlayerInfoInBound.detailsTeamFormation.frontLineDict:Count() == 0 and self.otherPlayerInfoInBound.detailsTeamFormation.backLineDict:Count() == 0 then
                requestArenaFormation()
            else
                callback()
            end

        end, function ()
            self.otherPlayerInfoInBound = nil
            requestArenaFormation()
        end)
    --else
    --    callback()
    --end
end