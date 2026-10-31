--- @class Summoner0_Skill1_Data Novice : BaseSkillData
Summoner0_Skill1_Data = Class(Summoner0_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner0_Skill1_Data:CreateInstance()
    return Summoner0_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Summoner0_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Summoner0_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Summoner0_Skill1_Data
