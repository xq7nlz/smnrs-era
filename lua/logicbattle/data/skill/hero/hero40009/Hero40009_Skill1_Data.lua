--- @class Hero40009_Skill1_Data Sylph
Hero40009_Skill1_Data = Class(Hero40009_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40009_Skill1_Data:CreateInstance()
    return Hero40009_Skill1_Data()
end

--- @return void
function Hero40009_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.number_round_can_not_be_targeted ~= nil, "number_round_can_not_be_targeted = nil")
end

--- @return void
function Hero40009_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.target_position)
    self.damageTargetNumber = tonumber(parsedData.target_number)

    self.numberRoundCanNotBeTargeted = tonumber(parsedData.number_round_can_not_be_targeted)
end

return Hero40009_Skill1_Data