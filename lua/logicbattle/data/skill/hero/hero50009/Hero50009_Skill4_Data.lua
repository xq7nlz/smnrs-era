--- @class Hero50009_Skill4_Data Aris
Hero50009_Skill4_Data = Class(Hero50009_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50009_Skill4_Data:CreateInstance()
    return Hero50009_Skill4_Data()
end

--- @return void
function Hero50009_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50009_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50009_Skill4_Data