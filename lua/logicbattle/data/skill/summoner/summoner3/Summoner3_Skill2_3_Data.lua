--- @class Summoner3_Skill2_3_Data Priest
Summoner3_Skill2_3_Data = Class(Summoner3_Skill2_3_Data, BaseSkillData)

--- @return BaseSkillData
function Summoner3_Skill2_3_Data:CreateInstance()
    return Summoner3_Skill2_3_Data()
end

--- @return void
function Summoner3_Skill2_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
    assert(parsedData.power_stat ~= nil, "power_stat = nil")
end

--- @return void
function Summoner3_Skill2_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
    self.powerStat = tonumber(parsedData.power_stat)
end

return Summoner3_Skill2_3_Data