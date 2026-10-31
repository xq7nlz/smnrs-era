--- @class Hero30012_Skill4_Data Dzuteh
Hero30012_Skill4_Data = Class(Hero30012_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero30012_Skill4_Data:CreateInstance()
    return Hero30012_Skill4_Data()
end

----------------------------------- Parse Csv -------------------------------------------
--- @return void
function Hero30012_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
function Hero30012_Skill4_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero30012_Skill4_Data