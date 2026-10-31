--- @class Hero50010_Skill1_Data Shephion
Hero50010_Skill1_Data = Class(Hero50010_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50010_Skill1_Data:CreateInstance()
    return Hero50010_Skill1_Data()
end

--- @return void
function Hero50010_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_min ~= nil, "damage_min = nil")
    assert(parsedData.damage_max ~= nil, "damage_max = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number_min ~= nil, "target_number_min = nil")
    assert(parsedData.target_number_max ~= nil, "target_number_max = nil")

    assert(parsedData.silence_chance_debuff_mage ~= nil, "silence_chance_debuff_mage = nil")
    assert(parsedData.effect_type_debuff_warrior ~= nil, "effect_type_debuff_warrior = nil")
    assert(parsedData.effect_chance_debuff_warrior ~= nil, "effect_chance_debuff_warrior = nil")

    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50010_Skill1_Data:ParseCsv(parsedData)
    self.damageMin = tonumber(parsedData.damage_min)
    self.damageMax = tonumber(parsedData.damage_max)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumberMin = tonumber(parsedData.target_number_min)
    self.targetNumberMax = tonumber(parsedData.target_number_max)

    self.silenceChanceDebuffMage = tonumber(parsedData.silence_chance_debuff_mage)
    self.effectTypeDebuffWarrior = tonumber(parsedData.effect_type_debuff_warrior)
    self.effectChanceDebuffWarrior = tonumber(parsedData.effect_chance_debuff_warrior)

    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50010_Skill1_Data