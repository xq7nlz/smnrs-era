require "lua.client.core.network.playerData.common.RankingDataInBound"

--- @class TowerRankingInBound : RankingDataInBound
TowerRankingInBound = Class(TowerRankingInBound, RankingDataInBound)

function TowerRankingInBound:Ctor()
    RankingDataInBound.Ctor(self, PlayerDataMethod.TOWER_RANKING)
end

--- @return number
function TowerRankingInBound:GetUserScore()
    return zg.playerData:GetMethod(PlayerDataMethod.TOWER).levelCurrent
end

--- @return number
function TowerRankingInBound:TimeCreated()
    return zg.playerData:GetMethod(PlayerDataMethod.TOWER).timeReachHighestStage
end