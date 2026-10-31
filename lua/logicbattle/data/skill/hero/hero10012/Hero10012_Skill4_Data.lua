--- @class Hero10012_Skill4_Data Assassiren
Hero10012_Skill4_Data = Class(Hero10012_Skill4_Data, BaseSkillData)

--- @return void
function Hero10012_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10012_Skill4_Data:CreateInstance()
    return Hero10012_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero10012_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.drowning_mark_can_be_dispelled ~= nil, "drowning_mark_can_be_dispelled = nil")
end

--- @return void
--- @param parsedData table
function Hero10012_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
    self.drowningMarkCanBeDispelled = MathUtils.ToBoolean(parsedData.drowning_mark_can_be_dispelled)
end

return Hero10012_Skill4_Data
