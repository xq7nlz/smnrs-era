--- @class Hero50010_Skill3_Data Sephion
Hero50010_Skill3_Data = Class(Hero50010_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50010_Skill3_Data:CreateInstance()
    return Hero50010_Skill3_Data()
end

--- @return void
function Hero50010_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.number_buff ~= nil, "number_buff = nil")
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero50010_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)

    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.numberBuff = tonumber(parsedData.number_buff)
end

return Hero50010_Skill3_Data