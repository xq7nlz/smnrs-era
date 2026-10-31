--- @class Hero30023_Skill4_Data DrPlague
Hero30023_Skill4_Data = Class(Hero30023_Skill4_Data, BaseSkillData)

--- @return void
function Hero30023_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30023_Skill4_Data:CreateInstance()
    return Hero30023_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero30023_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero30023_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero30023_Skill4_Data