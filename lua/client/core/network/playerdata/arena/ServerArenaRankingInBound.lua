require "lua.client.core.network.playerData.arena.SingleArenaRanking"

--- @class ServerArenaRankingInBound
ServerArenaRankingInBound = Class(ServerArenaRankingInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ServerArenaRankingInBound:ReadBuffer(buffer)
    --- @type List
    self.listRanking = NetworkUtils.GetListDataInBound(buffer, SingleArenaRanking)
    ---@type string
    self.currentRanking = nil

    if self.listRanking:Count() > 0 then
        local serverPlayerRanking = buffer:GetInt()
        --- @param v SingleArenaRanking
        for k, v in pairs(self.listRanking:GetItems()) do
            if v.playerId == PlayerSettingData.playerId then
                self.currentRanking = k
                break
            end
        end
        if self.currentRanking == nil then
            self.currentRanking = math.max(1, serverPlayerRanking + 1)
        end
    end
end

--- @param key string
function ServerArenaRankingInBound:UpdateInfoByKey(key, newValue)
    for i = 1, self.listRanking:Count() do
        --- @type SingleArenaRanking
        local singleArenaRanking = self.listRanking:Get(i)
        if singleArenaRanking.playerId == PlayerSettingData.playerId then
            singleArenaRanking:UpdateInfoByKey(key, newValue)
            break
        end
    end
end