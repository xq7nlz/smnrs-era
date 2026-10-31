--- @class Summoner1_Skill2_2_Data Mage
Summoner1_Skill2_2_Data = Class(Summoner1_Skill2_2_Data, BaseSkillData)

--- @return void
function Summoner1_Skill2_2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill2_2_Data:CreateInstance()
    return Summoner1_Skill2_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill2_2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.target_class ~= nil, "target_class = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill2_2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.targetClass = tonumber(parsedData.target_class)
end

return Summoner1_Skill2_2_Data