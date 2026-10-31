--- @class Hero40011_Skill3_Data Neutar
Hero40011_Skill3_Data = Class(Hero40011_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40011_Skill3_Data:CreateInstance()
    return Hero40011_Skill3_Data()
end

--- @return void
function Hero40011_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.front_stat ~= nil, "front_stat = nil")
    assert(parsedData.front_stat_amount ~= nil, "front_stat_amount = nil")

    assert(parsedData.back_stat_1 ~= nil, "back_stat_1 = nil")
    assert(parsedData.back_stat_amount_1 ~= nil, "back_stat_amount_1 = nil")

    assert(parsedData.back_stat_2 ~= nil, "back_stat_2 = nil")
    assert(parsedData.back_stat_amount_2 ~= nil, "back_stat_amount_2 = nil")

    assert(parsedData.back_stat_3 ~= nil, "back_stat_3 = nil")
    assert(parsedData.back_stat_amount_3 ~= nil, "back_stat_amount_3 = nil")
end

--- @return void
function Hero40011_Skill3_Data: ParseCsv(parsedData)
    self.frontStatType = tonumber(parsedData.front_stat)
    self.frontStatAmount = tonumber(parsedData.front_stat_amount)

    self.backStatType_1 = tonumber(parsedData.back_stat_1)
    self.backStatAmount_1 = tonumber(parsedData.back_stat_amount_1)

    self.backStatType_2 = tonumber(parsedData.back_stat_2)
    self.backStatAmount_2 = tonumber(parsedData.back_stat_amount_2)

    self.backStatType_3 = tonumber(parsedData.back_stat_3)
    self.backStatAmount_3 = tonumber(parsedData.back_stat_amount_3)
end

return Hero40011_Skill3_Data