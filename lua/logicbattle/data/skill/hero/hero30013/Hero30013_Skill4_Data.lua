--- @class Hero30013_Skill4_Data Minimanser
Hero30013_Skill4_Data = Class(Hero30013_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero30013_Skill4_Data:CreateInstance()
    return Hero30013_Skill4_Data()
end

--- @return void
function Hero30013_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_duration ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero30013_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero30013_Skill4_Data
