--- @class Hero10017_Skill4_Data Glugrgly
Hero10017_Skill4_Data = Class(Hero10017_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10017_Skill4_Data:CreateInstance()
    return Hero10017_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10017_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero10017_Skill4_Data:ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)

    self.statBuffTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.statBuffTargetNumber = tonumber(parsedData.stat_buff_target_number)
end

return Hero10017_Skill4_Data