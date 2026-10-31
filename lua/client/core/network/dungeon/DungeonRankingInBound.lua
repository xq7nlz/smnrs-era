require "lua.client.core.network.playerData.common.RankingDataInBound"

--- @class DungeonRankingInBound : RankingDataInBound
DungeonRankingInBound = Class(DungeonRankingInBound, RankingDataInBound)

function DungeonRankingInBound:Ctor()
    RankingDataInBound.Ctor(self, PlayerDataMethod.DUNGEON_RANKING)
    self.lastUserSortScore = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).currentLevel
end

function DungeonRankingInBound:ReadBuffer(buffer)
    RankingDataInBound.ReadBuffer(self, buffer)
    self.lastUserSortScore = zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).currentStage
end

--- @return number
function DungeonRankingInBound:GetUserScore()
    return zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).highestStage
end

--- @return number
function DungeonRankingInBound:TimeCreated()
    return zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).timeReachHighestStage
end

function DungeonRankingInBound:IsScoreChange()
    return zg.playerData:GetMethod(PlayerDataMethod.DUNGEON).currentStage ~= self.lastUserSortScore
end