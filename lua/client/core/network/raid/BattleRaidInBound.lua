require "lua.client.core.network.playerData.common.BattleResultInBound"

--- @class BattleRaidInBound
BattleRaidInBound = Class(BattleRaidInBound)

--- @return void
function BattleRaidInBound:Ctor()
    --- @type BattleResultInBound
    self.battleResultInBound = nil
    --- @type List
    self.listReward = List()
    --- @type List
    self.listBattleLogs = List()
    --- @type number
    self.battleIndex = nil
end

--- @return BattleRaidInBound
--- @param buffer UnifiedNetwork_ByteBuf
function BattleRaidInBound.CreateByBuffer(buffer)
    local data = BattleRaidInBound()
    data.battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)
    data.listReward = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
    --data.listReward = NetworkUtils.AddInjectRewardInBoundList(buffer, data.listReward)
    local size = buffer:GetByte()
    for i = 1,size do
        data.listBattleLogs:Add(buffer:GetString(false))
    end
    return data
end


--- @param teamFormationInBound TeamFormationInBound
function BattleRaidInBound:RunTheFirstBattle(teamFormationInBound, listAttackerTeamStageConfig)
    self.battleIndex = 1
    self.teamFormationInBound = teamFormationInBound
    self.listAttackerTeamStageConfig = listAttackerTeamStageConfig

    self:CalculateBattle(1)
end

function BattleRaidInBound:RunTheNextBattle()
    if self.battleIndex < self.listBattleLogs:Count() then
        self.battleIndex = self.battleIndex + 1
        self.coroutineWaitNextBattle = Coroutine.start(function()
            ---@type number
            local numberOfSecs = 0.5

            while (numberOfSecs > 0) do
                coroutine.waitforseconds(0.5)
                numberOfSecs = numberOfSecs - 1
            end
            self:CalculateBattle(self.battleIndex)
        end)
        return true
    end
    return false
end

--- @param battleIndex number
function BattleRaidInBound:CalculateBattle(battleIndex)
    local gameMode = GameMode.RAID_HERO_FRAGMENT

    --- @type List
    self.listHeroResource = List()
    self.listHeroResource = InventoryUtils.Get(ResourceType.Hero)

    ---@type BattleTeamInfo
    local attackerBattleTeamInfo = ClientConfigUtils.GetAttackCurrentBattleTeamInfoByMode(gameMode, self.listHeroResource)

    --- @type AttackerTeamStageConfig
    local defenderTeamStageConfig = self.listAttackerTeamStageConfig:Get(battleIndex)
    --- @type BattleTeamInfo
    local defenderTeam = defenderTeamStageConfig:GetBattleTeamInfo(BattleConstants.DEFENDER_TEAM_ID)

    local battleLog = self.listBattleLogs:Get(battleIndex)

    zg.battleMgr:RunCalculatedBattleScene(attackerBattleTeamInfo, defenderTeam, GameMode.RAID_HERO_FRAGMENT, nil, nil, battleLog)
end