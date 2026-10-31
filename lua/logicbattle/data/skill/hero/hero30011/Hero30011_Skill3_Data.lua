--- @class Hero30011_Skill3_Data Skaven
Hero30011_Skill3_Data = Class(Hero30011_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30011_Skill3_Data:CreateInstance()
    return Hero30011_Skill3_Data()
end

--- @return void
function Hero30011_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_bonus_attack ~= nil, "number_bonus_attack = nil")
    assert(parsedData.bonus_attack_damage_multiplier ~= nil, "bonus_attack_damage_multiplier = nil")
end

--- @return void
function Hero30011_Skill3_Data:ParseCsv(parsedData)
    self.numberBonusAttack = tonumber(parsedData.number_bonus_attack)
    self.bonusAttackDamageMultiplier = tonumber(parsedData.bonus_attack_damage_multiplier)
end

return Hero30011_Skill3_Data