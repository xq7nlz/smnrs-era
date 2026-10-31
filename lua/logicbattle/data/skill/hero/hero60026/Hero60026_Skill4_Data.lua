--- @class Hero60026_Skill4_Data Ghunon
Hero60026_Skill4_Data = Class(Hero60026_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60026_Skill4_Data:CreateInstance()
    return Hero60026_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero60026_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.poison_damage_reduction ~= nil, "poison_damage_reduction = nil")
end

--- @return void
--- @param parsedData table
function Hero60026_Skill4_Data:ParseCsv(parsedData)
    self.poisonDamageReduction = tonumber(parsedData.poison_damage_reduction)
end

return Hero60026_Skill4_Data
