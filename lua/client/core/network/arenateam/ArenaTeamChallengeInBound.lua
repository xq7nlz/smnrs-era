require "lua.client.core.network.arenaTeam.ArenaTeamBattleResultInfo"

--- @class ArenaTeamChallengeInBound
ArenaTeamChallengeInBound = Class(ArenaTeamChallengeInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaTeamChallengeInBound:Ctor(buffer)
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
    for _ = 1, size do
        local arenaTeamBattleResultInfo = ArenaTeamBattleResultInfo(buffer)
        self.battleResults:Add(arenaTeamBattleResultInfo.teamIndex, arenaTeamBattleResultInfo)
    end
end

function ArenaTeamChallengeInBound:BattleCount()
    return self.battleResults:Count()
end

function ArenaTeamChallengeInBound:IsWin(battleIndex)
    --- @type ArenaTeamBattleResultInfo
    local arenaTeamBattleResultInfo = self.battleResults:Get(battleIndex)
    return arenaTeamBattleResultInfo.battleResultInfo.isWin
end

---@type BattleTeamInfo
function ArenaTeamChallengeInBound:GetBattleTeamInfoDefender(indexTeam)
    ---@type ArenaTeamBattleResultInfo
    local arenaTeamBattleResultInfo = self.battleResults:Get(indexTeam)
    return arenaTeamBattleResultInfo.defender:CreateBattleTeamInfo(nil, BattleConstants.DEFENDER_TEAM_ID)
end

---@type BattleResultInBound
function ArenaTeamChallengeInBound:GetBattleResultInfo(indexTeam)
    ---@type ArenaTeamBattleResultInfo
    local arenaTeamBattleResultInfo = self.battleResults:Get(indexTeam)
    return arenaTeamBattleResultInfo.battleResultInfo
end