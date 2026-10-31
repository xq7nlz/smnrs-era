--- @class Hero10001_Skill1_Data
Hero10001_Skill1_Data = Class(Hero10001_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10001_Skill1_Data:CreateInstance()
    return Hero10001_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10001_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10001_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10001_Skill1_Data
