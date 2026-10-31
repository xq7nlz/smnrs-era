require "lua.client.core.network.friend.BossStatistics"

--- @class BossStatisticsInBound
BossStatisticsInBound = Class(BossStatisticsInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function BossStatisticsInBound:Ctor(buffer)
    ---@type List
    self.listBossStatistics = NetworkUtils.GetListDataInBound(buffer, BossStatistics.CreateByBuffer)
    self.listBossStatistics:SortWithMethod(BossStatistics.BossStatisticsSortDamage)
    ---@type number
    self.lastRequest = zg.timeMgr:GetServerTime()
end