--- @class Summoner1_Skill4_3_Data Mage
Summoner1_Skill4_3_Data = Class(Summoner1_Skill4_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill4_3_Data:CreateInstance()
    return Summoner1_Skill4_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.count_trigger ~= nil, "count_trigger = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_calculation ~= nil, "stat_buff_calculation = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_3_Data:ParseCsv(parsedData)
    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffCalculation = tonumber(parsedData.stat_buff_calculation)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.damage = tonumber(parsedData.damage)
    self.countTrigger = tonumber(parsedData.count_trigger)
end

return Summoner1_Skill4_3_Data