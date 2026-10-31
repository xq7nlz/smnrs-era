--- @class Hero60007_Skill4_Data Rannantos
Hero60007_Skill4_Data = Class(Hero60007_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60007_Skill4_Data:CreateInstance()
    return Hero60007_Skill4_Data()
end

--- @return void
function Hero60007_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.buff_stat ~= nil, "buff_stat = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
end

--- @return void
function Hero60007_Skill4_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.buffStat = tonumber(parsedData.buff_stat)
    self.buffAmount = tonumber(parsedData.buff_amount)
    self.buffDuration = tonumber(parsedData.buff_duration)
end

return Hero60007_Skill4_Data
