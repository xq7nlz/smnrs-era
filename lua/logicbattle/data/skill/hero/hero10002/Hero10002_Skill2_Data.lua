--- @class Hero10002_Skill2_Data Sharpwater
Hero10002_Skill2_Data = Class(Hero10002_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10002_Skill2_Data:CreateInstance()
    return Hero10002_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10002_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10002_Skill2_Data:ParseCsv(parsedData)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero10002_Skill2_Data