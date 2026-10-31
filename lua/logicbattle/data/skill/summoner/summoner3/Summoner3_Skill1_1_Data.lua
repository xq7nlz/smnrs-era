--- @class Summoner3_Skill1_1_Data Priest
Summoner3_Skill1_1_Data = Class(Summoner3_Skill1_1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner3_Skill1_1_Data:CreateInstance()
    return Summoner3_Skill1_1_Data()
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
end

--- @return void
--- @param parsedData table
function Summoner3_Skill1_1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.damage_target_position)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healPercent = tonumber(parsedData.heal_percent)
end

return Summoner3_Skill1_1_Data
