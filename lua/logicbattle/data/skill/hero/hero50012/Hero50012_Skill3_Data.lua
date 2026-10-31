--- @class Hero50012_Skill3_Data Alvar
Hero50012_Skill3_Data = Class(Hero50012_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50012_Skill3_Data:CreateInstance()
    return Hero50012_Skill3_Data()
end

--- @return void
function Hero50012_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type_1 ~= nil, "stat_buff_type_1 = nil")
    assert(parsedData.stat_buff_amount_1 ~= nil, "stat_buff_amount_1 = nil")

    assert(parsedData.stat_buff_type_2 ~= nil, "stat_buff_type_2 = nil")
    assert(parsedData.stat_buff_amount_2 ~= nil, "stat_buff_amount_2 = nil")

    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

--- @return void
function Hero50012_Skill3_Data:ParseCsv(parsedData)
    self.statBuffType_1 = tonumber(parsedData.stat_buff_type_1)
    self.statBuffAmount_1 = tonumber(parsedData.stat_buff_amount_1)

    self.statBuffType_2 = tonumber(parsedData.stat_buff_type_2)
    self.statBuffAmount_2 = tonumber(parsedData.stat_buff_amount_2)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
end

return Hero50012_Skill3_Data