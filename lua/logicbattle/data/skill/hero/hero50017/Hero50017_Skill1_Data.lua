--- @class Hero50017_Skill1_Data LightWarrior
Hero50017_Skill1_Data = Class(Hero50017_Skill1_Data, BaseSkillData)

--- @return void
function Hero50017_Skill1_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50017_Skill1_Data:CreateInstance()
    return Hero50017_Skill1_Data()
end

--- @return void
function Hero50017_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")
    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero50017_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)

    self.statChangerDataHelper:ParseCsv(parsedData)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero50017_Skill1_Data