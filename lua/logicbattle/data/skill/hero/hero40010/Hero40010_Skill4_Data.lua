--- @class Hero40010_Skill4_Data Yome
Hero40010_Skill4_Data = Class(Hero40010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40010_Skill4_Data:CreateInstance()
    return Hero40010_Skill4_Data()
end

--- @return void
function Hero40010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_target_position ~= nil, "effect_target_position = nil")
    assert(parsedData.effect_target_number ~= nil, "effect_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero40010_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.effect_target_position)
    self.targetNumber = tonumber(parsedData.effect_target_number)

    self.effectDotType = tonumber(parsedData.effect_type)
    self.effectDotAmount = tonumber(parsedData.effect_amount)
    self.effectDotDuration = tonumber(parsedData.effect_duration)
end

return Hero40010_Skill4_Data