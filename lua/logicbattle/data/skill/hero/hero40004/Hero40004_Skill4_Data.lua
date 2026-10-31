--- @class Hero40004_Skill4_Data Cennunos
Hero40004_Skill4_Data = Class(Hero40004_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40004_Skill4_Data:CreateInstance()
    return Hero40004_Skill4_Data()
end

--- @return void
function Hero40004_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger_1 ~= nil, "health_trigger_1 = nil")
    assert(parsedData.trigger_1_stat_1_buff_type ~= nil, "trigger_1_stat_1_buff_type = nil")
    assert(parsedData.trigger_1_stat_1_buff_amount ~= nil, "trigger_1_stat_1_buff_amount = nil")
    assert(parsedData.trigger_1_stat_2_buff_type ~= nil, "trigger_1_stat_2_buff_type = nil")
    assert(parsedData.trigger_1_stat_2_buff_amount ~= nil, "trigger_1_stat_2_buff_amount = nil")

    assert(parsedData.health_trigger_2 ~= nil, "health_trigger_2 = nil")
    assert(parsedData.trigger_2_stat_1_buff_type ~= nil, "trigger_2_stat_1_buff_type = nil")
    assert(parsedData.trigger_2_stat_1_buff_amount ~= nil, "trigger_2_stat_1_buff_amount = nil")
    assert(parsedData.trigger_2_stat_2_buff_type ~= nil, "trigger_2_stat_2_buff_type = nil")
    assert(parsedData.trigger_2_stat_2_buff_amount ~= nil, "trigger_2_stat_2_buff_amount = nil")
end

--- @return void
function Hero40004_Skill4_Data:ParseCsv(parsedData)
    self.firstHealthTriggerBuff = tonumber(parsedData.health_trigger_1)
    self.statFirstBuffType = tonumber(parsedData.trigger_1_stat_1_buff_type)
    self.statFirstBuffAmount = tonumber(parsedData.trigger_1_stat_1_buff_amount)
    self.statSecondBuffType = tonumber(parsedData.trigger_1_stat_2_buff_type)
    self.statSecondBuffAmount = tonumber(parsedData.trigger_1_stat_2_buff_amount)

    self.secondHealthTriggerBuff = tonumber(parsedData.health_trigger_2)
    self.secondTriggerFirstStatBuffType = tonumber(parsedData.trigger_2_stat_1_buff_type)
    self.secondTriggerFirstStatBuffAmount = tonumber(parsedData.trigger_2_stat_1_buff_amount)
    self.secondTriggerSecondStatBuffType = tonumber(parsedData.trigger_2_stat_2_buff_type)
    self.secondTriggerSecondStatBuffAmount = tonumber(parsedData.trigger_2_stat_2_buff_amount)
end

return Hero40004_Skill4_Data
