--- @class Hero30009_Skill3_Data Gorzodin
Hero30009_Skill3_Data = Class(Hero30009_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30009_Skill3_Data:CreateInstance()
    return Hero30009_Skill3_Data()
end

--- @return void
function Hero30009_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.splash_damage ~= nil, "splash_damage = nil")
    assert(parsedData.splash_vertical_range ~= nil, "splash_vertical_range = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero30009_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.splashDamage = tonumber(parsedData.splash_damage)
    self.splashVerticalRange = tonumber(parsedData.splash_vertical_range)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero30009_Skill3_Data