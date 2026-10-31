--- @class Hero30019_Skill4_Data Elne
Hero30019_Skill4_Data = Class(Hero30019_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero30019_Skill4_Data:CreateInstance()
    return Hero30019_Skill4_Data()
end

--- @return void
function Hero30019_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero30019_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero30019_Skill4_Data
