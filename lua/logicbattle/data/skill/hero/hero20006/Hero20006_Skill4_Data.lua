--- @class Hero20006_Skill4_Data Finde
Hero20006_Skill4_Data = Class(Hero20006_Skill4_Data, BaseSkillData)

--- @return void
function Hero20006_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

--- @return BaseSkillData
function Hero20006_Skill4_Data:CreateInstance()
    return Hero20006_Skill4_Data()
end

--- @return void
function Hero20006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.resistance_dot_damage ~= nil, "resistance_dot_damage = nil")
end

--- @return void
function Hero20006_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.resistanceDotDamage = tonumber(parsedData.resistance_dot_damage)
end

return Hero20006_Skill4_Data