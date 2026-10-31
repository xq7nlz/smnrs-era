--- @class Hero10022_Skill4_Data AquaMage
Hero10022_Skill4_Data = Class(Hero10022_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10022_Skill4_Data:CreateInstance()
    return Hero10022_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10022_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_duration ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_calculation_type ~= nil, "stat_buff_calculation_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10022_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffCalculationType = tonumber(parsedData.stat_buff_calculation_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero10022_Skill4_Data
