--- @class Hero20002_Skill2_Data Arien
Hero20002_Skill2_Data = Class(Hero20002_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20002_Skill2_Data:CreateInstance()
    return Hero20002_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero20002_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_1_type ~= nil, "effect_1_type = nil")
    assert(parsedData.effect_1_amount ~= nil, "effect_1_amount = nil")

    assert(parsedData.effect_1_target_position ~= nil, "effect_1_target_position = nil")
    assert(parsedData.effect_1_target_number ~= nil, "effect_1_target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero20002_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_1_type)
    self.effectAmount = tonumber(parsedData.effect_1_amount)

    self.targetPosition = tonumber(parsedData.effect_1_target_position)
    self.targetNumber = tonumber(parsedData.effect_1_target_number)
end

return Hero20002_Skill2_Data