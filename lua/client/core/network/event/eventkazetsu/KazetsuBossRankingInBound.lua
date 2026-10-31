--- @class KazetsuBossRankingInBound
KazetsuBossRankingInBound = Class(KazetsuBossRankingInBound)

function KazetsuBossRankingInBound:Ctor()
    --- @type List -- SingleArenaRanking
    self.listRanking = List()
    ---@type number
    self.rankingOrder = -2
    ---@type number
    self.score = 0
    ---@type number
    self.power = 0
end

--- @return void
--- @param listHeroSelected List<number>
--- @param onSuccess function
--- Send list hero with element is selectionId to server
function KazetsuBossRankingInBound.GetLeaderBoard(onSuccess)
    ----- @type EventKazetsuModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_KAZETSU)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.KazetsuBossRankingInBound == nil then
            eventModel.KazetsuBossRankingInBound = KazetsuBossRankingInBound()
        end
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                require "lua.client.core.network.event.eventKazetsu.KazetsuRanking"
                --- @type List
                eventModel.KazetsuBossRankingInBound.listRanking = NetworkUtils.GetListDataInBound(buffer,
                        KazetsuRanking)
                if (eventModel.KazetsuBossRankingInBound.listRanking:Count() == 0) then
                    return
                end
                eventModel.KazetsuBossRankingInBound.rankingOrder = buffer:GetInt()
                if (eventModel.KazetsuBossRankingInBound.rankingOrder == nil) then
                else
                end
                eventModel.KazetsuBossRankingInBound.score = buffer:GetLong()
            end
            local onSuccess = function()
                onSuccess(eventModel)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.EVENT_KAZETSU_BOSS_RANKING_GET ,nil, onReceived)
    end
end