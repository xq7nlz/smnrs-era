--- @class Hero60014_Skill4_Data ShiShil
Hero60014_Skill4_Data = Class(Hero60014_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60014_Skill4_Data:CreateInstance()
    return Hero60014_Skill4_Data()
end

--- @return void
function Hero60014_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero60014_Skill4_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero60014_Skill4_Data