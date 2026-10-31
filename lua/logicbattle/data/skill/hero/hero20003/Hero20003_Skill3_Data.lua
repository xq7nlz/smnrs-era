--- @class Hero20003_Skill3_Data Eitri
Hero20003_Skill3_Data = Class(Hero20003_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return void
function Hero20003_Skill3_Data:CreateInstance()
    return Hero20003_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero20003_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.steal_stat_type ~= nil, "steal_stat_type = nil")
    assert(parsedData.steal_stat_amount ~= nil, "steal_stat_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero20003_Skill3_Data:ParseCsv(parsedData)
    self.stealStatType = tonumber(parsedData.steal_stat_type)
    self.stealStatAmount = tonumber(parsedData.steal_stat_amount)
end

return Hero20003_Skill3_Data