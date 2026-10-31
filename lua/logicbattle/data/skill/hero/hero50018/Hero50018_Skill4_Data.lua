--- @class Hero50018_Skill4_Data TinkerBell
Hero50018_Skill4_Data = Class(Hero50018_Skill4_Data, BaseSkillData)

--- @return void
function Hero50018_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50018_Skill4_Data:CreateInstance()
    return Hero50018_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero50018_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero50018_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero50018_Skill4_Data
