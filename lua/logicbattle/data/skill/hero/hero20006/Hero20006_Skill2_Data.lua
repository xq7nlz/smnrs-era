--- @class Hero20006_Skill2_Data Finde
Hero20006_Skill2_Data = Class(Hero20006_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20006_Skill2_Data:CreateInstance()
    return Hero20006_Skill2_Data()
end

--- @return void
function Hero20006_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_stat_debuff_type ~= nil, "effect_stat_debuff_type = nil")
    assert(parsedData.effect_stat_debuff_amount ~= nil, "effect_stat_debuff_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero20006_Skill2_Data: ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectStatDebuffType = tonumber(parsedData.effect_stat_debuff_type)
    self.effectStatDebuffAmount = tonumber(parsedData.effect_stat_debuff_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero20006_Skill2_Data