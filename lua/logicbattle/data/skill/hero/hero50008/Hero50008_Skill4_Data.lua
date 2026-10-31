--- @class Hero50008_Skill4_Data Fanar
Hero50008_Skill4_Data = Class(Hero50008_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50008_Skill4_Data:CreateInstance()
    return Hero50008_Skill4_Data()
end

--- @return void
function Hero50008_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero50008_Skill4_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.targetPositionBuff = tonumber(parsedData.buff_target_position)
    self.targetNumberBuff = tonumber(parsedData.buff_target_number)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero50008_Skill4_Data