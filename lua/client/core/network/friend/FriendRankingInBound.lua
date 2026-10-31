require "lua.client.core.network.playerData.common.RankingDataInBound"

--- @class FriendRankingInBound : RankingDataInBound
FriendRankingInBound = Class(FriendRankingInBound, RankingDataInBound)

function FriendRankingInBound:Ctor()
    RankingDataInBound.Ctor(self, PlayerDataMethod.FRIEND_RANKING)
    --- @type RankingItemInBound
    self.selfRankingItem = nil
end

--- @param buffer UnifiedNetwork_ByteBuf
function FriendRankingInBound:ReadBuffer(buffer)
    self.selfRankingItem = nil
    RankingDataInBound.ReadBuffer(self, buffer)
    if self.rankingDataList:Count() > 0 then
        ---@type number
        self.score = buffer:GetLong()
    end
    for i = 1, self.rankingDataList:Count() do
        --- @type RankingItemInBound
        local rankingItem = self.rankingDataList:Get(i)
        if rankingItem.id == PlayerSettingData.playerId then
            self.selfRankingItem = rankingItem
        end
    end
end

--- @return number
function FriendRankingInBound:GetUserScore()
    return self.score
end

--- @return number
function FriendRankingInBound:TimeCreated()
    if self.selfRankingItem ~= nil then
        return self.selfRankingItem.createdTime
    end
    return nil
end