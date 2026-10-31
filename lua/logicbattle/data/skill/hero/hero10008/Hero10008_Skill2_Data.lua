--- @class Hero10008_Skill2_Data Mammusk
Hero10008_Skill2_Data = Class(Hero10008_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10008_Skill2_Data:CreateInstance()
    return Hero10008_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10008_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")

    assert(parsedData.power_gain_value ~= nil, "power_gain_value = nil")
end

--- @return void
--- @param parsedData table
function Hero10008_Skill2_Data:ParseCsv(parsedData)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)

    self.powerGainValue = tonumber(parsedData.power_gain_value)
end

return Hero10008_Skill2_Data