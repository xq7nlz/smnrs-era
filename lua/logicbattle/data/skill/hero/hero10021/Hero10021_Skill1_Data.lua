--- @class Hero10021_Skill1_Data AquaKnight
Hero10021_Skill1_Data = Class(Hero10021_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10021_Skill1_Data:CreateInstance()
    return Hero10021_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero10021_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.bonus_class_hero ~= nil, "bonus_class_hero = nil")
    assert(parsedData.bonus_damage_with_class ~= nil, "bonus_damage_with_class = nil")
end

--- @return void
--- @param parsedData table
function Hero10021_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.bonusClassHero = tonumber(parsedData.bonus_class_hero)
    self.bonusDamageWithClass = tonumber(parsedData.bonus_damage_with_class)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
end

return Hero10021_Skill1_Data