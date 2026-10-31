--- @class Hero30001_Skill4_Data Charon
Hero30001_Skill4_Data = Class(Hero30001_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30001_Skill4_Data:CreateInstance()
    return Hero30001_Skill4_Data()
end

--- @return void
function Hero30001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_type ~= nil, "stat_type = nil")
    assert(parsedData.stat_bonus_amount ~= nil, "stat_bonus_amount = nil")
    assert(parsedData.stat_bonus_limit ~= nil, "stat_bonus_limit = nil")
end

--- @return void
function Hero30001_Skill4_Data:ParseCsv(parsedData)
    self.statType = tonumber(parsedData.stat_type)
    self.bonusAmount = tonumber(parsedData.stat_bonus_amount)
    self.bonusLimit = tonumber(parsedData.stat_bonus_limit)
end

return Hero30001_Skill4_Data