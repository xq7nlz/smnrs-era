--- @class Hero60016_Skill1_Data DarkMage
Hero60016_Skill1_Data = Class(Hero60016_Skill1_Data, BaseSkillData)

--- @return void
function Hero60016_Skill1_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkill
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Hero60016_Skill1_Data:CreateInstance(id, hero)
    return Hero60016_Skill1_Data(id, hero)
end

--- @return void
--- @param parsedData table
function Hero60016_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero60016_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statChangerDataHelper:ParseCsv(parsedData)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero60016_Skill1_Data