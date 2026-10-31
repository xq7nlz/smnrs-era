--- @class Hero40004_Skill3_Data Cennunos
Hero40004_Skill3_Data = Class(Hero40004_Skill3_Data, BaseSkillData)

--- @return void
function Hero40004_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

--- @return BaseSkillData
function Hero40004_Skill3_Data:CreateInstance()
    return Hero40004_Skill3_Data()
end

--- @return void
function Hero40004_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.damage_attack ~= nil, "effect_type = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
function Hero40004_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)
    self.damageAttack = tonumber(parsedData.damage_attack)

    self.targetPosition = tonumber(parsedData.damage_target_position)
    self.targetNumber = tonumber(parsedData.damage_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)

end

return Hero40004_Skill3_Data