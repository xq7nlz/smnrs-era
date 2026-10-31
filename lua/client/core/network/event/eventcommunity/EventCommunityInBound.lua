--- @class EventCommunityInBound
EventCommunityInBound = Class(EventCommunityInBound)

function EventCommunityInBound:Ctor()
    --- @type Dictionary
    self.communityDataDict = nil
end

function EventCommunityInBound.ValidateData(callback, forceUpdate)
    local eventCommunityInBound = zg.playerData:GetEvents().eventCommunityInBound
    if forceUpdate or eventCommunityInBound.communityDataDict == nil then
        eventCommunityInBound.communityDataDict = Dictionary()
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                local size = buffer:GetByte()
                for _ = 1, size do
                    eventCommunityInBound.communityDataDict:Add(buffer:GetByte(), buffer:GetBool())
                end
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, callback, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.EVENT_COMMUNITY_DATA_GET, nil, onReceived)
    else
        callback()
    end
end

function EventCommunityInBound:IsAchievedCommunity(eventTimeType)
    if self.communityDataDict and self.communityDataDict:IsContainKey(eventTimeType) then
        return self.communityDataDict:Get(eventTimeType)
    end
    return false
end

function EventCommunityInBound:RequestAchievedCommunity(eventTimeType)
    if self:IsAchievedCommunity(eventTimeType) then
        return
    end
    if self.communityDataDict then
        self.communityDataDict:Add(eventTimeType, true)
    end

    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            if rewardList:Count() > 0 then
                PopupUtils.ClaimAndShowRewardList(rewardList)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, nil, nil)
    end
    NetworkUtils.Request(OpCode.EVENT_COMMUNITY_REWARD_CLAIM, UnknownOutBound.CreateInstance(PutMethod.Byte, eventTimeType), onReceived)
end

--- @return boolean
function EventCommunityInBound:HasCommunityNotification(eventTimeType)
    if self:IsAchievedCommunity(eventTimeType) == false then
        return true
    end
    local eventInBound = zg.playerData:GetEvents()
    --- @type EventPopupModel
    local eventPopupModel = eventInBound:GetEvent(eventTimeType)
    if eventPopupModel == nil or eventPopupModel:IsOpening() == false then
        return false
    end
    local remoteConfigData = zg.playerData.remoteConfig
    local endTime = eventPopupModel.timeData.endTime
    if eventTimeType == EventTimeType.EVENT_FACEBOOK_COMMUNITY then
        return remoteConfigData.checkCommunityFacebook ~= endTime
    elseif eventTimeType == EventTimeType.EVENT_TWITTER_COMMUNITY then
        return remoteConfigData.checkCommunityTwitter ~= endTime
    elseif eventTimeType == EventTimeType.EVENT_INSTAGRAM_COMMUNITY then
        return remoteConfigData.checkCommunityInstagram ~= endTime
    elseif eventTimeType == EventTimeType.EVENT_DISCORD_COMMUNITY then
        return remoteConfigData.checkCommunityDiscord ~= endTime
    elseif eventTimeType == EventTimeType.EVENT_REDDIT_COMMUNITY then
        --return remoteConfigData.checkCommunityReddit ~= endTime
        return false
    end
    return false
end

function EventCommunityInBound:SetCheckInCommunity(eventTimeType)
    local eventInBound = zg.playerData:GetEvents()
    --- @type EventPopupModel
    local eventPopupModel = eventInBound:GetEvent(eventTimeType)
    if eventPopupModel == nil or eventPopupModel:IsOpening() == false then
        return
    end
    local remoteConfigData = zg.playerData.remoteConfig
    local endTime = eventPopupModel.timeData.endTime
    if eventTimeType == EventTimeType.EVENT_FACEBOOK_COMMUNITY then
        remoteConfigData.checkCommunityFacebook = endTime
    elseif eventTimeType == EventTimeType.EVENT_TWITTER_COMMUNITY then
        remoteConfigData.checkCommunityTwitter = endTime
    elseif eventTimeType == EventTimeType.EVENT_INSTAGRAM_COMMUNITY then
        remoteConfigData.checkCommunityInstagram = endTime
    elseif eventTimeType == EventTimeType.EVENT_REDDIT_COMMUNITY then
        --remoteConfigData.checkCommunityReddit = endTime
    elseif eventTimeType == EventTimeType.EVENT_DISCORD_COMMUNITY then
        remoteConfigData.checkCommunityDiscord = endTime
    end
    zg.playerData:SaveRemoteConfig()
end

function EventCommunityInBound:HasNotification()
    return self:HasCommunityNotification(EventTimeType.EVENT_FACEBOOK_COMMUNITY)
            or self:HasCommunityNotification(EventTimeType.EVENT_TWITTER_COMMUNITY)
            or self:HasCommunityNotification(EventTimeType.EVENT_INSTAGRAM_COMMUNITY)
            or self:HasCommunityNotification(EventTimeType.EVENT_DISCORD_COMMUNITY)
            --or self:HasCommunityNotification(EventTimeType.EVENT_REDDIT_COMMUNITY)
end

--- @return RewardInBound
function EventCommunityInBound:GetRewardConfig()
    if self.reward == nil then
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile("csv/event/event_community/instant_reward.csv")
        self.reward = RewardInBound.CreateByParams(parsedData[1])
    end
    return self.reward
end

