--- @class IdleDefenseModeData
IdleDefenseModeData = Class(IdleDefenseModeData)

--- @return void
function IdleDefenseModeData:Ctor()
    ---@type RewardInBound
    self.reward = nil
    ---@type LandIdleRewardItemConfig
    self.landIdleRewardItemConfig = nil
    ---@type number
    self.lastTimeClaim = nil
end

--- @return void
function IdleDefenseModeData:GetNumberReward(_serverTime)
    local serverTime = _serverTime
    if serverTime == nil then
        serverTime = zg.timeMgr:GetServerTime()
    end
    return self.reward.number + self.landIdleRewardItemConfig.rewardInBound.number *
            math.min(self.landIdleRewardItemConfig.maxIdleNumber,
                    math.floor(math.max(0,serverTime - self.lastTimeClaim - 1)/self.landIdleRewardItemConfig.intervalTime))
end

--- @return boolean
function IdleDefenseModeData:IsFull(_serverTime)
    local serverTime = _serverTime
    if serverTime == nil then
        serverTime = zg.timeMgr:GetServerTime()
    end
    return math.max(0,serverTime - self.lastTimeClaim - 1)/self.landIdleRewardItemConfig.intervalTime >= self.landIdleRewardItemConfig.maxIdleNumber
end

--- @return number
function IdleDefenseModeData:GetProgress(_serverTime)
    local serverTime = _serverTime
    if serverTime == nil then
        serverTime = zg.timeMgr:GetServerTime()
    end
    if self:IsFull(serverTime) then
        return 1
    else
        return (math.max(0,serverTime - self.lastTimeClaim - 1) % self.landIdleRewardItemConfig.intervalTime) / self.landIdleRewardItemConfig.intervalTime
    end
end

--- @return boolean
function IdleDefenseModeData:Clear(_serverTime)
    local serverTime = _serverTime
    if serverTime == nil then
        serverTime = zg.timeMgr:GetServerTime()
    end
    self.reward.number = 0
    self.lastTimeClaim = serverTime
  --  XDebug.Log("Clear" .. serverTime)
end

--- @return boolean
function IdleDefenseModeData:CanClaim(_serverTime)
    return self:GetNumberReward(_serverTime) > 0
end