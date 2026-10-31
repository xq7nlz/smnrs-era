require "lua.client.core.network.event.eventXmasModel.EventIgnatiusRankingInBound"
require "lua.client.core.network.playerData.common.RankingItemInBound2"

--- @class EventNewHeroBossRankingInBound : EventIgnatiusRankingInBound
EventNewHeroBossRankingInBound = Class(EventNewHeroBossRankingInBound, EventIgnatiusRankingInBound)

function EventNewHeroBossRankingInBound:Ctor()
    EventIgnatiusRankingInBound.Ctor(self)
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventNewHeroBossRankingInBound:ReadBuffer(buffer)
    --- @type List
    self.listOfStatistics = List()
    --- @type number
    local sizeOfList = buffer:GetByte()
    for _ = 1, sizeOfList do
        local itemData = RankingItemInBound2.CreateByBuffer(buffer)
        self.listOfStatistics:Add(itemData)
        if itemData.id == PlayerSettingData.playerId then
            self.selfScore = itemData.score
        end
    end
    self.selfRankingOrder = buffer:GetInt()
    self.selfScore = buffer:GetInt()
    self.power = buffer:GetLong()
    self:SortRanking()
    --- @type number
    self.lastTimeRequest = zg.timeMgr:GetServerTime()
end

function EventNewHeroBossRankingInBound:GetUserRankingItemInBound()
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    local userRankingItemInBound = RankingItemInBound2()
    userRankingItemInBound.id = PlayerSettingData.playerId
    userRankingItemInBound.serverId = PlayerSettingData.serverId
    userRankingItemInBound.name = basicInfo.name
    userRankingItemInBound.score = self.selfScore
    userRankingItemInBound.createdTime = nil
    userRankingItemInBound.avatar = basicInfo.avatarData:GetMyPlayerAvatar()
    userRankingItemInBound.level = basicInfo.level
    userRankingItemInBound.power = self.power
    return userRankingItemInBound
end

function EventNewHeroBossRankingInBound.RequestRanking(onSuccess)
    ----- @type EventNewHeroBossChallengeModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.eventRankingInBound == nil then
            eventModel.eventRankingInBound = EventNewHeroBossRankingInBound()
        end
        if eventModel.eventRankingInBound:IsAvailableToRequest() == true then
            local onReceived = function(result)
                --- @param buffer UnifiedNetwork_ByteBuf
                local onBufferReading = function(buffer)
                    eventModel.eventRankingInBound:ReadBuffer(buffer)
                end
                NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
            end
            NetworkUtils.Request(OpCode.EVENT_NEW_HERO_BOSS_RANKING_GET, UnknownOutBound.CreateInstance(PutMethod.Long, zg.timeMgr:GetServerTime()), onReceived)
        else
            onSuccess()
        end
    end
end