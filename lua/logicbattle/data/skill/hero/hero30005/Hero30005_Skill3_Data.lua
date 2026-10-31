--- @class Hero30005_Skill3_Data Jormungand
Hero30005_Skill3_Data = Class(Hero30005_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30005_Skill3_Data:CreateInstance()
    return Hero30005_Skill3_Data()
end

--- @return void
function Hero30005_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.basic_attack_target_position ~= nil, "basic_attack_target_position = nil")
    assert(parsedData.basic_attack_target_number ~= nil, "basic_attack_target_number = nil")

    assert(parsedData.venom_stack_damage ~= nil, "venom_stack_damage = nil")
    assert(parsedData.venom_stack_duration ~= nil, "venom_stack_duration = nil")
    assert(parsedData.number_stack ~= nil, "number_stack = nil")
end

--- @return void
function Hero30005_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.basic_attack_target_position)
    self.targetNumber = tonumber(parsedData.basic_attack_target_number)

    self.venomStackDamage = tonumber(parsedData.venom_stack_damage)
    self.venomStackDuration = tonumber(parsedData.venom_stack_duration)
    self.numberStack = tonumber(parsedData.number_stack)
end

return Hero30005_Skill3_Data