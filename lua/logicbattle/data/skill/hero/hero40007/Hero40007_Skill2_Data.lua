--- @class Hero40007_Skill2_Data Noroth
Hero40007_Skill2_Data = Class(Hero40007_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40007_Skill2_Data:CreateInstance()
    return Hero40007_Skill2_Data()
end

--- @return void
function Hero40007_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.stat_buff_type ~= nil, "stat_buff_type = nil")
    assert(parsedData.stat_buff_amount ~= nil, "stat_buff_amount = nil")
    assert(parsedData.stat_buff_duration ~= nil, "stat_buff_duration = nil")
end

--- @return void
function Hero40007_Skill2_Data:ParseCsv(parsedData)
    self.statBuffType = tonumber(parsedData.stat_buff_type)
    self.statBuffAmount = tonumber(parsedData.stat_buff_amount)
    self.statBuffDuration = tonumber(parsedData.stat_buff_duration)
end

return Hero40007_Skill2_Data