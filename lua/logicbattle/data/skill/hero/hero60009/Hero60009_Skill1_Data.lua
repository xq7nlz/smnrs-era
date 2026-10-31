--- @class Hero60009_Skill1_Data Khann
Hero60009_Skill1_Data = Class(Hero60009_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60009_Skill1_Data:CreateInstance()
    return Hero60009_Skill1_Data()
end

--- @return void
function Hero60009_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.damage_bonus_amount ~= nil, "damage_bonus_amount = nil")
end

--- @return void
function Hero60009_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.damageBonusAmount = tonumber(parsedData.damage_bonus_amount)
end

return Hero60009_Skill1_Data