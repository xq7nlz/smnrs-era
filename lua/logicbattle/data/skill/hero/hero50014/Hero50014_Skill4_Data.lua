--- @class Hero50014_Skill4_Data Hweston
Hero50014_Skill4_Data = Class(Hero50014_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50014_Skill4_Data:CreateInstance()
    return Hero50014_Skill4_Data()
end

--- @return void
function Hero50014_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero50014_Skill4_Data:ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero50014_Skill4_Data