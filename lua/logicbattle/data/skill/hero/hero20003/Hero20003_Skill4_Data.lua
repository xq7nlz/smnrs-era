--- @class Hero20003_Skill4_Data Eitri
Hero20003_Skill4_Data = Class(Hero20003_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20003_Skill4_Data:CreateInstance()
    return Hero20003_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero20003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.stat_1_buff_type ~= nil, "stat_1_buff_type = nil")
    assert(parsedData.stat_1_buff_amount ~= nil, "stat_1_buff_amount = nil")

    assert(parsedData.stat_2_buff_type ~= nil, "stat_2_buff_type = nil")
    assert(parsedData.stat_2_buff_amount ~= nil, "stat_2_buff_amount = nil")

    assert(parsedData.stat_debuff_type ~= nil, "stat_debuff_type = nil")
    assert(parsedData.stat_debuff_amount ~= nil, "stat_debuff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero20003_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.statFirstType = tonumber(parsedData.stat_1_buff_type)
    self.statFirstBuffAmount = tonumber(parsedData.stat_1_buff_amount)

    --- @type StatType
    self.statSecondType = tonumber(parsedData.stat_2_buff_type)
    self.statSecondBuffAmount = tonumber(parsedData.stat_2_buff_amount)

    --- @type StatType
    self.statDebuffType = tonumber(parsedData.stat_debuff_type)
    self.statDebuffAmount = tonumber(parsedData.stat_debuff_amount)
end

return Hero20003_Skill4_Data
