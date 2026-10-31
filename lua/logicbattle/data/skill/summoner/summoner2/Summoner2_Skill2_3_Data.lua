--- @class Summoner2_Skill2_3_Data Warrior
Summoner2_Skill2_3_Data = Class(Summoner2_Skill2_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill2_3_Data:CreateInstance()
    return Summoner2_Skill2_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_chance ~= nil, "buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_calculation ~= nil, "stat_buff_calculation = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)

    self.buffChance = tonumber(parsedData.buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffCalculation = tonumber(parsedData.stat_buff_calculation)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Summoner2_Skill2_3_Data