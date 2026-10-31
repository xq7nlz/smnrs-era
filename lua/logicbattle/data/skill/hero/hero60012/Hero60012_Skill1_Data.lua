--- @class Hero60012_Skill1_Data Juan
Hero60012_Skill1_Data = Class(Hero60012_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60012_Skill1_Data:CreateInstance()
    return Hero60012_Skill1_Data()
end

--- @return void
function Hero60012_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_trigger_class ~= nil, "effect_trigger_class = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.bonus_damage_with_class ~= nil, "bonus_damage_with_class = nil")
end

--- @return void
function Hero60012_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectTriggerClass = tonumber(parsedData.effect_trigger_class)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.bonusDamageWithClass = tonumber(parsedData.bonus_damage_with_class)
end

return Hero60012_Skill1_Data