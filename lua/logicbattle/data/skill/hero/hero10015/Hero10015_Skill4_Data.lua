--- @class Hero10015_Skill4_Data Aesa
Hero10015_Skill4_Data = Class(Hero10015_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10015_Skill4_Data:CreateInstance()
    return Hero10015_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10015_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10015_Skill4_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10015_Skill4_Data