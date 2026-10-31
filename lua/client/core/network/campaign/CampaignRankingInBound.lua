require "lua.client.core.network.playerData.common.RankingDataInBound"

--- @class CampaignRankingInBound : RankingDataInBound
CampaignRankingInBound = Class(CampaignRankingInBound, RankingDataInBound)

function CampaignRankingInBound:Ctor()
    RankingDataInBound.Ctor(self, PlayerDataMethod.CAMPAIGN_RANKING)
end

--- @return number
function CampaignRankingInBound:GetUserScore()
    return zg.playerData:GetCampaignData().stageCurrent
end

--- @return number
function CampaignRankingInBound:TimeCreated()
    return zg.playerData:GetCampaignData().timeReachHighestStage
end