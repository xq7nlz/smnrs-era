--- @class Hero10023_Skill1_Data Krag
Hero10023_Skill1_Data = Class(Hero10023_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10023_Skill1_Data:CreateInstance()
    return Hero10023_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10023_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.dot_type ~= nil, "dot_type = nil")
    assert(parsedData.dot_chance ~= nil, "dot_chance = nil")
    assert(parsedData.dot_duration ~= nil, "dot_duration = nil")
    assert(parsedData.dot_amount ~= nil, "dot_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10023_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.dotChance = tonumber(parsedData.dot_chance)
    self.dotType = tonumber(parsedData.dot_type)

    self.dotDuration = tonumber(parsedData.dot_duration)
    self.dotAmount = tonumber(parsedData.dot_amount)
end

return Hero10023_Skill1_Data