--- @class Hero20001_Skill1_Data Icarus
Hero20001_Skill1_Data = Class(Hero20001_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20001_Skill1_Data:CreateInstance()
    return Hero20001_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero20001_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")

    assert(parsedData.effect_debuff_type ~= nil, "effect_debuff_type = nil")
    assert(parsedData.effect_debuff_amount ~= nil, "effect_debuff_amount = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_calculation_type ~= nil, "stat_debuff_calculation_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero20001_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffCalculationType = tonumber(parsedData.stat_debuff_calculation_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)

    self.effectDebuffType = tonumber(parsedData.effect_debuff_type)
    self.effectDebuffAmount = tonumber(parsedData.effect_debuff_amount)
end

return Hero20001_Skill1_Data