--- @class Hero30014_Skill1_Data Kargoth
Hero30014_Skill1_Data = Class(Hero30014_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30014_Skill1_Data:CreateInstance()
    return Hero30014_Skill1_Data()
end

--- @return void
function Hero30014_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.damage_bonus_amount ~= nil, "damage_bonus_amount = nil")
end

--- @return void
function Hero30014_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.damageBonusAmount = tonumber(parsedData.damage_bonus_amount)
end

return Hero30014_Skill1_Data