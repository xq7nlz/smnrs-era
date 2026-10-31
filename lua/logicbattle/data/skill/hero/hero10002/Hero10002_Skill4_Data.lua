--- @class Hero10002_Skill4_Data Sharpwater
Hero10002_Skill4_Data = Class(Hero10002_Skill4_Data, BaseSkillData)

--- @return void
function Hero10002_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10002_Skill4_Data:CreateInstance()
    return Hero10002_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10002_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
--- @param parsedData table
function Hero10002_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero10002_Skill4_Data