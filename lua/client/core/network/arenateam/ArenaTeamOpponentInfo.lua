require "lua.client.core.network.arenaTeam.ArenaTeamOpponentBase"

--- @class ArenaTeamOpponentInfo : ArenaTeamOpponentBase
ArenaTeamOpponentInfo = Class(ArenaTeamOpponentInfo, ArenaTeamOpponentBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamOpponentInfo:Ctor(buffer)
    --- @type number
    self.eloPoint = buffer:GetInt()
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type string
    self.playerName = buffer:GetString()
    --- @type number
    self.playerAvatar = buffer:GetInt()
    --- @type number
    self.playerLevel = buffer:GetShort()
    --- @type number
    self.guildName = buffer:GetString()
    local size = buffer:GetByte()
    --- @type List
    self.listAp = List()
    self.totalAp = 0
    for _ = 1, size do
        local ap = buffer:GetLong()
        self.listAp:Add(ap)
        self.totalAp = self.totalAp + ap
    end
    self.avatarData = AvatarData(buffer)
end

---@return UnityEngine_Sprite
function ArenaTeamOpponentInfo:GetRankImage()
    local topNumber = nil
    --- @type ArenaTeamInBound
    local arenaTeamInBound = zg.playerData:GetMethod(PlayerDataMethod.ARENA_TEAM)
    ---@param v SingleArenaRanking
    for i, v in ipairs(arenaTeamInBound.rankingDataList:GetItems()) do
        if v.playerId == self.playerId then
            topNumber = i
            break
        end
    end

    local rankType = ClientConfigUtils.GetRankingTypeByElo(self.eloPoint, FeatureType.ARENA_TEAM)
    return ClientConfigUtils.GetIconRankingArenaByRankType(rankType, topNumber, FeatureType.ARENA_TEAM)
end

---@return number
function ArenaTeamOpponentInfo:GetElo()
    return self.eloPoint
end

---@return number
function ArenaTeamOpponentInfo:GetPower()
    return self.totalAp
end

---@return number
function ArenaTeamOpponentInfo:GetName()
    return self.playerName
end

---@return number
function ArenaTeamOpponentInfo:GetAvatar()
    return self.playerAvatar
end

---@return number
function ArenaTeamOpponentInfo:GetLevel()
    return self.playerLevel
end

-----@return BattleTeamInfo
--function ArenaTeamOpponentInfo:GetBattleTeamInfo()
--    return self:CreateBattleTeamInfo(BattleConstants.ATTACKER_TEAM_ID)
--end

---@return BattleTeamInfo
function ArenaTeamOpponentInfo:RequestBattle(callbackSuccess, callbackFail, isSkip, resultBattleClose)
    ArenaRequest.RequestBattleArenaTeam(self, callbackSuccess, callbackFail, isSkip, resultBattleClose)
end