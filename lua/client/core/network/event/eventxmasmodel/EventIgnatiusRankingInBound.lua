require "lua.client.core.network.playerData.common.RankingItemInBound"

--- @class EventIgnatiusRankingInBound
EventIgnatiusRankingInBound = Class(EventIgnatiusRankingInBound)

function EventIgnatiusRankingInBound:Ctor()
    --- @type number
    self.selfRankingOrder = nil
    --- @type number
    self.selfScore = nil
    --- @type List --<RankingItemInBound>
    self.listOfStatistics = List()
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventIgnatiusRankingInBound:ReadBuffer(buffer)
    --- @type List
    self.listOfStatistics = List()
    --- @type number
    local sizeOfList = buffer:GetByte()
    for _ = 1, sizeOfList do
        local itemData = RankingItemInBound.CreateByBuffer(buffer)
        self.listOfStatistics:Add(itemData)
        if itemData.id == PlayerSettingData.playerId then
            self.selfScore = itemData.score
        end
    end
    self.selfRankingOrder = buffer:GetInt()
    self.selfScore = buffer:GetInt()
    self:SortRanking()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function EventIgnatiusRankingInBound:IsAvailableToRequest()
    local result = self.lastTimeRequest == nil
            or (zg.timeMgr:GetServerTime() - self.lastTimeRequest) > TimeUtils.SecondAMin
    return result
end

function EventIgnatiusRankingInBound:SortRanking()
    self.listOfStatistics:Sort(self, self.SortHeroMethod)
    for i = 1, self.listOfStatistics:Count() do
        --- @type RankingItemInBound
        local statistics = self.listOfStatistics:Get(i)
        if statistics.id == PlayerSettingData.playerId then
            self.selfRankingOrder = i
            return
        end
    end
    --self.selfRankingOrder = nil
end

function EventIgnatiusRankingInBound:GetUserScore()
    return self.selfScore
end

function EventIgnatiusRankingInBound:GetUserRankingItemInBound()
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    local userRankingItemInBound = RankingItemInBound()
    userRankingItemInBound.id = PlayerSettingData.playerId
    userRankingItemInBound.serverId = PlayerSettingData.serverId
    userRankingItemInBound.name = basicInfo.name
    userRankingItemInBound.score = self.selfScore
    userRankingItemInBound.createdTime = nil
    userRankingItemInBound.avatar = basicInfo.avatarData:GetMyPlayerAvatar()
    userRankingItemInBound.level = basicInfo.level
    return userRankingItemInBound
end

--- @return number
--- @param x RankingItemInBound
--- @param y RankingItemInBound
function EventIgnatiusRankingInBound:SortHeroMethod(x, y)
    if x.score > y.score then
        return -1
    elseif x.score < y.score then
        return 1
    else
        if x.createdTime > y.createdTime then
            return -1
        else
            return 1
        end
    end
end

function EventIgnatiusRankingInBound.RequestRanking(onSuccess)
    ----- @type EventXmasModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.eventIgnatiusRankingInBound == nil then
            eventModel.eventIgnatiusRankingInBound = EventIgnatiusRankingInBound()
        end
        if eventModel.eventIgnatiusRankingInBound:IsAvailableToRequest() == true then
            local onReceived = function(result)
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    eventModel.eventIgnatiusRankingInBound:ReadBuffer(buffer)
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.EVENT_CHRISTMAS_RANKING_GET, UnknownOutBound.CreateInstance(PutMethod.Long, zg.timeMgr:GetServerTime()), onReceived)
        else
            onSuccess()
        end
    end
end