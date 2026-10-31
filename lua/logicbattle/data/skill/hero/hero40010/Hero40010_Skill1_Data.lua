--- @class Hero40010_Skill1_Data Yome
Hero40010_Skill1_Data = Class(Hero40010_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40010_Skill1_Data:CreateInstance()
    return Hero40010_Skill1_Data()
end

--- @return void
function Hero40010_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.dot_amount ~= nil, "dot_amount = nil")
    assert(parsedData.dot_type ~= nil, "dot_type = nil")
    assert(parsedData.dot_chance ~= nil, "dot_chance = nil")
    assert(parsedData.dot_duration ~= nil, "dot_duration = nil")
end

--- @return void
function Hero40010_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.target_position)
    self.damageTargetNumber = tonumber(parsedData.target_number)

    self.dotAmount = tonumber(parsedData.dot_amount)
    self.dotType = tonumber(parsedData.dot_type)
    self.dotChance = tonumber(parsedData.dot_chance)
    self.dotDuration = tonumber(parsedData.dot_duration)
end

return Hero40010_Skill1_Data