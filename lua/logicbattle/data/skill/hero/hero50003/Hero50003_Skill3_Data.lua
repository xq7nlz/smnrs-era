--- @class Hero50003_Skill3_Data LifeKeeper
Hero50003_Skill3_Data = Class(Hero50003_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50003_Skill3_Data:CreateInstance()
    return Hero50003_Skill3_Data()
end

--- @return void
function Hero50003_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.steal_stat_type ~= nil, "steal_stat_type = nil")
    assert(parsedData.steal_stat_amount ~= nil, "steal_stat_amount = nil")
end

--- @return void
function Hero50003_Skill3_Data:ParseCsv(parsedData)
    self.stealStatType = tonumber(parsedData.steal_stat_type)
    self.stealStatAmount = tonumber(parsedData.steal_stat_amount)
end

return Hero50003_Skill3_Data