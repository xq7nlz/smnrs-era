--- @class Hero40003_Skill2_Data Arryl
Hero40003_Skill2_Data = Class(Hero40003_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40003_Skill2_Data:CreateInstance()
    return Hero40003_Skill2_Data()
end

--- @return void
function Hero40003_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")

    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")

    assert(parsedData.effect_dryad_duration ~= nil, "effect_dryad_duration = nil")
    assert(parsedData.effect_dryad_amount ~= nil, "effect_dryad_amount = nil")
end

--- @return void
function Hero40003_Skill2_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)

    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)

    self.effectDryadDuration = tonumber(parsedData.effect_dryad_duration)
    self.effectDryadAmount = tonumber(parsedData.effect_dryad_amount)
end

return Hero40003_Skill2_Data