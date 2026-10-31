--- @class Summoner2_Skill3_2_Data Warrior
Summoner2_Skill3_2_Data = Class(Summoner2_Skill3_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill3_2_Data:CreateInstance()
    return Summoner2_Skill3_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.buff_chance ~= nil, "buff_chance = nil")
    assert(parsedData.block_chance ~= nil, "block_chance = nil")
    assert(parsedData.block_duration ~= nil, "block_duration = nil")
    assert(parsedData.block_amount ~= nil, "block_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_2_Data:ParseCsv(parsedData)
    self.buffTargetPosition = tonumber(parsedData.target_position)
    self.buffTargetNumber = tonumber(parsedData.target_number)

    self.buffChance = tonumber(parsedData.buff_chance)
    self.blockChance = tonumber(parsedData.block_chance)
    self.blockDuration = tonumber(parsedData.block_duration)
    self.blockAmount = tonumber(parsedData.block_amount)
end

return Summoner2_Skill3_2_Data