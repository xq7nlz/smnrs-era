--- @class Hero20014_Skill4_Data
Hero20014_Skill4_Data = Class(Hero20014_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20014_Skill4_Data:CreateInstance()
    return Hero20014_Skill4_Data()
end

---- @return void
function Hero20014_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.power_buff_target_position ~= nil, "power_buff_target_position = nil")

    assert(parsedData.power_buff_target_number ~= nil, "power_buff_target_number = nil")
    assert(parsedData.power_buff_amount ~= nil, "power_buff_amount = nil")
end

---- @return void
function Hero20014_Skill4_Data:ParseCsv(parsedData)
    self.powerBuffAmount = tonumber(parsedData.power_buff_amount)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.targetPositionBuffPower = tonumber(parsedData.power_buff_target_position)
    self.targetNumberBuffPower = tonumber(parsedData.power_buff_target_number)
end

return Hero20014_Skill4_Data