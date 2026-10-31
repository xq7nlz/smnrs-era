--- @class Hero30013_Skill3_Data Minimanser
Hero30013_Skill3_Data = Class(Hero30013_Skill3_Data, BaseSkillData)

--- @return void
function Hero30013_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30013_Skill3_Data:CreateInstance()
    return Hero30013_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero30013_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero30013_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero30013_Skill3_Data