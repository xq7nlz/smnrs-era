--- @class Hero10011_Skill1_Data Jeronim
Hero10011_Skill1_Data = Class(Hero10011_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10011_Skill1_Data:CreateInstance()
    return Hero10011_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10011_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.multi_damage_chance ~= nil, "multi_damage_chance = nil")
    assert(parsedData.multi_damage_value ~= nil, "multi_damage_value = nil")
end

--- @return void
--- @param parsedData table
function Hero10011_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.multiDamageChance = tonumber(parsedData.multi_damage_chance)
    self.multiDamageValue = tonumber(parsedData.multi_damage_value)
end

return Hero10011_Skill1_Data