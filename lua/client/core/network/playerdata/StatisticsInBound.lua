--- @class StatisticsInBound
StatisticsInBound = Class(StatisticsInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function StatisticsInBound:ReadBuffer(buffer)
    ---@type number
    self.totalOnlineTime = buffer:GetLong()
    ---@type number
    self.numberLogin = buffer:GetInt()
    ---@type number
    self.totalSpeedUp = buffer:GetLong()

    self:InitTracking()
end

function StatisticsInBound:InitTracking()
    TrackingUtils.AddFirebaseProperty(FBProperties.ONLINE_TIME, self.totalOnlineTime)
end

--- @return void
function StatisticsInBound:ToString()
    return string.format("StatisticsInBound: \n totalOnlineTime: %s \n numberLogin: %s \n totalSpeedUp: %s",
            TimeUtils.GetDeltaTime(self.totalOnlineTime),
            self.numberLogin,
            TimeUtils.GetDeltaTime(self.totalSpeedUp))
end