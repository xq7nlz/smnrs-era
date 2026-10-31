require "lua.client.core.network.playerData.arena.ArenaOpponentBase"
require "lua.client.core.network.playerData.arena.ArenaChallengeRewardInBound"

--- @class ArenaBotOpponentInfo : ArenaOpponentBase
ArenaBotOpponentInfo = Class(ArenaBotOpponentInfo, ArenaOpponentBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaBotOpponentInfo:Ctor(buffer)
    if buffer ~= nil then
        self:Deserialize(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaBotOpponentInfo:Deserialize(buffer)
    --- @type number
    self.botId = buffer:GetInt()
    --- @type number
    self.botName = buffer:GetString()
    --- @type number
    self.botAvatar = buffer:GetInt()
end

---@return UnityEngine_Sprite
function ArenaBotOpponentInfo:GetRankImage()
    local rankType = ClientConfigUtils.GetRankingTypeByElo(self:GetElo(), FeatureType.ARENA)
    return ResourceLoadUtils.LoadArenaRankIcon(rankType)
end

---@return number
function ArenaBotOpponentInfo:GetElo()
    ---@type ArenaBotData
    local arenaBotData = ResourceMgr.GetArenaBotConfig():GetArenaBotData(self.botId)
    return arenaBotData.elo
end

---@return number
function ArenaBotOpponentInfo:GetPower()
    ---@type ArenaBotData
    local arenaBotData = ResourceMgr.GetArenaBotConfig():GetArenaBotData(self.botId)
    return arenaBotData.defenderTeamData:GetPowerTeam()
end

---@return number
function ArenaBotOpponentInfo:GetName()
    return self.botName
end

---@return number
function ArenaBotOpponentInfo:GetAvatar()
    return self.botAvatar
end

---@return number
function ArenaBotOpponentInfo:GetLevel()
    return self:GetBattleTeamInfo().summonerBattleInfo.level
end

---@return BattleTeamInfo
function ArenaBotOpponentInfo:GetBattleTeamInfo()
    ---@type ArenaBotData
    local arenaBotData = ResourceMgr.GetArenaBotConfig():GetArenaBotData(self.botId)
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(arenaBotData.defenderTeamData)
end

---@return BattleTeamInfo
function ArenaBotOpponentInfo:RequestBattle(callbackSuccess, callbackFail)
    ---@type ArenaChallengeRewardInBound
    local arenaSingleChallengeInBound
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        ---@type ArenaBotData
        local arenaBotData = ResourceMgr.GetArenaBotConfig():GetArenaBotData(self.botId)
        arenaSingleChallengeInBound = ArenaChallengeRewardInBound(buffer, arenaBotData.elo)
        arenaSingleChallengeInBound.rewards = NetworkUtils.AddInjectRewardInBoundList(buffer, arenaSingleChallengeInBound.rewards)
    end
    local battleSuccess = function()
        if callbackSuccess ~= nil then
            callbackSuccess(arenaSingleChallengeInBound, self:GetBattleTeamInfo())
        end
    end
    NetworkUtils.RequestAndCallback(OpCode.ARENA_BOT_CHALLENGE,
            UnknownOutBound.CreateInstance(PutMethod.Int, self.botId, PutMethod.String, self.botName, PutMethod.Int, self.botAvatar),
            battleSuccess, callbackFail, onBufferReading)
end