--- @class Hero50002_Skill4_Data HolyKnight
Hero50002_Skill4_Data = Class(Hero50002_Skill4_Data, BaseSkillData)

--- @return void
function Hero50002_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type List<StatBonus>
    self.bonuses = List()

    --- @type Dictionary<BaseHero, boolean>
    self.isTriggerHeroes = Dictionary()

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50002_Skill4_Data:CreateInstance()
    return Hero50002_Skill4_Data()
end

--- @return void
function Hero50002_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.duration ~= nil, "duration = nil")
end

--- @return void
function Hero50002_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.duration = tonumber(parsedData.duration)
end

return Hero50002_Skill4_Data