--- @class Hero30006_Skill1_Data Thanatos
Hero30006_Skill1_Data = Class(Hero30006_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30006_Skill1_Data:CreateInstance()
    return Hero30006_Skill1_Data()
end

--- @return void
function Hero30006_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.enemy_hp_limit ~= nil, "enemy_hp_limit = nil")
    assert(parsedData.skill_damage_bonus ~= nil, "skill_damage_bonus = nil")
end

--- @return void
function Hero30006_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.enemyHpLimit = tonumber(parsedData.enemy_hp_limit)
    self.skillDamageBonus = tonumber(parsedData.skill_damage_bonus)
end

return Hero30006_Skill1_Data