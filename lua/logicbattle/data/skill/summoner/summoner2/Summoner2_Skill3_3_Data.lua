--- @class Summoner2_Skill3_3_Data Warrior
Summoner2_Skill3_3_Data = Class(Summoner2_Skill3_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill3_3_Data:CreateInstance()
    return Summoner2_Skill3_3_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.last_chance_rate ~= nil, "last_chance_rate = nil")
    assert(parsedData.trigger_max ~= nil, "trigger_max = nil")
    assert(parsedData.power_gain ~= nil, "power_gain = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.lastChanceRate = tonumber(parsedData.last_chance_rate)
    self.triggerMax = tonumber(parsedData.trigger_max)
    self.powerGain = tonumber(parsedData.power_gain)
end

return Summoner2_Skill3_3_Data