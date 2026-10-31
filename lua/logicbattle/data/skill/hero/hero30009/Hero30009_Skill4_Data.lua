--- @class Hero30009_Skill4_Data Gorzodin
Hero30009_Skill4_Data = Class(Hero30009_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30009_Skill4_Data:CreateInstance()
    return Hero30009_Skill4_Data()
end

--- @return void
function Hero30009_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_stat_front_line ~= nil, "buff_stat_front_line = nil")
    assert(parsedData.buff_amount_front_line ~= nil, "buff_amount_front_line = nil")

    assert(parsedData.buff_stat_back_line ~= nil, "buff_stat_back_line = nil")
    assert(parsedData.buff_amount_back_line ~= nil, "buff_amount_back_line = nil")
end

--- @return void
function Hero30009_Skill4_Data:ParseCsv(parsedData)
    self.buffStatFrontLine = tonumber(parsedData.buff_stat_front_line)
    self.buffAmountFrontLine = tonumber(parsedData.buff_amount_front_line)

    self.buffStatBackLine = tonumber(parsedData.buff_stat_back_line)
    self.buffAmountBackLine = tonumber(parsedData.buff_amount_back_line)
end

return Hero30009_Skill4_Data