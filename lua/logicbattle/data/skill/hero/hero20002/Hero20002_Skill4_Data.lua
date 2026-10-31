--- @class Hero20002_Skill4_Data
Hero20002_Skill4_Data = Class(Hero20002_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20002_Skill4_Data:CreateInstance()
    return Hero20002_Skill4_Data()
end

---- @return void
--- @param parsedData table
function Hero20002_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

---- @return void
--- @param parsedData table
function Hero20002_Skill4_Data:ParseCsv(parsedData)
    self.healAmount = tonumber(parsedData.heal_amount)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.targetPositionHeal = tonumber(parsedData.heal_target_position)
    self.targetNumberHeal = tonumber(parsedData.heal_target_number)

    self.targetPositionEffect = tonumber(parsedData.stat_buff_target_position)
    self.targetNumberEffect = tonumber(parsedData.stat_buff_target_number)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero20002_Skill4_Data