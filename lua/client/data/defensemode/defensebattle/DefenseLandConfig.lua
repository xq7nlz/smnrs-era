require "lua.client.data.DefenseMode.defenseBattle.DefenseStageConfig"

--- @class DefenseLandConfig
DefenseLandConfig = Class(DefenseLandConfig)

function DefenseLandConfig:Ctor(land)
    self.land = land
    --- @type Dictionary
    self._defenseLandConfigDict = Dictionary()
end

--- @return DefenseStageConfig
function DefenseLandConfig:GetDefenseStageConfig(stage)
    --- @type DefenseStageConfig
    local defenseStageConfig = self._defenseLandConfigDict:Get(stage)
    if defenseStageConfig == nil then
        defenseStageConfig = DefenseStageConfig(self.land, stage)
        self._defenseLandConfigDict:Add(stage, defenseStageConfig)
    end
    return defenseStageConfig
end