--- @class Hero60010_Skill1_Data Diadora
Hero60010_Skill1_Data = Class(Hero60010_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60010_Skill1_Data:CreateInstance()
    return Hero60010_Skill1_Data()
end

--- @return void
function Hero60010_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "target_number = nil")

    assert(parsedData.debuff_chance ~= nil, "debuff_chance = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.debuff_duration ~= nil, "debuff_duration = nil")
end

--- @return void
function Hero60010_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.debuffChance = tonumber(parsedData.debuff_chance)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)

    self.effectType = tonumber(parsedData.effect_type)
    self.debuffDuration = tonumber(parsedData.debuff_duration)
end

return Hero60010_Skill1_Data