--- @class Summoner5_Skill1_2_Data Ranger
Summoner5_Skill1_2_Data = Class(Summoner5_Skill1_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill1_2_Data:CreateInstance()
    return Summoner5_Skill1_2_Data()
end

--- @return void
function Summoner5_Skill1_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.damage_receive_debuff_amount ~= nil, "damage_receive_debuff_amount = nil")
    assert(parsedData.damage_receive_debuff_duration ~= nil, "damage_receive_debuff_duration = nil")
end

--- @return void
function Summoner5_Skill1_2_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.damageReceiveDebuffAmount = tonumber(parsedData.damage_receive_debuff_amount)
    self.damageReceiveDebuffDuration = tonumber(parsedData.damage_receive_debuff_duration)
end

return Summoner5_Skill1_2_Data