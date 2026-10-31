--- @class Hero40006_Skill4_Data Oropher
Hero40006_Skill4_Data = Class(Hero40006_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40006_Skill4_Data:CreateInstance()
    return Hero40006_Skill4_Data()
end

--- @return void
function Hero40006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_stat ~= nil, "buff_stat = nil")
    assert(parsedData.buff_bonus ~= nil, "buff_bonus = nil")

    assert(parsedData.buff_power ~= nil, "buff_power = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
end

--- @return void
function Hero40006_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.healPercent = tonumber(parsedData.heal_percent)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)

    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)

    self.buffStat = tonumber(parsedData.buff_stat)
    self.buffBonus = tonumber(parsedData.buff_bonus)

    self.buffPower = tonumber(parsedData.buff_power)
    self.buffDuration = tonumber(parsedData.buff_duration)
end

return Hero40006_Skill4_Data