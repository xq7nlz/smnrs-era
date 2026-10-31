--- @class Summoner4_Skill4_3_Data Assassin
Summoner4_Skill4_3_Data = Class(Summoner4_Skill4_3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill4_3_Data:CreateInstance()
    return Summoner4_Skill4_3_Data()
end

--- @return void
function Summoner4_Skill4_3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.buff_per_power ~= nil, "buff_per_power = nil")

    assert(parsedData.buff_type ~= nil, "buff_type = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
end

--- @return void
function Summoner4_Skill4_3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.buffPerPower = tonumber(parsedData.buff_per_power)

    self.statBuffType = tonumber(parsedData.buff_type)
    self.statBuffAmount = tonumber(parsedData.buff_amount)
end

return Summoner4_Skill4_3_Data