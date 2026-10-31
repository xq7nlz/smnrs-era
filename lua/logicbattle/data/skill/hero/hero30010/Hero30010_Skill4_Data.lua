--- @class Hero30010_Skill4_Data Erde
Hero30010_Skill4_Data = Class(Hero30010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30010_Skill4_Data:CreateInstance()
    return Hero30010_Skill4_Data()
end

--- @return void
function Hero30010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.block_chance ~= nil, "block_chance = nil")
    assert(parsedData.block_rate ~= nil, "block_rate = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero30010_Skill4_Data:ParseCsv(parsedData)
    self.blockChance = tonumber(parsedData.block_chance)
    self.blockRate = tonumber(parsedData.block_rate)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero30010_Skill4_Data