--- @class Hero30021_Skill4_Data EarthMaster
Hero30021_Skill4_Data = Class(Hero30021_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero30021_Skill4_Data:CreateInstance()
    return Hero30021_Skill4_Data()
end

--- @return void
function Hero30021_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_calculation ~= nil, "stat_debuff_calculation = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
end

--- @return void
function Hero30021_Skill4_Data:ParseCsv(parsedData)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffCalculation = tonumber(parsedData.stat_debuff_calculation)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
end

return Hero30021_Skill4_Data