--- @class Summoner3_Skill1_3_Data Priest
Summoner3_Skill1_3_Data = Class(Summoner3_Skill1_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner3_Skill1_3_Data:CreateInstance()
    return Summoner3_Skill1_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.bond_target_position ~= nil, "bond_target_position = nil")
    assert(parsedData.bond_target_number ~= nil, "bond_target_number = nil")
    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_3_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.bondTargetPosition = tonumber(parsedData.bond_target_position)
    self.bondTargetNumber = tonumber(parsedData.bond_target_number)
    self.bondDuration = tonumber(parsedData.bond_duration)
end

return Summoner3_Skill1_3_Data