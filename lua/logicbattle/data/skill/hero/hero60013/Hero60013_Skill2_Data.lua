--- @class Hero60013_Skill2_Data DarkKnight
Hero60013_Skill2_Data = Class(Hero60013_Skill2_Data, BaseSkillData)

--- @return void
function Hero60013_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60013_Skill2_Data:CreateInstance()
    return Hero60013_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero60013_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero60013_Skill2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero60013_Skill2_Data