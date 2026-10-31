--- @class Hero40026_Skill3_Data Neyuh
Hero40026_Skill3_Data = Class(Hero40026_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40026_Skill3_Data:CreateInstance()
    return Hero40026_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero40026_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_type ~= nil, "buff_type = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero40026_Skill3_Data:ParseCsv(parsedData)
    self.buffType = tonumber(parsedData.buff_type)
    self.buffAmount = tonumber(parsedData.buff_amount)
end

return Hero40026_Skill3_Data
