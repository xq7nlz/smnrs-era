--- @class Hero40005_Skill3_Data Yang
Hero40005_Skill3_Data = Class(Hero40005_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40005_Skill3_Data:CreateInstance()
    return Hero40005_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero40005_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_type ~= nil, "stat_type = nil")
    assert(parsedData.stat_amount_per_use_skill ~= nil, "stat_amount_per_use_skill = nil")
end

--- @return void
function Hero40005_Skill3_Data:ParseCsv(parsedData)
    self.statType = tonumber(parsedData.stat_type)
    self.statAmountPerUseSkill = tonumber(parsedData.stat_amount_per_use_skill)
end

return Hero40005_Skill3_Data