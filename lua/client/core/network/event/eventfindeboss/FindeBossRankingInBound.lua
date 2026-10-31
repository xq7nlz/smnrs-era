--- @class FindeBossRankingInBound
FindeBossRankingInBound = Class(FindeBossRankingInBound)

function FindeBossRankingInBound:Ctor()
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
function FindeBossRankingInBound.GetLeaderBoard(onSuccess)
    ----- @type EventFindeBossModel
    local eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_FINDE_BOSS)
    local isOpening = eventModel ~= nil and eventModel.timeData:IsOpening()
    if isOpening == true then
        if eventModel.findeBossRankingInBound == nil then
            eventModel.findeBossRankingInBound = FindeBossRankingInBound()
        end
        local onReceived = function(result)
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                require "lua.client.core.network.event.eventKazetsu.KazetsuRanking"
                --- @type List
                eventModel.findeBossRankingInBound.listRanking = NetworkUtils.GetListDataInBound(buffer,
                        KazetsuRanking)
                if (eventModel.findeBossRankingInBound.listRanking:Count() == 0) then
                    return
                end
                eventModel.findeBossRankingInBound.rankingOrder = buffer:GetInt()
                if (eventModel.findeBossRankingInBound.rankingOrder == nil) then
                else
                end
                eventModel.findeBossRankingInBound.score = buffer:GetLong()
            end
            local onSuccess = function()
                onSuccess(eventModel)
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
        end
        NetworkUtils.Request(OpCode.EVENT_FINDE_BOSS_RANKING_GET ,nil, onReceived)
    end
end