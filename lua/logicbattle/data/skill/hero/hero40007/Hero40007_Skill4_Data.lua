--- @class Hero40007_Skill4_Data Noroth
Hero40007_Skill4_Data = Class(Hero40007_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40007_Skill4_Data:CreateInstance()
    return Hero40007_Skill4_Data()
end

--- @return void
function Hero40007_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero40007_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)

    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero40007_Skill4_Data
