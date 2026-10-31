--- @class Hero40002_Skill1_Data Yggra
Hero40002_Skill1_Data = Class(Hero40002_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40002_Skill1_Data:CreateInstance()
    return Hero40002_Skill1_Data()
end

--- @return void
function Hero40002_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.enemy_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.enemy_target_number ~= nil, "enemy_target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "effect_1_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "effect_1_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "effect_1_amount = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "effect_2_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "effect_2_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "effect_2_amount = nil")
end

--- @return void
function Hero40002_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.enemy_target_position)
    self.enemyTargetNumber = tonumber(parsedData.enemy_target_number)

    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)

    self.allyTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.allyTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero40002_Skill1_Data