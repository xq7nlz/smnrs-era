--- @class Hero10020_Skill4_Data Sniper
Hero10020_Skill4_Data = Class(Hero10020_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10020_Skill4_Data:CreateInstance()
    return Hero10020_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10020_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10020_Skill4_Data:ParseCsv(parsedData)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10020_Skill4_Data