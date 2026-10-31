require("lua.client.core.network.event.eventLunarNewYear.EventLunarBossRankingData")
--- @class EventLunarBossRankingInBound
EventLunarBossRankingInBound = Class(EventLunarBossRankingInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarBossRankingInBound:Ctor(buffer)
    if buffer ~= nil then
        --- @type List
        self.listRanking = NetworkUtils.GetListDataInBound(buffer, EventLunarBossRankingData)
        --- @type number
        self.orderRanking = buffer:GetInt()
        --XDebug.Log(self.listRanking:Count())
        --XDebug.Log(self.orderRanking)
    else
        --- @type List
        self.listRanking = List()
    end
    --- @type number
    self.lastRequest = zg.timeMgr:GetServerTime()
end