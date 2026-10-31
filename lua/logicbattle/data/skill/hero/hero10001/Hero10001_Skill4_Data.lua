--- @class Hero10001_Skill4_Data
Hero10001_Skill4_Data = Class(Hero10001_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10001_Skill4_Data:CreateInstance()
    return Hero10001_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")

    assert(parsedData.reflect_chance ~= nil, "reflect_chance = nil")
    assert(parsedData.reflect_damage ~= nil, "reflect_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero10001_Skill4_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.reflectChance = tonumber(parsedData.reflect_chance)
    self.reflectDamage = tonumber(parsedData.reflect_damage)
end

return Hero10001_Skill4_Data
