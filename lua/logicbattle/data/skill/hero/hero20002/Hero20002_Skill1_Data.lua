--- @class Hero20002_Skill1_Data Arien
Hero20002_Skill1_Data = Class(Hero20002_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return void
function Hero20002_Skill1_Data:CreateInstance()
    return Hero20002_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero20002_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")

    assert(parsedData.power_buff_target_position ~= nil, "power_buff_target_position = nil")
    assert(parsedData.power_buff_target_number ~= nil, "power_buff_target_number = nil")
    assert(parsedData.power_buff_chance ~= nil, "power_buff_chance = nil")
    assert(parsedData.power_buff_amount ~= nil, "power_buff_amount = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")

    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")
    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")

end

--- @return void
--- @param parsedData table
function Hero20002_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statDebuffEnemyChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffEnemyType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffEnemyDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffEnemyAmount = tonumber(parsedData.stat_debuff_amount)

    self.powerBuffChance = tonumber(parsedData.power_buff_chance)
    self.powerBuffAmount = tonumber(parsedData.power_buff_amount)
    self.powerBuffTargetNumber = tonumber(parsedData.power_buff_target_number)
    self.powerBuffTargetPosition = tonumber(parsedData.power_buff_target_position)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)

    self.statBuffTargetNumber = tonumber(parsedData.stat_buff_target_number)
    self.statBuffTargetPosition = tonumber(parsedData.stat_buff_target_position)
end

return Hero20002_Skill1_Data