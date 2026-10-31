--- @class Hero50012_Skill4_Data Alvar
Hero50012_Skill4_Data = Class(Hero50012_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50012_Skill4_Data:CreateInstance()
    return Hero50012_Skill4_Data()
end

--- @return void
function Hero50012_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
    assert(parsedData.heal_chance ~= nil, "heal_chance = nil")
    assert(parsedData.heal_percent_of_damage ~= nil, "heal_percent_of_damage = nil")
end

--- @return void
function Hero50012_Skill4_Data:ParseCsv(parsedData)
    self.bonusDamage = tonumber(parsedData.bonus_damage)
    self.healChance = tonumber(parsedData.heal_chance)
    self.healPercentOfDamage = tonumber(parsedData.heal_percent_of_damage)
end

return Hero50012_Skill4_Data