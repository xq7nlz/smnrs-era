--- @class Hero30026_Skill1_Data Vlad
Hero30026_Skill1_Data = Class(Hero30026_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30026_Skill1_Data:CreateInstance()
    return Hero30026_Skill1_Data()
end

--- @return void
function Hero30026_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "enemy_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero30026_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.enemyTargetPosition = tonumber(parsedData.damage_target_position)
    self.enemyTargetNumber = tonumber(parsedData.damage_target_number)

    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero30026_Skill1_Data