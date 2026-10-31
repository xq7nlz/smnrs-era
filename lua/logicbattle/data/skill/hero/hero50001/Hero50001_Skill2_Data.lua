--- @class Hero50001_Skill2_Data AmiableAngel
Hero50001_Skill2_Data = Class(Hero50001_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50001_Skill2_Data:CreateInstance()
    return Hero50001_Skill2_Data()
end

--- @return void
function Hero50001_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.ally_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.ally_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")

    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
    assert(parsedData.hp_percent_to_heal ~= nil, "hp_percent_to_heal = nil")
end

--- @return void
function Hero50001_Skill2_Data:ParseCsv(parsedData)
    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.allyTargetPosition = tonumber(parsedData.ally_target_position)
    self.allyTargetNumber = tonumber(parsedData.ally_target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.bonusDamage = tonumber(parsedData.bonus_damage)
    self.hpPercentToHeal = tonumber(parsedData.hp_percent_to_heal)
end

return Hero50001_Skill2_Data