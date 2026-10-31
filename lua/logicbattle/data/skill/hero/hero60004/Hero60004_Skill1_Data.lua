--- @class Hero60004_Skill1_Data Karos
Hero60004_Skill1_Data = Class(Hero60004_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60004_Skill1_Data:CreateInstance()
    return Hero60004_Skill1_Data()
end

--- @return void
function Hero60004_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero60004_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetNumber = tonumber(parsedData.damage_target_number)
    self.targetPosition = tonumber(parsedData.damage_target_position)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero60004_Skill1_Data