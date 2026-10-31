--- @class Hero20014_Skill3_Data Khezzec
Hero20014_Skill3_Data = Class(Hero20014_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20014_Skill3_Data:CreateInstance()
    return Hero20014_Skill3_Data()
end

--- @return void
function Hero20014_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_attack ~= nil, "damage_attack = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")
end

--- @return void
function Hero20014_Skill3_Data:ParseCsv(parsedData)
    self.damageAttack = tonumber(parsedData.damage_attack)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero20014_Skill3_Data