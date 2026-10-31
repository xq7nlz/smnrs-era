--- @class Hero60009_Skill4_Data Khann
Hero60009_Skill4_Data = Class(Hero60009_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60009_Skill4_Data:CreateInstance()
    return Hero60009_Skill4_Data()
end

--- @return void
function Hero60009_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_multiplier ~= nil, "damage_multiplier = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero60009_Skill4_Data:ParseCsv(parsedData)
    self.damageMultiplier = tonumber(parsedData.damage_multiplier)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero60009_Skill4_Data
