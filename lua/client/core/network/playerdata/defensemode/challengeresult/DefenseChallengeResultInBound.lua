require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class DefenseChallengeResultInBound
DefenseChallengeResultInBound = Class(DefenseChallengeResultInBound)

function DefenseChallengeResultInBound:Ctor(buffer)
    --- @type number
    self.isWin = nil
    --- @type List
    self.listResults = nil
    --- @type number
    self.battleIndex = nil
    --- @type List
    self.listReward = nil

    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseChallengeResultInBound:ReadBuffer(buffer)
    --- @type number
    self.isWin = buffer:GetBool()

    --- @type List
    self.listResults = List()
    local size = buffer:GetByte()
    for i = 1, size do
        --- @type BattleResultInBound
        local battleResultInfo = BattleResultInBound.CreateByBuffer(buffer, false)
        self.listResults:Add(battleResultInfo)
    end
    self.listReward = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @param teamFormationInBound TeamFormationInBound
function DefenseChallengeResultInBound:RunTheFirstBattle(teamFormationInBound, listAttackerTeamStageConfig, land)
    self.battleIndex = 1
    self.teamFormationInBound = teamFormationInBound
    self.listAttackerTeamStageConfig = listAttackerTeamStageConfig
    self.land = land

    self:CalculateBattle(1)
end

function DefenseChallengeResultInBound:RunTheNextBattle()
    if self.battleIndex < self.listResults:Count() then
        self.battleIndex = self.battleIndex + 1
        self:CalculateBattle(self.battleIndex)
        return true
    end
    return false
end

--- @param battleIndex number
function DefenseChallengeResultInBound:CalculateBattle(battleIndex)
    local gameMode = GameMode.DEFENSE_MODE
    --- @type BattleTeamInfo
    local attackerTeam =  ClientConfigUtils.GetBattleTeamInfoByTeamFormationInBoundDefenseMode(self.teamFormationInBound, self.land)

    --- @type AttackerTeamStageConfig
    local defenderTeamStageConfig = self.listAttackerTeamStageConfig:Get(battleIndex)
    --- @type BattleTeamInfo
    local defenderTeam = defenderTeamStageConfig:GetBattleTeamInfo(BattleConstants.DEFENDER_TEAM_ID)
    if battleIndex > 1 then
        --- @type BattleResultInBound
        local lastBattleResult = self.listResults:Get(battleIndex - 1)

        for i = 1, lastBattleResult.heroStateAttacker:Count() do
            --- @type HeroStateInBound
            local heroStateInBound = lastBattleResult.heroStateAttacker:Get(i)
            attackerTeam:SetState(gameMode, heroStateInBound.isFrontLine,
                    heroStateInBound.position, heroStateInBound.hp, heroStateInBound.power)
        end
        attackerTeam:RemoveUninitializedHeroes()
    end
    --- @type BattleResultInBound
    local battleResultInBound = self.listResults:Get(battleIndex)

    ---@type RandomHelper
    local randomHelper = RandomHelper()
    randomHelper:SetSeed(battleResultInBound.seedInBound.seed)

    zg.battleMgr:RunCalculatedBattleScene(attackerTeam, defenderTeam, GameMode.DEFENSE_MODE, randomHelper, nil, battleResultInBound.battleLog)
end