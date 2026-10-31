--- @class Summoner5_Skill3_1_Data Ranger
Summoner5_Skill3_1_Data = Class(Summoner5_Skill3_1_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner5_Skill3_1_Data:CreateInstance()
    return Summoner5_Skill3_1_Data()
end

--- @return void
function Summoner5_Skill3_1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.bonus_damage_receive ~= nil, "bonus_damage_receive = nil")
end

--- @return void
function Summoner5_Skill3_1_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.bonusDamageReceive = tonumber(parsedData.bonus_damage_receive)
end

return Summoner5_Skill3_1_Data