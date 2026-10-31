--- @class Hero40001_Skill4_Data Tilion
Hero40001_Skill4_Data = Class(Hero40001_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40001_Skill4_Data:CreateInstance()
    return Hero40001_Skill4_Data()
end

--- @return void
function Hero40001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")

    assert(parsedData.effect_target_position ~= nil, "effect_target_position = nil")
    assert(parsedData.effect_target_number ~= nil, "effect_target_number = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero40001_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)
    self.triggerChance = tonumber(parsedData.trigger_chance)

    self.effectTargetPosition = tonumber(parsedData.effect_target_position)
    self.effectTargetNumber = tonumber(parsedData.effect_target_number)

    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)

    self.statBuffTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.statBuffTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero40001_Skill4_Data