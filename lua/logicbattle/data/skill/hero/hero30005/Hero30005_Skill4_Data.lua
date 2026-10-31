--- @class Hero30005_Skill4_Data Jormungand
Hero30005_Skill4_Data = Class(Hero30005_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30005_Skill4_Data:CreateInstance()
    return Hero30005_Skill4_Data()
end

--- @return void
function Hero30005_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.venom_stack_damage ~= nil, "venom_stack_damage = nil")
    assert(parsedData.venom_stack_duration ~= nil, "venom_stack_duration = nil")
    assert(parsedData.number_stack ~= nil, "number_stack = nil")

    assert(parsedData.damage_per_stack_when_dead ~= nil, "damage_per_stack_when_dead = nil")
end

--- @return void
function Hero30005_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.venomStackDamage = tonumber(parsedData.venom_stack_damage)
    self.venomStackDuration = tonumber(parsedData.venom_stack_duration)
    self.numberStack = tonumber(parsedData.number_stack)

    self.damagePerVenomStack = tonumber(parsedData.damage_per_stack_when_dead)
end

return Hero30005_Skill4_Data