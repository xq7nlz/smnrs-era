--- @class Hero60002_Skill1_Data Bloodseeker
Hero60002_Skill1_Data = Class(Hero60002_Skill1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60002_Skill1_Data:CreateInstance()
    return Hero60002_Skill1_Data()
end

--- @return void
function Hero60002_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_to_steal ~= nil, "stat_to_steal = nil")
    assert(parsedData.stat_steal_amount ~= nil, "stat_steal_amount = nil")
    assert(parsedData.steal_duration ~= nil, "steal_duration = nil")
end

--- @return void
function Hero60002_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statTypeToSteal = tonumber(parsedData.stat_to_steal)
    self.statStealAmount = tonumber(parsedData.stat_steal_amount)
    self.stealDuration = tonumber(parsedData.steal_duration)
end

return Hero60002_Skill1_Data