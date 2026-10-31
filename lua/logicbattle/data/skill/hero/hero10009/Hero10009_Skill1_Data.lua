--- @class Hero10009_Skill1_Data Lashna
Hero10009_Skill1_Data = Class(Hero10009_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10009_Skill1_Data:CreateInstance()
    return Hero10009_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10009_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.effect_trigger_class ~= nil, "effect_trigger_class = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10009_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.effectTriggerClass = tonumber(parsedData.effect_trigger_class)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10009_Skill1_Data