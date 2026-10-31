--- @class Summoner5_Skill1_3_Data Ranger
Summoner5_Skill1_3_Data = Class(Summoner5_Skill1_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill1_3_Data:CreateInstance()
    return Summoner5_Skill1_3_Data()
end

--- @return void
function Summoner5_Skill1_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.debuff_chance ~= nil, "debuff_chance = nil")
    assert(parsedData.debuff_type ~= nil, "debuff_type = nil")
    assert(parsedData.debuff_amount ~= nil, "debuff_amount = nil")
    assert(parsedData.debuff_duration ~= nil, "debuff_duration = nil")
end

--- @return void
function Summoner5_Skill1_3_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.debuffChance = tonumber(parsedData.debuff_chance)
    self.debuffType = tonumber(parsedData.debuff_type)
    self.debuffAmount = tonumber(parsedData.debuff_amount)
    self.debuffDuration = tonumber(parsedData.debuff_duration)
end

return Summoner5_Skill1_3_Data