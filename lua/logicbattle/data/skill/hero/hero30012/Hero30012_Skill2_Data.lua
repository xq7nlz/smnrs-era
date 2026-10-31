--- @class Hero30012_Skill2_Data Dzuteh
Hero30012_Skill2_Data = Class(Hero30012_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30012_Skill2_Data:CreateInstance()
    return Hero30012_Skill2_Data()
end

--- @return void
function Hero30012_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_stat_front_line ~= nil, "buff_stat_front_line = nil")
    assert(parsedData.buff_amount_front_line ~= nil, "buff_amount_front_line = nil")

    assert(parsedData.buff_stat_back_line ~= nil, "buff_stat_back_line = nil")
    assert(parsedData.buff_amount_back_line ~= nil, "buff_amount_back_line = nil")
end

--- @return void
function Hero30012_Skill2_Data:ParseCsv(parsedData)
    self.buffStatFrontLine = tonumber(parsedData.buff_stat_front_line)
    self.buffAmountFrontLine = tonumber(parsedData.buff_amount_front_line)

    self.buffStatBackLine = tonumber(parsedData.buff_stat_back_line)
    self.buffAmountBackLine = tonumber(parsedData.buff_amount_back_line)
end

return Hero30012_Skill2_Data