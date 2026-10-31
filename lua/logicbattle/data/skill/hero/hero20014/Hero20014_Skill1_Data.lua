--- @class Hero20014_Skill1_Data Khezzec
Hero20014_Skill1_Data = Class(Hero20014_Skill1_Data, BaseSkillData)

--- @return void
function Hero20014_Skill1_Data:CreateInstance()
    return Hero20014_Skill1_Data()
end

--- @return void
function Hero20014_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")    assert(parsedData.power_buff_target_position ~= nil, "power_buff_target_position = nil")
    assert(parsedData.power_buff_target_number ~= nil, "power_buff_target_number = nil")
    assert(parsedData.power_buff_amount ~= nil, "power_buff_amount = nil")
end

--- @return void
function Hero20014_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.powerBuffAmount = tonumber(parsedData.power_buff_amount)
    self.powerBuffTargetNumber = tonumber(parsedData.power_buff_target_number)
    self.powerBuffTargetPosition = tonumber(parsedData.power_buff_target_position)
end

return Hero20014_Skill1_Data