--- @class Hero30001_Skill3_Data Charon
Hero30001_Skill3_Data = Class(Hero30001_Skill3_Data, BaseSkillData)

--- @return void
function Hero30001_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30001_Skill3_Data:CreateInstance()
    return Hero30001_Skill3_Data()
end

--- @return void
function Hero30001_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
end

--- @return void
function Hero30001_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)
end

return Hero30001_Skill3_Data