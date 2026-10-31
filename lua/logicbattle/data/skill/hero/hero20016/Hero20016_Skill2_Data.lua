--- @class Hero20016_Skill2_Data Ifrit
Hero20016_Skill2_Data = Class(Hero20016_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return void
function Hero20016_Skill2_Data:CreateInstance()
    return Hero20016_Skill2_Data()
end

--- @return void
function Hero20016_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero20016_Skill2_Data:ParseCsv(parsedData)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero20016_Skill2_Data