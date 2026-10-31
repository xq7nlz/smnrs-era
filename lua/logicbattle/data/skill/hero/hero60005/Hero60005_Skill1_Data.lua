--- @class Hero60005_Skill1_Data Carnifex
Hero60005_Skill1_Data = Class(Hero60005_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60005_Skill1_Data:CreateInstance()
    return Hero60005_Skill1_Data()
end

--- @return void
function Hero60005_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.hp_trigger_crit_rate ~= nil, "hp_trigger_crit_rate = nil")

    assert(parsedData.max_hp_to_kill ~= nil, "max_hp_to_kill = nil")
end

--- @return void
function Hero60005_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetNumber = tonumber(parsedData.damage_target_number)
    self.targetPosition = tonumber(parsedData.damage_target_position)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.hpTriggerCritRate = tonumber(parsedData.hp_trigger_crit_rate)

    self.maxHpToKill = tonumber(parsedData.max_hp_to_kill)
end

return Hero60005_Skill1_Data