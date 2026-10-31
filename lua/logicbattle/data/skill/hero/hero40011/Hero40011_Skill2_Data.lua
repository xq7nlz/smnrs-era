--- @class Hero40011_Skill2_Data Neutar
Hero40011_Skill2_Data = Class(Hero40011_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40011_Skill2_Data:CreateInstance()
    return Hero40011_Skill2_Data()
end

--- @return void
function Hero40011_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero40011_Skill2_Data: ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero40011_Skill2_Data