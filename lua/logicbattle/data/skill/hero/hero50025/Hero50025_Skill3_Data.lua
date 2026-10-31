--- @class Hero50025_Skill3_Data Avorn
Hero50025_Skill3_Data = Class(Hero50025_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50025_Skill3_Data:CreateInstance()
    return Hero50025_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero50025_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_attack_chance ~= nil, "bonus_attack_chance = nil")
    assert(parsedData.bonus_attack_damage_multiplier ~= nil, "bonus_attack_damage_multiplier = nil")
end

--- @return void
--- @param parsedData table
function Hero50025_Skill3_Data:ParseCsv(parsedData)
    self.bonusAttackChance = tonumber(parsedData.bonus_attack_chance)
    self.bonusAttackDamageMultiplier = tonumber(parsedData.bonus_attack_damage_multiplier)
end

return Hero50025_Skill3_Data
