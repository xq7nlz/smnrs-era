--- @class Hero60001_Skill3_Data BlackArrow
Hero60001_Skill3_Data = Class(Hero60001_Skill3_Data, BaseSkillData)

--- @return void
function Hero60001_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60001_Skill3_Data:CreateInstance()
    return Hero60001_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero60001_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero60001_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero60001_Skill3_Data