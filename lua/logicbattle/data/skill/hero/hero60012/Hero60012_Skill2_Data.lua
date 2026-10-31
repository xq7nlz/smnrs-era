--- @class Hero60012_Skill2_Data Juan
Hero60012_Skill2_Data = Class(Hero60012_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60012_Skill2_Data:CreateInstance()
    return Hero60012_Skill2_Data()
end

--- @return void
function Hero60012_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_dot_chance ~= nil, "effect_dot_chance = nil")
    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_dot_duration ~= nil, "effect_dot_duration = nil")
end

--- @return void
function Hero60012_Skill2_Data: ParseCsv(parsedData)
    self.effectDotChance = tonumber(parsedData.effect_dot_chance)
    self.effectDotType = tonumber(parsedData.effect_dot_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectDotDuration = tonumber(parsedData.effect_dot_duration)
end

return Hero60012_Skill2_Data