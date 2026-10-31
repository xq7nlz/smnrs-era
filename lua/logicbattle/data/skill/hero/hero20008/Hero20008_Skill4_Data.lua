--- @class Hero20008_Skill4_Data Moblin
Hero20008_Skill4_Data = Class(Hero20008_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero20008_Skill4_Data:CreateInstance()
    return Hero20008_Skill4_Data()
end

--- @return void
function Hero20008_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger_buff_1 ~= nil, "health_trigger_buff_1 = nil")
    assert(parsedData.stat_1_buff_type_1 ~= nil, "stat_1_buff_type_1 = nil")
    assert(parsedData.stat_1_buff_amount_1 ~= nil, "stat_1_buff_amount_1 = nil")
    assert(parsedData.stat_2_buff_type_1 ~= nil, "stat_2_buff_type_1 = nil")
    assert(parsedData.stat_2_buff_amount_1 ~= nil, "stat_2_buff_amount_1 = nil")

    assert(parsedData.health_trigger_buff_2 ~= nil, "health_trigger_buff_2 = nil")
    assert(parsedData.stat_1_buff_type_2 ~= nil, "stat_1_buff_type_2 = nil")
    assert(parsedData.stat_1_buff_amount_2 ~= nil, "stat_1_buff_amount_2 = nil")
    assert(parsedData.stat_2_buff_type_2 ~= nil, "stat_2_buff_type_2 = nil")
    assert(parsedData.stat_2_buff_amount_2 ~= nil, "stat_2_buff_amount_2 = nil")
end

--- @return void
function Hero20008_Skill4_Data:ParseCsv(parsedData)
    self.healthTriggerBuff_1 = tonumber(parsedData.health_trigger_buff_1)

    self.stat_1_buff_type_1 = tonumber(parsedData.stat_1_buff_type_1)
    self.stat_1_buff_amount_1 = tonumber(parsedData.stat_1_buff_amount_1)
    self.stat_2_buff_type_1 = tonumber(parsedData.stat_2_buff_type_1)
    self.stat_2_buff_amount_1 = tonumber(parsedData.stat_2_buff_amount_1)

    self.healthTriggerBuff_2 = tonumber(parsedData.health_trigger_buff_2)
    self.stat_1_buff_type_2 = tonumber(parsedData.stat_1_buff_type_2)
    self.stat_1_buff_amount_2 = tonumber(parsedData.stat_1_buff_amount_2)
    self.stat_2_buff_type_2 = tonumber(parsedData.stat_2_buff_type_2)
    self.stat_2_buff_amount_2 = tonumber(parsedData.stat_2_buff_amount_2)
end

return Hero20008_Skill4_Data
