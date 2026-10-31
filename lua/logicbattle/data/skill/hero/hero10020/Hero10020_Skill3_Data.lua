--- @class Hero10020_Skill3_Data Sniper
Hero10020_Skill3_Data = Class(Hero10020_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10020_Skill3_Data:CreateInstance()
    return Hero10020_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10020_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_stat_front_line ~= nil, "buff_stat_front_line = nil")
    assert(parsedData.buff_amount_front_line ~= nil, "buff_amount_front_line = nil")

    assert(parsedData.buff_stat_back_line ~= nil, "buff_stat_back_line = nil")
    assert(parsedData.buff_amount_back_line ~= nil, "buff_amount_back_line = nil")
end

--- @return void
--- @param parsedData table
function Hero10020_Skill3_Data:ParseCsv(parsedData)
    self.buffStatFrontLine = tonumber(parsedData.buff_stat_front_line)
    self.buffAmountFrontLine = tonumber(parsedData.buff_amount_front_line)

    self.buffStatBackLine = tonumber(parsedData.buff_stat_back_line)
    self.buffAmountBackLine = tonumber(parsedData.buff_amount_back_line)
end

return Hero10020_Skill3_Data