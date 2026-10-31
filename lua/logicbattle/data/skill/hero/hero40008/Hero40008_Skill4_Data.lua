--- @class Hero40008_Skill4_Data Lass
Hero40008_Skill4_Data = Class(Hero40008_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40008_Skill4_Data:CreateInstance()
    return Hero40008_Skill4_Data()
end

--- @return void
function Hero40008_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.resistance_effect_rate_1 ~= nil, "resistance_effect_rate_1 = nil")
    assert(parsedData.resistance_effect_type_1 ~= nil, "resistance_effect_type_1 = nil")

    assert(parsedData.resistance_effect_rate_2 ~= nil, "resistance_effect_rate_2 = nil")
    assert(parsedData.resistance_effect_type_2 ~= nil, "resistance_effect_type_2 = nil")

    assert(parsedData.effect_dot_chance ~= nil, "effect_dot_chance = nil")
    assert(parsedData.effect_dot_type ~= nil, "effect_dot_type = nil")
    assert(parsedData.effect_dot_amount ~= nil, "effect_dot_amount = nil")
    assert(parsedData.effect_dot_duration ~= nil, "effect_dot_duration = nil")

    assert(parsedData.silence_chance ~= nil, "silence_chance = nil")
    assert(parsedData.silence_duration ~= nil, "silence_duration = nil")
end

--- @return void
function Hero40008_Skill4_Data:ParseCsv(parsedData)
    self.effectDotChance = tonumber(parsedData.effect_dot_chance)
    self.effectDotType = tonumber(parsedData.effect_dot_type)
    self.effectDotAmount = tonumber(parsedData.effect_dot_amount)
    self.effectDotDuration = tonumber(parsedData.effect_dot_duration)

    self.silenceChance = tonumber(parsedData.silence_chance)
    self.silenceDuration = tonumber(parsedData.silence_duration)

    self.resistanceEffectRate_1 = tonumber(parsedData.resistance_effect_rate_1)
    self.resistanceEffectType_1 = tonumber(parsedData.resistance_effect_type_1)

    self.resistanceEffectRate_2 = tonumber(parsedData.resistance_effect_rate_2)
    self.resistanceEffectType_2 = tonumber(parsedData.resistance_effect_type_2)
end

return Hero40008_Skill4_Data