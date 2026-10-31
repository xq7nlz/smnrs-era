--- @class Hero30012_Skill1_Data Dzuteh
Hero30012_Skill1_Data = Class(Hero30012_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30012_Skill1_Data:CreateInstance()
    return Hero30012_Skill1_Data()
end

--- @return void
function Hero30012_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

--- @return void
function Hero30012_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.statBuffType =  tonumber(parsedData.stat_buff_type)
    self.statBuffAmount =  tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration =  tonumber(parsedData.stat_buff_duration)
end

return Hero30012_Skill1_Data