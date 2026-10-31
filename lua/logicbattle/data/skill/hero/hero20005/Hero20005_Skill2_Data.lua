--- @class Hero20005_Skill2_Data Yin
Hero20005_Skill2_Data = Class(Hero20005_Skill2_Data, BaseSkillData)

--- @return void
function Hero20005_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

--- @return BaseSkillData
function Hero20005_Skill2_Data:CreateInstance()
    return Hero20005_Skill2_Data()
end

--- @return void
function Hero20005_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_dot_amount ~= nil, "bonus_dot_amount = nil")
end

--- @return void
function Hero20005_Skill2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
    self.bonusDotAmount = tonumber(parsedData.bonus_dot_amount)
end

return Hero20005_Skill2_Data