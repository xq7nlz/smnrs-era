--- @class Summoner4_Skill4_1_Data Assassin
Summoner4_Skill4_1_Data = Class(Summoner4_Skill4_1_Data, BaseSkillData)

--- @return void
function Summoner4_Skill4_1_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill4_1_Data:CreateInstance()
    return Summoner4_Skill4_1_Data()
end
--- @return void
function Summoner4_Skill4_1_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
    assert(parsedData.max_stack ~= nil, "max_stack = nil")
end

--- @return void
function Summoner4_Skill4_1_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.duration = tonumber(parsedData.buff_duration)
    self.maxStack = tonumber(parsedData.max_stack)
end

return Summoner4_Skill4_1_Data