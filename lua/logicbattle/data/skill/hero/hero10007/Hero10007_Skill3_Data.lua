--- @class Hero10007_Skill3_Data Osse
Hero10007_Skill3_Data = Class(Hero10007_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10007_Skill3_Data:CreateInstance()
    return Hero10007_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10007_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_affect_to_stat ~= nil, "effect_affect_to_stat = nil")
    assert(parsedData.effect_stat_calculation_type ~= nil, "effect_stat_calculation_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10007_Skill3_Data:ParseCsv(parsedData)
    self.statType = tonumber(parsedData.effect_affect_to_stat)
    self.calculationType = tonumber(parsedData.effect_stat_calculation_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero10007_Skill3_Data