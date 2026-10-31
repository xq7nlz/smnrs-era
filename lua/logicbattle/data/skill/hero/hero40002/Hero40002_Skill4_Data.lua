--- @class Hero40002_Skill4_Data Yggra
Hero40002_Skill4_Data = Class(Hero40002_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40002_Skill4_Data:CreateInstance()
    return Hero40002_Skill4_Data()
end

--- @return void
function Hero40002_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")

    assert(parsedData.stat_buff_type_1 ~= nil, "effect_affect_to_stat_1 = nil")
    assert(parsedData.stat_buff_amount_1 ~= nil, "effect_amount_1 = nil")

    assert(parsedData.stat_buff_type_2 ~= nil, "effect_affect_to_stat_2 = nil")
    assert(parsedData.stat_buff_amount_2 ~= nil, "effect_amount_2 = nil")
end

--- @return void
function Hero40002_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.targetPosition = tonumber(parsedData.stat_buff_target_position)
    self.targetNumber = tonumber(parsedData.stat_buff_target_number)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)

    self.statBuffType_1 = tonumber(parsedData.stat_buff_type_1)
    self.statBuffAmount_1 = tonumber(parsedData.stat_buff_amount_1)

    self.statBuffType_2 = tonumber(parsedData.stat_buff_type_2)
    self.statBuffAmount_2 = tonumber(parsedData.stat_buff_amount_2)
end

return Hero40002_Skill4_Data