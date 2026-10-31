require "lua.client.core.network.arenaTeam.ArenaTeamOpponentBase"

--- @class ArenaTeamBotOpponentInfo : ArenaTeamOpponentBase
ArenaTeamBotOpponentInfo = Class(ArenaTeamBotOpponentInfo, ArenaTeamOpponentBase)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBotOpponentInfo:Ctor(buffer)
    if buffer ~= nil then
        self:Deserialize(buffer)
    end
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamBotOpponentInfo:Deserialize(buffer)
    --- @type number
    self.botId = buffer:GetInt()
    --- @type number
    self.botName = buffer:GetString()
    --- @type number
    self.botAvatar = buffer:GetInt()
end

---@return ArenaTeamBotData
function ArenaTeamBotOpponentInfo:GetArenaTeamBotData()
    if self.arenaBotData == nil then
        ---@type ArenaBotData
        self.arenaBotData = ResourceMgr.GetArenaTeamBotConfig():GetArenaBotData(self.botId)
    end
    if self.arenaBotData == nil then
        XDebug.Error("Nil botId " .. self.botId)
    end
    return self.arenaBotData
end

---@return UnityEngine_Sprite
function ArenaTeamBotOpponentInfo:GetRankImage()
    local rankType = ClientConfigUtils.GetRankingTypeByElo(self:GetElo(), FeatureType.ARENA_TEAM)
    return ResourceLoadUtils.LoadArenaRankIcon(rankType)
end

--- @return BattleTeamInfo
function ArenaTeamBotOpponentInfo:GetBattleTeamInfoArenaTeam(teamFormation)
    local arenaBotData = self:GetArenaTeamBotData()
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(arenaBotData:GetDefenderTeamData(teamFormation))
end

---@return number
function ArenaTeamBotOpponentInfo:GetElo()
    return self:GetArenaTeamBotData().elo
end

---@return number
function ArenaTeamBotOpponentInfo:GetPower()
    if self.totalAp == nil then
        self.totalAp = 0
        for i = 1, 3 do
            self.totalAp = self.totalAp + ClientConfigUtils.GetPowerByBattleTeamInfo(self:GetBattleTeamInfoArenaTeam(i))
        end
        self.totalAp = math.floor(self.totalAp)
    end
    return self.totalAp
end

---@return number
function ArenaTeamBotOpponentInfo:GetName()
    return self.botName
end

---@return number
function ArenaTeamBotOpponentInfo:GetAvatar()
    return self.botAvatar
end

---@return number
function ArenaTeamBotOpponentInfo:GetLevel()
    return self:GetBattleTeamInfoArenaTeam(1).summonerBattleInfo.level
end

---@return BattleTeamInfo
function ArenaTeamBotOpponentInfo:RequestBattle(callbackSuccess, callbackFailed, isSkip, resultBattleClose)
    ArenaRequest.RequestBotBattleArenaTeam(self, callbackSuccess, callbackFailed, isSkip, resultBattleClose)
end