--- @class Hero50006_Skill1_Data Enule
Hero50006_Skill1_Data = Class(Hero50006_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50006_Skill1_Data:CreateInstance()
    return Hero50006_Skill1_Data()
end

--- @return void
function Hero50006_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50006_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetNumber = tonumber(parsedData.target_number)
    self.targetPosition = tonumber(parsedData.target_position)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50006_Skill1_Data