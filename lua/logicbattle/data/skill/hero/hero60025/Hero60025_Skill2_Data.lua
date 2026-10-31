--- @class Hero60025_Skill2_Data Vampire
Hero60025_Skill2_Data = Class(Hero60025_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60025_Skill2_Data:CreateInstance()
    return Hero60025_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero60025_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_bonus ~= nil, "heal_bonus = nil")
end

--- @return void
--- @param parsedData table
function Hero60025_Skill2_Data:ParseCsv(parsedData)
    self.healBonus = tonumber(parsedData.heal_bonus)
end

return Hero60025_Skill2_Data
