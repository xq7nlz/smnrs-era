--- @class Hero10011_Skill2_Data Jeronim
Hero10011_Skill2_Data = Class(Hero10011_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10011_Skill2_Data:CreateInstance()
    return Hero10011_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10011_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_chance ~= nil, "stat_buff_chance = nil")
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10011_Skill2_Data:ParseCsv(parsedData)
    self.statBuffChance = tonumber(parsedData.stat_buff_chance)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero10011_Skill2_Data