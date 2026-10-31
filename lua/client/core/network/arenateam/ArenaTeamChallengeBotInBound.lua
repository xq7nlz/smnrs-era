require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class ArenaTeamChallengeBotInBound : ArenaTeamChallengeInBound
ArenaTeamChallengeBotInBound = Class(ArenaTeamChallengeBotInBound, ArenaTeamChallengeInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamChallengeBotInBound:Ctor(buffer)
    --- @type number
    self.attackerElo = buffer:GetInt()
    --- @type number
    self.defenderElo = buffer:GetInt()
    --- @type number
    self.eloChange = buffer:GetByte()
    --- @type List
    self.rewards = NetworkUtils.GetRewardInBoundList(buffer)
    --- @type number
    self.isWin = buffer:GetBool()

    --- @type Dictionary
    self.battleResults = Dictionary()
    local size = buffer:GetByte()
    for i = 1, size do
        self.battleResults:Add(buffer:GetByte(), BattleResultInBound.CreateByBuffer(buffer))
    end
end

function ArenaTeamChallengeBotInBound:BattleCount()
    return self.battleResults:Count()
end

function ArenaTeamChallengeBotInBound:IsWin(battleIndex)
    --- @type BattleResultInBound
    local battleResultInBound = self.battleResults:Get(battleIndex)
    return battleResultInBound.isWin
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

---@type BattleTeamInfo
function ArenaTeamChallengeBotInBound:SetBotData(botId)
    ---@type ArenaBotData
    self.arenaBotData = ResourceMgr.GetArenaTeamBotConfig():GetArenaBotData(botId)
end

---@type BattleTeamInfo
function ArenaTeamChallengeBotInBound:GetBattleTeamInfoDefender(indexTeam)
    return ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(self.arenaBotData:GetDefenderTeamData(indexTeam))
end

---@type BattleResultInBound
function ArenaTeamChallengeBotInBound:GetBattleResultInfo(indexTeam)
    return self.battleResults:Get(indexTeam)
end