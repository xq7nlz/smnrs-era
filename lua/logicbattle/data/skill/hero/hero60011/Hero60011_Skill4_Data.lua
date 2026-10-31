--- @class Hero60011_Skill4_Data Vera
Hero60011_Skill4_Data = Class(Hero60011_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60011_Skill4_Data:CreateInstance()
    return Hero60011_Skill4_Data()
end

--- @return void
function Hero60011_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
function Hero60011_Skill4_Data:ParseCsv(parsedData)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero60011_Skill4_Data