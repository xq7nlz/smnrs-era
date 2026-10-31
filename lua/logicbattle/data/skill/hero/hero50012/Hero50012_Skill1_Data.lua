--- @class Hero50012_Skill1_Data Alvar
Hero50012_Skill1_Data = Class(Hero50012_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50012_Skill1_Data:CreateInstance()
    return Hero50012_Skill1_Data()
end

--- @return void
function Hero50012_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_percent_of_damage ~= nil, "heal_percent_of_damage = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
end

--- @return void
function Hero50012_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetNumber = tonumber(parsedData.damage_target_number)
    self.damageTargetPosition = tonumber(parsedData.damage_target_position)

    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)

    self.healPercentOfDamage = tonumber(parsedData.heal_percent_of_damage)
end

return Hero50012_Skill1_Data