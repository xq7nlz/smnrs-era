--- @class Summoner2_Skill1_2_Data Warrior
Summoner2_Skill1_2_Data = Class(Summoner2_Skill1_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill1_2_Data:CreateInstance()
    return Summoner2_Skill1_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill1_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
    assert(parsedData.stat_buff_calculation ~= nil, "stat_buff_calculation = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill1_2_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)

    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
    self.statBuffCalculation = tonumber(parsedData.stat_buff_calculation)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Summoner2_Skill1_2_Data