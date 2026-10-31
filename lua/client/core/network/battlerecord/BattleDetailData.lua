--- @class BattleDetailData
BattleDetailData = Class(BattleDetailData)

--- @return void
function BattleDetailData:Ctor(attackerTeam, defenderTeam, seedInbound, battleLog)
    ---@type BattleTeamInfo
    self.attackerTeam = attackerTeam
    ---@type BattleTeamInfo
    self.defenderTeam = defenderTeam
    ---@type SeedInBound
    self.seedInbound = seedInbound
    --- @type string
    self.battleLog = nil
    --- @type string
    self.getStringBattle = battleLog
    if self.getStringBattle ~= "" then
        --- @type string
        self.battleLog = self.getStringBattle
    end
end