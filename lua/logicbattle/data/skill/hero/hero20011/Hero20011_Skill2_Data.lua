--- @class Hero20011_Skill2_Data Labord
Hero20011_Skill2_Data = Class(Hero20011_Skill2_Data, BaseSkillData)

--- @return void
function Hero20011_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20011_Skill2_Data:CreateInstance()
    return Hero20011_Skill2_Data()
end

function Hero20011_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.bonus_class_hero ~= nil, "bonus_class_hero = nil")
    assert(parsedData.bonus_damage_with_class ~= nil, "bonus_damage_with_class = nil")
end

--- @return void
function Hero20011_Skill2_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.bonusClassHero = tonumber(parsedData.bonus_class_hero)
    self.bonusDamageWithClass = tonumber(parsedData.bonus_damage_with_class)
end

return Hero20011_Skill2_Data