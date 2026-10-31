require "lua.client.core.network.playerData.arena.ArenaOpponentBase"
require "lua.client.core.network.playerData.arena.ArenaSingleChallengeInBound"

--- @class ArenaOpponentInfo : ArenaOpponentBase
ArenaOpponentInfo = Class(ArenaOpponentInfo, ArenaOpponentBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaOpponentInfo:Ctor(buffer)
    --- @type OtherPlayerInfoInBound
    self.otherPlayerInfo = OtherPlayerInfoInBound.CreateByBuffer(buffer)
    --- @type number
    self.eloPoint = buffer:GetInt()
    --XDebug.Log(LogUtils.ToDetail(self.otherPlayerInfo) .. self.eloPoint)
end

--- @return BattleTeamInfo
function ArenaOpponentInfo:CreateBattleTeamInfo(teamId)
    return self.otherPlayerInfo:CreateBattleTeamInfo(nil, teamId)
end

---@return UnityEngine_Sprite
function ArenaOpponentInfo:GetRankImage()
    local topNumber = nil
    ---@type ServerArenaRankingInBound
    local serverArenaRankingInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_SERVER_RANKING)
    if serverArenaRankingInBound ~= nil then
        ---@param v SingleArenaRanking
        for i, v in ipairs(serverArenaRankingInBound.listRanking:GetItems()) do
            if v.playerId == self.otherPlayerInfo.playerId then
                topNumber = i
                break
            end
        end
    end
    local rankType = ClientConfigUtils.GetRankingTypeByElo(self.eloPoint, FeatureType.ARENA)
    return ClientConfigUtils.GetIconRankingArenaByRankType(rankType, topNumber, FeatureType.ARENA)
end

---@return number
function ArenaOpponentInfo:GetElo()
    return self.eloPoint
end

---@return number
function ArenaOpponentInfo:GetPower()
    ---@type BattleTeamInfo
    local battleTeamInfo = self:CreateBattleTeamInfo(BattleConstants.ATTACKER_TEAM_ID)
    return math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo))
end

---@return number
function ArenaOpponentInfo:GetName()
    return self.otherPlayerInfo.playerName
end

---@return number
function ArenaOpponentInfo:GetAvatar()
    return self.otherPlayerInfo.playerAvatar
end

---@return number
function ArenaOpponentInfo:GetLevel()
    return self.otherPlayerInfo.playerLevel
end

---@return BattleTeamInfo
function ArenaOpponentInfo:GetBattleTeamInfo()
    return self:CreateBattleTeamInfo(BattleConstants.ATTACKER_TEAM_ID)
end

---@return BattleTeamInfo
function ArenaOpponentInfo:RequestBattle(callbackSuccess, callbackFail)
    ---@type ArenaSingleChallengeInBound
    local arenaSingleChallengeInBound
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        arenaSingleChallengeInBound = ArenaSingleChallengeInBound(buffer)
    end
    local battleSuccess = function()
        if callbackSuccess ~= nil then
            local battleTeamInfo = arenaSingleChallengeInBound.defender
                    :CreateBattleTeamInfo(arenaSingleChallengeInBound.defender.playerLevel, BattleConstants.DEFENDER_TEAM_ID)
            callbackSuccess(arenaSingleChallengeInBound.arenaChallengeReward, battleTeamInfo, arenaSingleChallengeInBound.arenaChallengeReward.battleResult.battleLog)
        end
    end
    --zg.playerData:CheckDataLinking(function ()
        NetworkUtils.RequestAndCallback(OpCode.ARENA_CHALLENGE, UnknownOutBound.CreateInstance(PutMethod.Long, self.otherPlayerInfo.playerId),
                battleSuccess, callbackFail, onBufferReading)
    --end, true)
end