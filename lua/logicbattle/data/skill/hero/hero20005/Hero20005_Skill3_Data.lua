--- @class Hero20005_Skill3_Data Yin
Hero20005_Skill3_Data = Class(Hero20005_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20005_Skill3_Data:CreateInstance()
    return Hero20005_Skill3_Data()
end

--- @return void
function Hero20005_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.splash_damage ~= nil, "splash_damage = nil")
    assert(parsedData.splash_vertical_range ~= nil, "splash_vertical_range = nil")

    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")

    assert(parsedData.dot_chance ~= nil, "dot_chance = nil")
    assert(parsedData.dot_duration ~= nil, "dot_duration = nil")
    assert(parsedData.dot_amount ~= nil, "dot_amount = nil")
end

--- @return void
function Hero20005_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.splashDamage = tonumber(parsedData.splash_damage)
    self.splashVerticalRange = tonumber(parsedData.splash_vertical_range)

    self.effectDotType = tonumber(parsedData.effect_dot_type)

    self.dotAmount = tonumber(parsedData.dot_amount)
    self.dotChance = tonumber(parsedData.dot_chance)
    self.dotDuration = tonumber(parsedData.dot_duration)
end

return Hero20005_Skill3_Data
