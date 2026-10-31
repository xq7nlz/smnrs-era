--- @class Hero10006_Skill4_Data Aqualord
Hero10006_Skill4_Data = Class(Hero10006_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10006_Skill4_Data:CreateInstance()
    return Hero10006_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")

    assert(parsedData.effect_target_position ~= nil, "effect_target_position = nil")
    assert(parsedData.effect_target_number ~= nil, "effect_target_number = nil")

    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
    assert(parsedData.effect_amount ~= nil, "effect_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10006_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)
    self.triggerChance = tonumber(parsedData.trigger_chance)

    self.effectTargetPosition = tonumber(parsedData.effect_target_position)
    self.effectTargetNumber = tonumber(parsedData.effect_target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
    self.effectAmount = tonumber(parsedData.effect_amount)
end

return Hero10006_Skill4_Data