--- @class Summoner2_Skill3_1_Data Warrior
Summoner2_Skill3_1_Data = Class(Summoner2_Skill3_1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill3_1_Data:CreateInstance()
    return Summoner2_Skill3_1_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.reduce_damage_amount ~= nil, "reduce_damage_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill3_1_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.damageReduceWhenCC = tonumber(parsedData.reduce_damage_amount)
end

return Summoner2_Skill3_1_Data