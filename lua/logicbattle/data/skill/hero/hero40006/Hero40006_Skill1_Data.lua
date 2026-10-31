--- @class Hero40006_Skill1_Data Oropher
Hero40006_Skill1_Data = Class(Hero40006_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40006_Skill1_Data:CreateInstance()
    return Hero40006_Skill1_Data()
end

--- @return void
function Hero40006_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.ally_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.ally_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.effect_percent ~= nil, "effect_percent = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero40006_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.allyTargetPosition = tonumber(parsedData.ally_target_position)
    self.allyTargetNumber = tonumber(parsedData.ally_target_number)

    self.effectPercent = tonumber(parsedData.effect_percent)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero40006_Skill1_Data