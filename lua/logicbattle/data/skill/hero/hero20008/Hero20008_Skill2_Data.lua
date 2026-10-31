--- @class Hero20008_Skill2_Data Moblin
Hero20008_Skill2_Data = Class(Hero20008_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20008_Skill2_Data:CreateInstance()
    return Hero20008_Skill2_Data()
end

--- @return void
function Hero20008_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_value_max ~= nil, "stat_buff_value_max = nil")
end

--- @return void
function Hero20008_Skill2_Data:ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffValueMax = tonumber(parsedData.stat_buff_value_max)
end

return Hero20008_Skill2_Data