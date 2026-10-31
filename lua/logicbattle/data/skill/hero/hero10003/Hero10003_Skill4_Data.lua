--- @class Hero10003_Skill4_Data Gracious_Fairy
Hero10003_Skill4_Data = Class(Hero10003_Skill4_Data, BaseSkillData)

--- @return void
function Hero10003_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10003_Skill4_Data:CreateInstance()
    return Hero10003_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero10003_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero10003_Skill4_Data