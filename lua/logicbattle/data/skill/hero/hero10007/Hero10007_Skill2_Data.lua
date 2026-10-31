--- @class Hero10007_Skill2_Data Osse
Hero10007_Skill2_Data = Class(Hero10007_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10007_Skill2_Data:CreateInstance()
    return Hero10007_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10007_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.bond_damage_percent ~= nil, "bond_damage_percent = nil")
    assert(parsedData.bond_cc_chance ~= nil, "bond_cc_chance = nil")

    assert(parsedData.damage_percent ~= nil, "damage_percent = nil")
    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10007_Skill2_Data:ParseCsv(parsedData)
    self.damagePercent = tonumber(parsedData.damage_percent)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.bondDamagePercent = tonumber(parsedData.bond_damage_percent)
    self.bondCcChance = tonumber(parsedData.bond_cc_chance)
    self.bondDuration = tonumber(parsedData.bond_duration)
end

return Hero10007_Skill2_Data