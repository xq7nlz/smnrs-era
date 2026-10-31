require("lua.client.core.network.otherPlayer.OtherPlayerInfoInBound")
require("lua.client.core.network.defenseMode.DefenseWaveRecord")

--- @class DefenseBattleRecordInBound
DefenseBattleRecordInBound = Class(DefenseBattleRecordInBound)

function DefenseBattleRecordInBound:Ctor(buffer)
    --- @type OtherPlayerInfoInBound
    self.playerInfoInBound = nil
    --- @type List
    self.listRecord = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
    ---@type DefenseWaveRecord
    local lastRecord = self.listRecord:Get(self.listRecord:Count())
    self.isWin = lastRecord.isWin
    self.battleIndex = 1
end

--- @param buffer UnifiedNetwork_ByteBuf
function DefenseBattleRecordInBound:ReadBuffer(buffer)
    self.listRecord = NetworkUtils.GetListDataInBound(buffer, DefenseWaveRecord)

    self.playerInfoInBound = OtherPlayerInfoInBound.CreateByBuffer(buffer)
end

--- @param listAttackerTeamStageConfig List
function DefenseBattleRecordInBound:RunTheFirstBattle(listAttackerTeamStageConfig)
    self.listAttackerTeamStageConfig = listAttackerTeamStageConfig
    self.battleIndex = 1
    self:CalculateBattle(self.battleIndex)
end

function DefenseBattleRecordInBound:RunTheNextBattle()
    if self.battleIndex < self.listRecord:Count() then
        self.battleIndex = self.battleIndex + 1
        self:CalculateBattle(self.battleIndex)
        return true
    end
    return false
end

--- @param battleIndex number
function DefenseBattleRecordInBound:CalculateBattle(battleIndex)
    local gameMode = GameMode.DEFENSE_MODE_RECORD
    --- @type BattleTeamInfo
    local attackerTeam = self.playerInfoInBound:CreateBattleTeamInfo()
    --- @type AttackerTeamStageConfig
    local defenderTeamStageConfig = self.listAttackerTeamStageConfig:Get(battleIndex)
    --- @type BattleTeamInfo
    local defenderTeam = defenderTeamStageConfig:GetBattleTeamInfo(BattleConstants.DEFENDER_TEAM_ID)
    if battleIndex > 1 then
        ---@type DefenseWaveRecord
        local wave = self.listRecord:Get(battleIndex - 1)
        for i = 1, wave.teamHeroState.heroStates:Count() do
            --- @type HeroStateInBound
            local heroStateInBound = wave.teamHeroState.heroStates:Get(i)
            attackerTeam:SetState(gameMode, heroStateInBound.isFrontLine,
                    heroStateInBound.position, heroStateInBound.hp, heroStateInBound.power)
        end
        attackerTeam:RemoveUninitializedHeroes()
    end

    ---@type DefenseWaveRecord
    local wave = self.listRecord:Get(battleIndex)
    ---@type RandomHelper
    local randomHelper = RandomHelper()
    randomHelper:SetSeed(wave.seed.seed)
    ClientBattleData.skipForReplay = true
    zg.battleMgr:RunCalculatedBattleScene(attackerTeam, defenderTeam, GameMode.DEFENSE_MODE_RECORD, randomHelper, nil, wave.battleLog)
end