--- @class Hero30025_Skill1_Data Grig
Hero30025_Skill1_Data = Class(Hero30025_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30025_Skill1_Data:CreateInstance()
    return Hero30025_Skill1_Data()
end

--- @return void
function Hero30025_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_buff_target_position ~= nil, "stat_buff_target_position = nil")
    assert(parsedData.stat_buff_target_number ~= nil, "stat_buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero30025_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.damage_target_position)
    self.enemyTargetNumber = tonumber(parsedData.damage_target_number)

    self.allyTargetPosition = tonumber(parsedData.stat_buff_target_position)
    self.allyTargetNumber = tonumber(parsedData.stat_buff_target_number)

    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero30025_Skill1_Data