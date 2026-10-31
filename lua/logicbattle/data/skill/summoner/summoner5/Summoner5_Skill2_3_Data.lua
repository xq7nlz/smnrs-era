--- @class Summoner5_Skill2_3_Data Ranger
Summoner5_Skill2_3_Data = Class(Summoner5_Skill2_3_Data, BaseSkillData)

--- @return void
function Summoner5_Skill2_3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill2_3_Data:CreateInstance()
    return Summoner5_Skill2_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner5_Skill2_3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Summoner5_Skill2_3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Summoner5_Skill2_3_Data