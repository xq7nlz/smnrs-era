--- @class Summoner1_Skill1_2_Data Mage
Summoner1_Skill1_2_Data = Class(Summoner1_Skill1_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill1_2_Data:CreateInstance()
    return Summoner1_Skill1_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill1_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_chance ~= nil, "stat_debuff_chance = nil")
    assert(parsedData.stat_debuff_duration ~= nil, "stat_debuff_duration = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill1_2_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffChance = tonumber(parsedData.stat_debuff_chance)
    self.statDebuffDuration = tonumber(parsedData.stat_debuff_duration)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Summoner1_Skill1_2_Data