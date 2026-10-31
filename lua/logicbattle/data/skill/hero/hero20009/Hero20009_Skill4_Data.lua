--- @class Hero20009_Skill4_Data Fragnil
Hero20009_Skill4_Data = Class(Hero20009_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20009_Skill4_Data:CreateInstance()
    return Hero20009_Skill4_Data()
end

--- @return void
function Hero20009_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")
    assert(parsedData.trigger_chance ~= nil, "trigger_chance = nil")
end

--- @return void
function Hero20009_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)
    self.triggerChance = tonumber(parsedData.trigger_chance)
end

return Hero20009_Skill4_Data
