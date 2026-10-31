--- @class Hero40027_Skill2_Data : BaseSkillData Airyuu
Hero40027_Skill2_Data = Class(Hero40027_Skill2_Data, BaseSkillData)

--- @return void
function Hero40027_Skill2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

--- @return BaseSkillData
function Hero40027_Skill2_Data:CreateInstance()
    return Hero40027_Skill2_Data()
end

--- @return void
function Hero40027_Skill2_Data:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.human_stat_debuff_type ~= nil, "human_stat_debuff_type = nil")
    assert(parsedData.human_stat_debuff_calculation_type ~= nil, "human_stat_debuff_calculation_type = nil")
    assert(parsedData.human_stat_debuff_amount ~= nil, "human_stat_debuff_amount = nil")
    assert(parsedData.human_stat_debuff_duration ~= nil, "human_stat_debuff_duration = nil")
    assert(parsedData.human_stat_debuff_max ~= nil, "human_stat_debuff_max = nil")

    assert(parsedData.dragon_heal_percent ~= nil, "dragon_heal_percent = nil")

    assert(parsedData.dragon_target_position ~= nil, "dragon_target_position = nil")
    assert(parsedData.dragon_target_number ~= nil, "dragon_target_number = nil")

    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)
end

--- @return void
function Hero40027_Skill2_Data:ParseCsv(parsedData)

    self.statDebuffType = tonumber(parsedData.human_stat_debuff_type)
    self.statDebuffCalculationType = tonumber(parsedData.human_stat_debuff_calculation_type)
    self.statDebuffAmount = tonumber(parsedData.human_stat_debuff_amount)
    self.statDebuffDuration = tonumber(parsedData.human_stat_debuff_duration)
    self.statDebuffMax = tonumber(parsedData.human_stat_debuff_max)

    self.healAmount = tonumber(parsedData.dragon_heal_percent)

    self.targetPosition = tonumber(parsedData.dragon_target_position)
    self.targetNumber = tonumber(parsedData.dragon_target_number)

    self.statChangerDataHelper:ParseCsv(parsedData)
end

return Hero40027_Skill2_Data