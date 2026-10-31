require "lua.client.data.DefenseMode.defenseBattle.DefenseStageAttackConfig"
require "lua.client.data.DefenseMode.defenseBattle.DefenseStageTowerConfig"

--- @class DefenseStageConfig
DefenseStageConfig = Class(DefenseStageConfig)

function DefenseStageConfig:Ctor(land, stage)
    --- @type DefenseStageAttackConfig
    self.defenseStageAttackConfig = DefenseStageAttackConfig(land, stage)
    --- @type DefenseStageTowerConfig
    self.defenseStageTowerConfig = DefenseStageTowerConfig(land, stage)
end