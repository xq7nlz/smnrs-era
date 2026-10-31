--- @class Hero20009_Skill2_Data Fragnil
Hero20009_Skill2_Data = Class(Hero20009_Skill2_Data, BaseSkillData)

--- @return void
function Hero20009_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20009_Skill2_Data:CreateInstance()
    return Hero20009_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero20009_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero20009_Skill2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero20009_Skill2_Data