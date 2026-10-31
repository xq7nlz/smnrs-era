--- @class Hero10010_Skill4_Data Japulan
Hero10010_Skill4_Data = Class(Hero10010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10010_Skill4_Data:CreateInstance()
    return Hero10010_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_duration ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_1_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_1_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10010_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero10010_Skill4_Data
