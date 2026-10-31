--- @class Hero60003_Skill2_Data ShadowBlade
Hero60003_Skill2_Data = Class(Hero60003_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60003_Skill2_Data:CreateInstance()
    return Hero60003_Skill2_Data()
end

--- @return void
function Hero60003_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
function Hero60003_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero60003_Skill2_Data