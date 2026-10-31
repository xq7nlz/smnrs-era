--- @class Hero40027_Skill1_Data : BaseSkillData Ariyuu
Hero40027_Skill1_Data = Class(Hero40027_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40027_Skill1_Data:CreateInstance()
    return Hero40027_Skill1_Data()
end

--- @return void
--- @param parsedData table
function Hero40027_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.skill_damage ~= nil, "skill_damage = nil")
    assert(parsedData.transform_duration ~= nil, "transform_duration = nil")

    assert(parsedData.stun_target_position ~= nil, "stun_target_position = nil")
    assert(parsedData.stun_target_number ~= nil, "stun_target_number = nil")
    assert(parsedData.stun_duration ~= nil, "stun_duration = nil")

    assert(parsedData.bond_target_position ~= nil, "bond_target_position = nil")
    assert(parsedData.bond_target_number ~= nil, "bond_target_number = nil")
    assert(parsedData.bond_damage_percent ~= nil, "bond_damage_percent = nil")
end

--- @return void
--- @param parsedData table
function Hero40027_Skill1_Data:ParseCsv(parsedData)
    self.skillDamage = tonumber(parsedData.skill_damage)
    self.transformDuration = tonumber(parsedData.transform_duration)

    self.stunTargetPosition = tonumber(parsedData.stun_target_position)
    self.stunTargetNumber = tonumber(parsedData.stun_target_number)
    self.stunDuration = tonumber(parsedData.stun_duration)

    self.bondTargetPosition = tonumber(parsedData.bond_target_position)
    self.bondTargetNumber = tonumber(parsedData.bond_target_number)
    self.bondDamagePercent = tonumber(parsedData.bond_damage_percent)
end

return Hero40027_Skill1_Data