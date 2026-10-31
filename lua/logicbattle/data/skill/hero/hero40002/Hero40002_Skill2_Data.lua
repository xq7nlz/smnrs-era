--- @class Hero40002_Skill2_Data Yggra
Hero40002_Skill2_Data = Class(Hero40002_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40002_Skill2_Data:CreateInstance()
    return Hero40002_Skill2_Data()
end

--- @return void
function Hero40002_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_affect_to_stat ~= nil, "effect_affect_to_stat = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
function Hero40002_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAffectStat = tonumber(parsedData.effect_affect_to_stat)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero40002_Skill2_Data