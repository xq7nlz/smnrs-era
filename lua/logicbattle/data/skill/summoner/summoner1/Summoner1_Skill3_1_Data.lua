--- @class Summoner1_Skill3_1_Data Mage
Summoner1_Skill3_1_Data = Class(Summoner1_Skill3_1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill3_1_Data:CreateInstance()
    return Summoner1_Skill3_1_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.blessing_chance ~= nil, "blessing_chance = nil")
    assert(parsedData.blessing_duration ~= nil, "blessing_duration = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_1_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.blessingDuration = tonumber(parsedData.blessing_duration)
    self.blessingChance = tonumber(parsedData.blessing_chance)
end

return Summoner1_Skill3_1_Data