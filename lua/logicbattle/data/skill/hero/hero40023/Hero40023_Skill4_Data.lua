--- @class Hero40023_Skill4_Data HoundMaster
Hero40023_Skill4_Data = Class(Hero40023_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40023_Skill4_Data:CreateInstance()
    return Hero40023_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero40023_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")

    assert(parsedData.stat_1_buff_type ~= nil, "stat_1_buff_type = nil")
    assert(parsedData.stat_1_buff_amount ~= nil, "stat_1_buff_amount = nil")

    assert(parsedData.stat_2_buff_type ~= nil, "stat_2_buff_type = nil")
    assert(parsedData.stat_2_buff_amount ~= nil, "stat_2_buff_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero40023_Skill4_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)

    self.statFirstType = tonumber(parsedData.stat_1_buff_type)
    self.statFirstBuffAmount = tonumber(parsedData.stat_1_buff_amount)
    self.statFirstCalculationType = tonumber(parsedData.stat_1_calculation_type)
    if self.statFirstCalculationType == nil then
        self.statFirstCalculationType = StatChangerCalculationType.PERCENT_ADD
    end

    self.statSecondType = tonumber(parsedData.stat_2_buff_type)
    self.statSecondBuffAmount = tonumber(parsedData.stat_2_buff_amount)
    self.statSecondCalculationType = tonumber(parsedData.stat_2_calculation_type)
    if self.statSecondCalculationType == nil then
        self.statSecondCalculationType = StatChangerCalculationType.PERCENT_ADD
    end
end

return Hero40023_Skill4_Data
