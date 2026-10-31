--- @class Summoner1_Skill4_1_Data Mage
Summoner1_Skill4_1_Data = Class(Summoner1_Skill4_1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill4_1_Data:CreateInstance()
    return Summoner1_Skill4_1_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.block_chance ~= nil, "block_chance = nil")
    assert(parsedData.block_rate ~= nil, "block_rate = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_1_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.blockChance = tonumber(parsedData.block_chance)
    self.blockRate = tonumber(parsedData.block_rate)
end

return Summoner1_Skill4_1_Data