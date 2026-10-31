--- @class Hero50023_Skill3_Data Dancer
Hero50023_Skill3_Data = Class(Hero50023_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50023_Skill3_Data:CreateInstance()
    return Hero50023_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero50023_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero50023_Skill3_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50023_Skill3_Data
