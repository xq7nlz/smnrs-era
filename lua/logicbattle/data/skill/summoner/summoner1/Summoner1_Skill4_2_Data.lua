--- @class Summoner1_Skill4_2_Data Mage
Summoner1_Skill4_2_Data = Class(Summoner1_Skill4_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill4_2_Data:CreateInstance()
    return Summoner1_Skill4_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.power_buff ~= nil, "power_buff = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill4_2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.powerBuff = tonumber(parsedData.power_buff)
end

return Summoner1_Skill4_2_Data