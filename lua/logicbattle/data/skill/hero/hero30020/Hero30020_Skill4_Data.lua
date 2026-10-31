--- @class Hero30020_Skill4_Data Thanatos
Hero30020_Skill4_Data = Class(Hero30020_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30020_Skill4_Data:CreateInstance()
    return Hero30020_Skill4_Data()
end

--- @return void
function Hero30020_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_type ~= nil, "stat_type = nil")
    assert(parsedData.stat_amount ~= nil, "stat_amount = nil")
end

--- @return void
function Hero30020_Skill4_Data:ParseCsv(parsedData)
    self.statBuffAmount = tonumber(parsedData.stat_amount)
    self.statType = tonumber(parsedData.stat_type)
end

return Hero30020_Skill4_Data