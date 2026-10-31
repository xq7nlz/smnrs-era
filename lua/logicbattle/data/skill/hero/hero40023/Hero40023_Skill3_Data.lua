--- @class Hero40023_Skill3_Data HoundMaster
Hero40023_Skill3_Data = Class(Hero40023_Skill3_Data, BaseSkillData)

--- @return void
function Hero40023_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40023_Skill3_Data:CreateInstance()
    return Hero40023_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero40023_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
--- @param parsedData table
function Hero40023_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero40023_Skill3_Data
