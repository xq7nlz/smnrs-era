--- @class Hero40007_Skill1_Data Noroth
Hero40007_Skill1_Data = Class(Hero40007_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40007_Skill1_Data:CreateInstance()
    return Hero40007_Skill1_Data()
end

--- @return void
function Hero40007_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "ally_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "ally_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "effect_2_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "effect_2_duration = nil")
    assert(parsedData.stat_calculation_type ~= nil, "effect_2_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "effect_2_amount = nil")
end

--- @return void
function Hero40007_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.damage_target_position)
    self.enemyTargetNumber = tonumber(parsedData.damage_target_number)

    self.allyTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.allyTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statCalculationType = tonumber(parsedData.stat_calculation_type)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero40007_Skill1_Data