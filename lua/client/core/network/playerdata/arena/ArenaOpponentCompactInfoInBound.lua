require "lua.client.core.network.common.SummonerBattleInfoInBound"

--- @class ArenaOpponentCompactInfoInBound
ArenaOpponentCompactInfoInBound = Class(ArenaOpponentCompactInfoInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaOpponentCompactInfoInBound:Ctor(buffer)
    self.playerLevel = buffer:GetShort()
    --- @type DetailTeamFormation
    self.detailsTeamFormation = DetailTeamFormation.CreateByBuffer(buffer)
    ---@type SummonerBattleInfoInBound
    self.summonerBattleInfoInBound = SummonerBattleInfoInBound(buffer)
end

--- @return BattleTeamInfo
function ArenaOpponentCompactInfoInBound:CreateBattleTeamInfo(teamId)
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationAndSummonerInfo(self.detailsTeamFormation, self.summonerBattleInfoInBound, teamId or 1)
end