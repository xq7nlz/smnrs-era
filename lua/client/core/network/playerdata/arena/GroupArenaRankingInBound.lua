require "lua.client.core.network.playerData.arena.SingleArenaRanking"

--- @class GroupArenaRankingInBound
GroupArenaRankingInBound = Class(GroupArenaRankingInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function GroupArenaRankingInBound:ReadBuffer(buffer)
    --- @type List
    self.listRanking = NetworkUtils.GetListDataInBound(buffer, SingleArenaRanking)
    if self.listRanking:Count() > 0 then
        --- @type number
        self.currentRanking = buffer:GetInt()
        --- @type number
        self.rankType = buffer:GetByte()
    end
end

--- @param key string
function GroupArenaRankingInBound:UpdateInfoByKey(key, newValue)
    for i = 1, self.listRanking:Count() do
        --- @type SingleArenaRanking
        local singleArenaRanking = self.listRanking:Get(i)
        if singleArenaRanking.playerId == PlayerSettingData.playerId then
            singleArenaRanking:UpdateInfoByKey(key, newValue)
            break
        end
    end
end