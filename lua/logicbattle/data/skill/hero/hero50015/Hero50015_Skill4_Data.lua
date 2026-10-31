--- @class Hero50015_Skill4_Data Navro
Hero50015_Skill4_Data = Class(Hero50015_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50015_Skill4_Data:CreateInstance()
    return Hero50015_Skill4_Data()
end

---- @return void
function Hero50015_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")

    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

---- @return void
function Hero50015_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)

    self.targetPositionBuff = tonumber(parsedData.stat_buff_target_position)
    self.targetNumberBuff = tonumber(parsedData.stat_buff_target_number)
end

return Hero50015_Skill4_Data