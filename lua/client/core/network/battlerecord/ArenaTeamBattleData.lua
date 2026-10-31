require("lua.client.core.network.battleRecord.BattleDetailData")

--- @class ArenaTeamBattleData
ArenaTeamBattleData = Class(ArenaTeamBattleData)

--- @return void
function ArenaTeamBattleData:Ctor()
    --- @type BattleConstants
    self.winnerTeam = BattleConstants.ATTACKER_TEAM_ID
    --- @type number
    self.attackerWinCount = 0
    --- @type List
    self.listBattleDetail = List()
end

function ArenaTeamBattleData:AddBattleDetailItem(item, isAttackerWin)
    self.listBattleDetail:Add(item)
    if isAttackerWin then
        self.attackerWinCount = self.attackerWinCount + 1
    end
    if self.attackerWinCount >= 2 then
        self.winnerTeam = BattleConstants.ATTACKER_TEAM_ID
    else
        self.winnerTeam = BattleConstants.DEFENDER_TEAM_ID
    end
end

--- @return void
---@param param ArenaTeamChallengeInBound
function ArenaTeamBattleData.CreateByArenaTeamChallengeInBound(param)
    local data = ArenaTeamBattleData()
    for i = 1, 3 do
        ---@type BattleResultInBound
        local battleResultInBound = param:GetBattleResultInfo(i)
        ---@type BattleTeamInfo
        local attackerTeam = ClientConfigUtils.GetBattleTeamInfoArenaTeam(1, i)
        for j, v in pairs(battleResultInBound.activeLinking:GetItems()) do
            attackerTeam:AddLinkingGroup(j, v)
        end
        data:AddBattleDetailItem(BattleDetailData(attackerTeam, param:GetBattleTeamInfoDefender(i), battleResultInBound.seedInBound, battleResultInBound.battleLog), battleResultInBound.isWin)
    end
    return data
end

--- @return void
---@param param ArenaTeamBattleRecordInBound
function ArenaTeamBattleData.CreateByArenaTeamBattleRecordInBound(param)
    local data = ArenaTeamBattleData()
    ---@param arenaTeamBattleRecord ArenaTeamBattleRecord
    for i, arenaTeamBattleRecord in pairs(param.dictBattleRecord:GetItems()) do
        data:AddBattleDetailItem(BattleDetailData(
                arenaTeamBattleRecord.teamRecordAttack:CreateBattleTeamInfo(nil, BattleConstants.ATTACKER_TEAM_ID),
                arenaTeamBattleRecord.teamRecordDefend:CreateBattleTeamInfo(nil, BattleConstants.DEFENDER_TEAM_ID),
                arenaTeamBattleRecord.seedInBound,
                arenaTeamBattleRecord.battleLog), arenaTeamBattleRecord.isAttackWin)
    end
    return data
end

--- @return void
---@param param ArenaTeamBattleBotRecordInBound
function ArenaTeamBattleData.CreateByArenaTeamBattleBotRecordInBound(param)
    local data = ArenaTeamBattleData()
    ---@param arenaTeamBattleRecord ArenaTeamBattleBotRecord
    for _, arenaTeamBattleRecord in pairs(param.dictBattleRecord:GetItems()) do
        data:AddBattleDetailItem(BattleDetailData(
                arenaTeamBattleRecord.teamRecordAttack:CreateBattleTeamInfo(nil, BattleConstants.ATTACKER_TEAM_ID),
                ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(arenaTeamBattleRecord.teamRecordDefend, BattleConstants.DEFENDER_TEAM_ID),
                arenaTeamBattleRecord.seedInBound,
                arenaTeamBattleRecord.battleLog), arenaTeamBattleRecord.isAttackWin)
    end
    return data
end