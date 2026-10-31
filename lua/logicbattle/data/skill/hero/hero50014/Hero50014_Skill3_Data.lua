--- @class Hero50014_Skill3_Data Hweston
Hero50014_Skill3_Data = Class(Hero50014_Skill3_Data, BaseSkillData)

--- @return void
function Hero50014_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50014_Skill3_Data:CreateInstance()
    return Hero50014_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero50014_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero50014_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero50014_Skill3_Data