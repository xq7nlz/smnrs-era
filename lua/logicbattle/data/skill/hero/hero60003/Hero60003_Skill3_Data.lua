--- @class Hero60003_Skill3_Data ShadowBlade
Hero60003_Skill3_Data = Class(Hero60003_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60003_Skill3_Data:CreateInstance()
    return Hero60003_Skill3_Data()
end

--- @return void
function Hero60003_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.percent_trigger ~= nil, "percent_trigger = nil")

    assert(parsedData.stat_buff_1_type ~= nil, "stat_buff_1_type = nil")
    assert(parsedData.stat_buff_1_amount ~= nil, "stat_buff_1_amount = nil")

    assert(parsedData.stat_buff_2_type ~= nil, "stat_buff_2_type = nil")
    assert(parsedData.stat_buff_2_amount ~= nil, "stat_buff_2_amount = nil")

    assert(parsedData.stat_buff_3_type ~= nil, "stat_buff_3_type = nil")
    assert(parsedData.stat_buff_3_amount ~= nil, "stat_buff_3_amount = nil")
end

--- @return void
function Hero60003_Skill3_Data:ParseCsv(parsedData)
    self.percentTrigger = tonumber(parsedData.percent_trigger)

    self.statFirstBuffType = tonumber(parsedData.stat_buff_1_type)
    self.statFirstBuffAmount = tonumber(parsedData.stat_buff_1_amount)

    self.statSecondBuffType = tonumber(parsedData.stat_buff_2_type)
    self.statSecondBuffAmount = tonumber(parsedData.stat_buff_2_amount)

    self.statThirdType = tonumber(parsedData.stat_buff_3_type)
    self.statThirdAmount = tonumber(parsedData.stat_buff_3_amount)
end

return Hero60003_Skill3_Data