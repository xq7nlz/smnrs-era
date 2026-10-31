--- @class Hero60004_Skill4_Data Karos
Hero60004_Skill4_Data = Class(Hero60004_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60004_Skill4_Data:CreateInstance()
    return Hero60004_Skill4_Data()
end

--- @return void
function Hero60004_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
function Hero60004_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero60004_Skill4_Data