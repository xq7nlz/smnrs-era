--- @class Hero50013_Skill3_Data Celes
Hero50013_Skill3_Data = Class(Hero50013_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50013_Skill3_Data:CreateInstance()
    return Hero50013_Skill3_Data()
end

--- @return void
function Hero50013_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")
    assert(parsedData.block_rate ~= nil, "block_rate = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50013_Skill3_Data:ParseCsv(parsedData)
    self.triggerChance = tonumber(parsedData.trigger_chance)
    self.blockRate = tonumber(parsedData.block_rate)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50013_Skill3_Data