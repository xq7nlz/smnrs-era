--- @class Hero30021_Skill1_Data EarthMaster
Hero30021_Skill1_Data = Class(Hero30021_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30021_Skill1_Data:CreateInstance()
    return Hero30021_Skill1_Data()
end

--- @return void
function Hero30021_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.heal_percent ~= nil, "heal_percent = nil")
    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")

    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_duration ~= nil, "heal_duration = nil")
end

--- @return void
function Hero30021_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.damageTargetPosition = tonumber(parsedData.target_position)
    self.damageTargetNumber = tonumber(parsedData.target_number)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)

    self.healPercent = tonumber(parsedData.heal_percent)
    self.healDuration = tonumber(parsedData.heal_duration)
end

return Hero30021_Skill1_Data