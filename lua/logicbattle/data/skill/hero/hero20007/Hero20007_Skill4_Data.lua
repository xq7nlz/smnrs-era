--- @class Hero20007_Skill4_Data Ninetales
Hero20007_Skill4_Data = Class(Hero20007_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20007_Skill4_Data:CreateInstance()
    return Hero20007_Skill4_Data()
end

--- @return void
function Hero20007_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_amount_per_round ~= nil, "heal_amount_per_round = nil")
    assert(parsedData.heal_amount_increase_per_round ~= nil, "heal_amount_increase_per_round = nil")
end

--- @return void
function Hero20007_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.healPerRound = tonumber(parsedData.heal_amount_per_round)
    self.healIncreasePerRound = tonumber(parsedData.heal_amount_increase_per_round)
end

return Hero20007_Skill4_Data