--- @class Hero40003_Skill1_Data Arryl
Hero40003_Skill1_Data = Class(Hero40003_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40003_Skill1_Data:CreateInstance()
    return Hero40003_Skill1_Data()
end

--- @return void
function Hero40003_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
    assert(parsedData.effect_dryad_duration ~= nil, "effect_dryad_duration = nil")
    assert(parsedData.effect_dryad_amount ~= nil, "effect_dryad_amount = nil")
end

--- @return void
function Hero40003_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
    self.effectDryadDuration = tonumber(parsedData.effect_dryad_duration)
    self.effectDryadAmount = tonumber(parsedData.effect_dryad_amount)
end

return Hero40003_Skill1_Data