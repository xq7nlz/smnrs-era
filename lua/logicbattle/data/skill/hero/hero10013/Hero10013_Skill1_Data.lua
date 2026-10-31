--- @class Hero10013_Skill1_Data Oceanee
Hero10013_Skill1_Data = Class(Hero10013_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10013_Skill1_Data:CreateInstance()
    return Hero10013_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10013_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_amount ~= nil, "heal_percent_of_damage = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero10013_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetNumber = tonumber(parsedData.damage_target_number)
    self.damageTargetPosition = tonumber(parsedData.damage_target_position)

    self.healAmount = tonumber(parsedData.heal_amount)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)

end

return Hero10013_Skill1_Data