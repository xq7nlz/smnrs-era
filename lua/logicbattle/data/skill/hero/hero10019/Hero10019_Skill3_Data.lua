--- @class Hero10019_Skill3_Data Tidus
Hero10019_Skill3_Data = Class(Hero10019_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10019_Skill3_Data:CreateInstance()
    return Hero10019_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10019_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero10019_Skill3_Data:ParseCsv(parsedData)
    self.statDebuffChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero10019_Skill3_Data