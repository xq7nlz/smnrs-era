--- @class Hero50001_Skill1_Data AmiableAngel
Hero50001_Skill1_Data = Class(Hero50001_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50001_Skill1_Data:CreateInstance()
    return Hero50001_Skill1_Data()
end

--- @return void
function Hero50001_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "enemy_target_position = nil")

    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.ally_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.ally_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50001_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.allyTargetPosition = tonumber(parsedData.ally_target_position)
    self.allyTargetNumber = tonumber(parsedData.ally_target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50001_Skill1_Data