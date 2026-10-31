--- @class Hero30001_Skill1_Data Charon
Hero30001_Skill1_Data = Class(Hero30001_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30001_Skill1_Data:CreateInstance()
    return Hero30001_Skill1_Data()
end

--- @return void
function Hero30001_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.max_hp_to_kill ~= nil, "max_hp_to_kill = nil")
    assert(parsedData.power_gain_when_kill ~= nil, "power_gain_when_kill = nil")
end

--- @return void
function Hero30001_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.maxHpToKill = tonumber(parsedData.max_hp_to_kill)
    self.powerGainWhenKill = tonumber(parsedData.power_gain_when_kill)
end

return Hero30001_Skill1_Data