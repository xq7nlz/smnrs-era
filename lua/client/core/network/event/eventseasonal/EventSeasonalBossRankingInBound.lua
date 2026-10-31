--- @class EventSeasonalBossRankingInBound
EventSeasonalBossRankingInBound = Class(EventSeasonalBossRankingInBound)

function EventSeasonalBossRankingInBound:Ctor()
    --- @type List -- SingleArenaRanking
    self.listRanking = List()
    ---@type number
    self.rankingOrder = -2
    ---@type number
    self.score = 0
end

--- @return void
--- @param onSuccess function
function EventSeasonalBossRankingInBound.GetLeaderBoard(onSuccess)
    ----- @type EventSeasonalModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SEASONAL)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.bossRankingInBound == nil then
            eventModel.bossRankingInBound = EventSeasonalBossRankingInBound()
        end
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            require "lua.client.core.network.event.eventKazetsu.KazetsuRanking"
            --- @type List
            eventModel.bossRankingInBound.listRanking = NetworkUtils.GetListDataInBound(buffer, KazetsuRanking)
            if (eventModel.bossRankingInBound.listRanking:Count() == 0) then
                return
            end
            eventModel.bossRankingInBound.rankingOrder = buffer:GetInt()
            eventModel.bossRankingInBound.score = buffer:GetLong()
        end
        local callbackSuccess = function()
            onSuccess(eventModel)
        end
        local callbackFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_BOSS_RANKING_GET, nil, callbackSuccess, callbackFailed, onBufferReading)
    end
end