--- @class Summoner2_Skill2_1_Data Warrior
Summoner2_Skill2_1_Data = Class(Summoner2_Skill2_1_Data, BaseSkillData)

--- @return void
function Summoner2_Skill2_1_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill2_1_Data:CreateInstance()
    return Summoner2_Skill2_1_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_1_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill2_1_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Summoner2_Skill2_1_Data