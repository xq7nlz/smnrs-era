--- @class Hero30023_Skill2_Data DrPlague
Hero30023_Skill2_Data = Class(Hero30023_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero30023_Skill2_Data:CreateInstance()
    return Hero30023_Skill2_Data()
end

--- @return void
function Hero30023_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

--- @return void
function Hero30023_Skill2_Data: ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
end

return Hero30023_Skill2_Data