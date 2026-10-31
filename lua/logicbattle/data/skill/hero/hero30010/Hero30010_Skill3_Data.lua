--- @class Hero30010_Skill3_Data Erde
Hero30010_Skill3_Data = Class(Hero30010_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30010_Skill3_Data:CreateInstance()
    return Hero30010_Skill3_Data()
end

--- @return void
function Hero30010_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.basic_attack_damage_multiplier ~= nil, "basic_attack_damage_multiplier = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Hero30010_Skill3_Data:ParseCsv(parsedData)
    self.basicAttackDamageMultiplier = tonumber(parsedData.basic_attack_damage_multiplier)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero30010_Skill3_Data