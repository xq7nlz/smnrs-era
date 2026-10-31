--- @class Summoner4_Skill4_2_Data Assassin
Summoner4_Skill4_2_Data = Class(Summoner4_Skill4_2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner4_Skill4_2_Data:CreateInstance()
    return Summoner4_Skill4_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner4_Skill4_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_type ~= nil, "buff_type = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Summoner4_Skill4_2_Data:ParseCsv(parsedData)
    self.statBuffDuration = tonumber(parsedData.buff_duration)
    self.statBuffType = tonumber(parsedData.buff_type)
    self.statBuffAmount = tonumber(parsedData.buff_amount)
end

return Summoner4_Skill4_2_Data