--- @class Hero30003_Skill1_Data Nero
Hero30003_Skill1_Data = Class(Hero30003_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30003_Skill1_Data:CreateInstance()
    return Hero30003_Skill1_Data()
end

--- @return void
function Hero30003_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero30003_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.healPercent = tonumber(parsedData.heal_percent)
end

return Hero30003_Skill1_Data