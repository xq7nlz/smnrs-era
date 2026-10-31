require "lua.client.core.network.playerData.common.DynamicRewardInBound"

--- @class PlayerDailyDataInBound
PlayerDailyDataInBound = Class(PlayerDailyDataInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerDailyDataInBound:ReadBuffer(buffer)
    ---@type List
    self.listItem = NetworkUtils.GetRewardInBoundList(buffer)
    ---@type number
    self.claimDay = buffer:GetByte()
    ---@type number
    self.loginDay = buffer:GetByte()
    --XDebug.Log("PlayerDailyDataInBound" .. self:ToString())
    --for i, v in pairs(self.listItem:GetItems()) do
    --    XDebug.Log("PlayerDailyDataInBound.RewardInBound" ..LogUtils.ToDetail(v))
    --end
    --XDebug.Log("PlayerDailyDataInBound.RewardInBound" ..LogUtils.ToDetail(self))
    self:InitTracking()
end

function PlayerDailyDataInBound:InitTracking()
    TrackingUtils.AddFirebaseProperty(FBProperties.NUMBER_DAY_PLAY, self.loginDay)
end

function PlayerDailyDataInBound:CanClaim()
    return  self.loginDay > self.claimDay
end

--- @return void
function PlayerDailyDataInBound:ToString()
    return LogUtils.ToDetail(self)
end