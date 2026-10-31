--- @class Summoner4_Skill1_3_Data Assassin
Summoner4_Skill1_3_Data = Class(Summoner4_Skill1_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill1_3_Data:CreateInstance()
    return Summoner4_Skill1_3_Data()
end

--- @return void
function Summoner4_Skill1_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_type ~= nil, "buff_type = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
end

--- @return void
function Summoner4_Skill1_3_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.statBuffTargetPosition = tonumber(parsedData.buff_target_position)
    self.statBuffTargetNumber = tonumber(parsedData.buff_target_number)

    self.statBuffDuration = tonumber(parsedData.buff_duration)
    self.statBuffType = tonumber(parsedData.buff_type)
    self.statBuffAmount = tonumber(parsedData.buff_amount)
end

return Summoner4_Skill1_3_Data