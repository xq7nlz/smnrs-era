--- @class Hero50009_Skill1_Data Aris
Hero50009_Skill1_Data = Class(Hero50009_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50009_Skill1_Data:CreateInstance()
    return Hero50009_Skill1_Data()
end

--- @return void
function Hero50009_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.bonus_damage_faction_type ~= nil, "bonus_damage_faction_type = nil")
    assert(parsedData.bonus_damage_faction_value ~= nil, "bonus_damage_faction_value = nil")
end

--- @return void
function Hero50009_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.bonusDamageFactionType = tonumber(parsedData.bonus_damage_faction_type)
    self.bonusDamageFactionAmount = tonumber(parsedData.bonus_damage_faction_value)
end

return Hero50009_Skill1_Data