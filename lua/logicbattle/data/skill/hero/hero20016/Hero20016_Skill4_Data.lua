--- @class Hero20016_Skill4_Data Ifrit
Hero20016_Skill4_Data = Class(Hero20016_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20016_Skill4_Data:CreateInstance()
    return Hero20016_Skill4_Data()
end

--- @return void
function Hero20016_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero20016_Skill4_Data:ParseCsv(parsedData)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.statBuffTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.statBuffTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero20016_Skill4_Data