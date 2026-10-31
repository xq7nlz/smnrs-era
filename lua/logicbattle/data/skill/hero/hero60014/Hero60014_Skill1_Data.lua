--- @class Hero60014_Skill1_Data ShiShil
Hero60014_Skill1_Data = Class(Hero60014_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60014_Skill1_Data:CreateInstance()
    return Hero60014_Skill1_Data()
end

--- @return void
function Hero60014_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")
end

--- @return void
function Hero60014_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.bondDuration = tonumber(parsedData.bond_duration)
end

return Hero60014_Skill1_Data