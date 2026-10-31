--- @class EventReleaseFestivalModel : EventPopupModel
EventReleaseFestivalModel = Class(EventReleaseFestivalModel, EventPopupModel)

function EventReleaseFestivalModel:Ctor()
    EventPopupModel.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventReleaseFestivalModel:ReadData(buffer)
    EventPopupModel.ReadData(self, buffer)
    if self.hasData == true then
        self.numberOfPlayer = buffer:GetLong()
        local sizeOfClaimedRewardMap = buffer:GetByte()
        self.claimedRewardByNumberPlayerDict = Dictionary()
        for _ = 1, sizeOfClaimedRewardMap do
            local numberPlayer = buffer:GetLong()
            local isClaimed = buffer:GetBool()
            self.claimedRewardByNumberPlayerDict:Add(numberPlayer, isClaimed)
        end
    end
end

--- @return boolean
function EventReleaseFestivalModel:HasNotification()
    if self.hasData ~= true then
        return false
    end
    --- @type EventReleaseFestivalConfig
    local eventReleaseFestivalConfig = self:GetConfig()
    for i = 1, eventReleaseFestivalConfig:GetConfig():Count() do
        --- @type {numberPlayer : number, rewardInBound : RewardInBound}
        local itemConfig = eventReleaseFestivalConfig:GetItemConfigByIndex(i)
        local isClaimed = self:GetClaimStatusByMilestone(itemConfig.numberPlayer)
        if isClaimed == false and self.numberOfPlayer >= itemConfig.numberPlayer then
            return true
        end
    end
    return false
end

--- @return EventReleaseFestivalConfig
function EventReleaseFestivalModel:GetConfig()
    return EventPopupModel.GetConfig(self)
end

--- @return boolean
--- @param milestone number
function EventReleaseFestivalModel:GetClaimStatusByMilestone(milestone)
    if self.hasData == true then
        local isClaimed = self.claimedRewardByNumberPlayerDict:Get(milestone)
        if isClaimed == nil then
            isClaimed = false
        end
        return isClaimed
    end
    return false
end

--- @param milestone number
function EventReleaseFestivalModel:ClaimMilestoneByMilestone(milestone)
    self.claimedRewardByNumberPlayerDict:Add(milestone, true)
end

--- @param numberOfPlayerMilestone number
--- @param onSuccess function
function EventReleaseFestivalModel.RequestClaim(numberOfPlayerMilestone, onSuccess)
    local onReceived = function(result)
        NetworkUtils.ExecuteResult(result, nil, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    NetworkUtils.Request(OpCode.EVENT_RELEASE_FESTIVAL_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Long, numberOfPlayerMilestone), onReceived)
end

--- @return boolean
function EventReleaseFestivalModel:IsAvailableToRequest()
    return self.hasData == true and (self.lastTimeRequest == nil or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.SecondAMin)
end
