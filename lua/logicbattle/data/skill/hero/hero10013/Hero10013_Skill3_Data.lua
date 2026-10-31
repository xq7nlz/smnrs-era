--- @class Hero10013_Skill3_Data Oceanee
Hero10013_Skill3_Data = Class(Hero10013_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10013_Skill3_Data:CreateInstance()
    return Hero10013_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10013_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
end

--- @return void
--- @param parsedData table
function Hero10013_Skill3_Data:ParseCsv(parsedData)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero10013_Skill3_Data