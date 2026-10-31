--- @class Hero40026_Skill2_Data Neyuh
Hero40026_Skill2_Data = Class(Hero40026_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40026_Skill2_Data:CreateInstance()
    return Hero40026_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero40026_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_stat_front_line ~= nil, "buff_stat_front_line = nil")
    assert(parsedData.buff_amount_front_line ~= nil, "buff_amount_front_line = nil")

    assert(parsedData.buff_stat_back_line ~= nil, "buff_stat_back_line = nil")
    assert(parsedData.buff_amount_back_line ~= nil, "buff_amount_back_line = nil")
end

--- @return void
--- @param parsedData table
function Hero40026_Skill2_Data:ParseCsv(parsedData)
    self.frontStatType = tonumber(parsedData.buff_stat_front_line)
    self.frontStatAmount = tonumber(parsedData.buff_amount_front_line)

    self.backStatType = tonumber(parsedData.buff_stat_back_line)
    self.backStatAmount = tonumber(parsedData.buff_amount_back_line)
end

return Hero40026_Skill2_Data
