--- @class Hero10009_Skill3_Data Lashna
Hero10009_Skill3_Data = Class(Hero10009_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10009_Skill3_Data:CreateInstance()
    return Hero10009_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10009_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_amount_by_damage ~= nil, "heal_amount_with_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero10009_Skill3_Data:ParseCsv(parsedData)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healAmount = tonumber(parsedData.heal_amount_by_damage)
end

return Hero10009_Skill3_Data