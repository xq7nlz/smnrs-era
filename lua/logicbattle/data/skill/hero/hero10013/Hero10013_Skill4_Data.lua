--- @class Hero10013_Skill4_Data Oceanee
Hero10013_Skill4_Data = Class(Hero10013_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10013_Skill4_Data:CreateInstance()
    return Hero10013_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10013_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_amount_by_damage ~= nil, "heal_amount_by_damage = nil")
end

--- @return void
--- @param parsedData table
function Hero10013_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.healAmountByDamage = tonumber(parsedData.heal_amount_by_damage)

    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healTargetPosition = tonumber(parsedData.heal_target_position)
end

return Hero10013_Skill4_Data