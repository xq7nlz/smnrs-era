--- @class Summoner4_Skill3_3_Data Assassin
Summoner4_Skill3_3_Data = Class(Summoner4_Skill3_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill3_3_Data:CreateInstance()
    return Summoner4_Skill3_3_Data()
end

--- @return void
function Summoner4_Skill3_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Summoner4_Skill3_3_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Summoner4_Skill3_3_Data