require "lua.client.core.network.otherPlayer.DetailTeamFormation"
require "lua.client.core.network.common.SummonerBattleInfoInBound"

--- @class ArenaTeamOpponentDetail : InBound
ArenaTeamOpponentDetail = Class(ArenaTeamOpponentDetail, InBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamOpponentDetail:Ctor(buffer)
    if buffer ~= nil then
        self:Deserialize(buffer)
    end
end

--- @return OtherPlayerInfoInBound
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamOpponentDetail:Deserialize(buffer)
    local size = buffer:GetByte()
    --- @type Dictionary
    self.dictFormation = Dictionary()
    for i = 1, size do
        self.dictFormation:Add(buffer:GetByte(), OtherPlayerInfoInBound.CreateByBuffer(buffer))
    end
end

--- @return BattleTeamInfo
function ArenaTeamOpponentDetail:GetBattleTeamInfoArenaTeam(teamFormation)
    local otherPlayerInfo = self.dictFormation:Get(teamFormation)
    return otherPlayerInfo:CreateBattleTeamInfo(nil, BattleConstants.ATTACKER_TEAM_ID)
end