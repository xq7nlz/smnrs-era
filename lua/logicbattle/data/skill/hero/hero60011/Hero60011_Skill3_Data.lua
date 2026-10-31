--- @class Hero60011_Skill3_Data Vera
Hero60011_Skill3_Data = Class(Hero60011_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60011_Skill3_Data:CreateInstance()
    return Hero60011_Skill3_Data()
end

--- @return void
function Hero60011_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")

    assert(parsedData.damage_target_position ~= nil, "effect_amount = nil")
    assert(parsedData.damage_target_number ~= nil, "effect_amount = nil")
end

--- @return void
function Hero60011_Skill3_Data:ParseCsv(parsedData)
    self.bonusDamage = tonumber(parsedData.bonus_damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero60011_Skill3_Data