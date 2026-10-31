require "lua.client.core.network.otherPlayer.DetailTeamFormation"
require "lua.client.core.network.common.SummonerBattleInfoInBound"

--- @class OtherPlayerInfoInBound
OtherPlayerInfoInBound = Class(OtherPlayerInfoInBound, InBound)

--- @return void
function OtherPlayerInfoInBound:Ctor()
    --- @type number
    self.playerId = nil
    --- @type string
    self.playerName = nil
    --- @type number
    self.playerAvatar = nil
    --- @type number
    self.playerLevel = nil
    --- @type number
    self.guildName = nil
    --- @type DetailTeamFormation
    self.detailsTeamFormation = nil
    ---@type SummonerBattleInfoInBound
    self.summonerBattleInfoInBound = nil
    
end

--- @return OtherPlayerInfoInBound
--- @param buffer UnifiedNetwork_ByteBuf
function OtherPlayerInfoInBound:Deserialize(buffer)
    self.playerId = buffer:GetLong()
    self.playerName = buffer:GetString()
    self.playerAvatar = buffer:GetInt()
    self.playerLevel = buffer:GetShort()
    self.guildName = buffer:GetString()
    self.detailsTeamFormation = DetailTeamFormation.CreateByBuffer(buffer)
    self.summonerBattleInfoInBound = SummonerBattleInfoInBound(buffer)
    if self.summonerBattleInfoInBound.summonerBattleInfo.level == nil then
        self.summonerBattleInfoInBound.summonerBattleInfo.level = self.playerLevel
    end
    self.avatarData = AvatarData(buffer)
end

--- @return OtherPlayerInfoInBound
--- @param buffer UnifiedNetwork_ByteBuf
function OtherPlayerInfoInBound.CreateByBuffer(buffer)
    local data = OtherPlayerInfoInBound()
    data:Deserialize(buffer)
    return data
end

--- @return BattleTeamInfo
function OtherPlayerInfoInBound:CreateBattleTeamInfo(summonerLevel, teamId)
    summonerLevel = summonerLevel or self.summonerBattleInfoInBound.summonerBattleInfo.level
    teamId = teamId or BattleConstants.ATTACKER_TEAM_ID
    return ClientConfigUtils.GetBattleTeamInfoByDetailsTeamFormationAndSummonerInfo(self.detailsTeamFormation, self.summonerBattleInfoInBound, teamId)
end

--- @return string
function OtherPlayerInfoInBound:ToString()
    return LogUtils.ToDetail(self) .. "\n DetailTeamFormation" .. LogUtils.ToDetail(self.detailsTeamFormation)
end

--- @return string
function OtherPlayerInfoInBound:GetDataAvatar()
    return {
        ["avatar"] = self.playerAvatar,
        ["level"] = self.playerLevel,
        ["name"] = self.playerName,
        ["playerId"] = self.playerId,
    }
end