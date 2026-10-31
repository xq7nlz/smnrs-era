--- @class Summoner4_Skill3_2_Data Assassin
Summoner4_Skill3_2_Data = Class(Summoner4_Skill3_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill3_2_Data:CreateInstance()
    return Summoner4_Skill3_2_Data()
end

--- @return void
function Summoner4_Skill3_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
    assert(parsedData.target_class ~= nil, "target_class = nil")

    assert(parsedData.bond_target_position ~= nil, "bond_target_position = nil")
    assert(parsedData.bond_target_number ~= nil, "bond_target_number = nil")
    assert(parsedData.bond_share_damage ~= nil, "bond_share_damage = nil")
    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")
end

--- @return void
function Summoner4_Skill3_2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.targetClass = tonumber(parsedData.target_class)

    self.bondTargetPosition = tonumber(parsedData.bond_target_position)
    self.bondTargetNumber = tonumber(parsedData.bond_target_number)

    self.bondShareDamage = tonumber(parsedData.bond_share_damage)
    self.bondDuration = tonumber(parsedData.bond_duration)
end

return Summoner4_Skill3_2_Data