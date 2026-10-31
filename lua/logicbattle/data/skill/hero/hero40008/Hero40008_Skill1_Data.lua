--- @class Hero40008_Skill1_Data Lass
Hero40008_Skill1_Data = Class(Hero40008_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40008_Skill1_Data:CreateInstance()
    return Hero40008_Skill1_Data()
end

--- @return void
function Hero40008_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.silence_chance ~= nil, "silence_chance = nil")
    assert(parsedData.silence_duration ~= nil, "silence_duration = nil")
end

--- @return void
function Hero40008_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.silenceChance = tonumber(parsedData.silence_chance)
    self.silenceDuration = tonumber(parsedData.silence_duration)
end

return Hero40008_Skill1_Data