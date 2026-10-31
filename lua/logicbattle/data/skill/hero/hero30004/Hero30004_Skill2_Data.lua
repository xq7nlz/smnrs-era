--- @class Hero30004_Skill2_Data Stheno
Hero30004_Skill2_Data = Class(Hero30004_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30004_Skill2_Data:CreateInstance()
    return Hero30004_Skill2_Data()
end

--- @return void
function Hero30004_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_percent ~= nil, "effect_percent = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_percent ~= nil, "stat_debuff_percent = nil")
    assert(parsedData.stat_debuff_calculation_type ~= nil, "stat_debuff_calculation_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
end

--- @return void
function Hero30004_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_percent)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_percent)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
end

return Hero30004_Skill2_Data