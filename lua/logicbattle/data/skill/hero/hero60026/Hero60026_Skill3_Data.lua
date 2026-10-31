--- @class Hero60026_Skill3_Data Ghunon
Hero60026_Skill3_Data = Class(Hero60026_Skill3_Data, BaseSkillData)

--- @return void
function Hero60026_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60026_Skill3_Data:CreateInstance()
    return Hero60026_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero60026_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero60026_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero60026_Skill3_Data
