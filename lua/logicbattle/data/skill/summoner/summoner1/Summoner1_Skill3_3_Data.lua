--- @class Summoner1_Skill3_3_Data Mage
Summoner1_Skill3_3_Data = Class(Summoner1_Skill3_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill3_3_Data:CreateInstance()
    return Summoner1_Skill3_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_chance ~= nil, "buff_chance = nil")
    assert(parsedData.stat_buff_1_type ~= nil, "stat_buff_1_type = nil")
    assert(parsedData.stat_buff_1_calculation ~= nil, "stat_buff_1_calculation = nil")
    assert(parsedData.stat_buff_1_amount ~= nil, "stat_buff_1_amount = nil")

    assert(parsedData.stat_buff_2_type ~= nil, "stat_buff_2_type = nil")
    assert(parsedData.stat_buff_2_calculation ~= nil, "stat_buff_2_calculation = nil")
    assert(parsedData.stat_buff_2_amount ~= nil, "stat_buff_2_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)

    self.buffChance = tonumber(parsedData.buff_chance)
    self.statBuffType_1 = tonumber(parsedData.stat_buff_1_type)
    self.statBuffCalculation_1 = tonumber(parsedData.stat_buff_1_calculation)
    self.statBuffAmount_1 = tonumber(parsedData.stat_buff_1_amount)

    self.statBuffType_2 = tonumber(parsedData.stat_buff_2_type)
    self.statBuffCalculation_2 = tonumber(parsedData.stat_buff_2_calculation)
    self.statBuffAmount_2 = tonumber(parsedData.stat_buff_2_amount)
end

return Summoner1_Skill3_3_Data