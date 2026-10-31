--- @class Hero60013_Skill4_Data DarkKnight
Hero60013_Skill4_Data = Class(Hero60013_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60013_Skill4_Data:CreateInstance()
    return Hero60013_Skill4_Data()
end

--- @return void
function Hero60013_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
end

--- @return void
function Hero60013_Skill4_Data:ParseCsv(parsedData)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
end

return Hero60013_Skill4_Data