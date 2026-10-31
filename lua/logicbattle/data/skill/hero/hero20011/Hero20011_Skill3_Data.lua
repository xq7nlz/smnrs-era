--- @class Hero20011_Skill3_Data Labord
Hero20011_Skill3_Data = Class(Hero20011_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20011_Skill3_Data:CreateInstance()
    return Hero20011_Skill3_Data()
end

--- @return void
function Hero20011_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

--- @return void
function Hero20011_Skill3_Data:ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
end

return Hero20011_Skill3_Data