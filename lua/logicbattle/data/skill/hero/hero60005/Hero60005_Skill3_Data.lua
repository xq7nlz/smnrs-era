--- @class Hero60005_Skill3_Data Karos
Hero60005_Skill3_Data = Class(Hero60005_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60005_Skill3_Data:CreateInstance()
    return Hero60005_Skill3_Data()
end

--- @return void
function Hero60005_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_target_position ~= nil, "effect_amount = nil")
    assert(parsedData.damage_target_number ~= nil, "effect_amount = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_calculation_type ~= nil, "stat_debuff_calculation_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_max ~= nil, "stat_debuff_max = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero60005_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffMax = tonumber(parsedData.stat_debuff_max)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero60005_Skill3_Data