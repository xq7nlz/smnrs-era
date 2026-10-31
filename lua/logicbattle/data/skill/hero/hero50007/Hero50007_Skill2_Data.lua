--- @class Hero50007_Skill2_Data Celestia
Hero50007_Skill2_Data = Class(Hero50007_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50007_Skill2_Data:CreateInstance()
    return Hero50007_Skill2_Data()
end

--- @return void
function Hero50007_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.steal_buff_target_position ~= nil, "steal_buff_target_position = nil")
    assert(parsedData.steal_buff_target_number ~= nil, "steal_buff_target_position = nil")

    assert(parsedData.steal_chance ~= nil, "steal_chance = nil")
    assert(parsedData.steal_stat_type_1 ~= nil, "steal_type_1 = nil")
    assert(parsedData.steal_stat_amount_1 ~= nil, "steal_amount_1 = nil")
    assert(parsedData.steal_stat_type_2 ~= nil, "steal_type_2 = nil")
    assert(parsedData.steal_stat_amount_2 ~= nil, "steal_stat_amount_2 = nil")
    assert(parsedData.steal_duration ~= nil, "steal_duration = nil")
end

--- @return void
function Hero50007_Skill2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.steal_buff_target_position)
    self.targetNumber = tonumber(parsedData.steal_buff_target_number)

    self.stealChance = tonumber(parsedData.steal_chance)
    self.stealStatType_1 = tonumber(parsedData.steal_stat_type_1)
    self.stealStatAmount_1 = tonumber(parsedData.steal_stat_amount_1)
    self.stealStatType_2 = tonumber(parsedData.steal_stat_type_2)
    self.stealStatAmount_2 = tonumber(parsedData.steal_stat_amount_2)
    self.stealDuration = tonumber(parsedData.steal_duration)
end

return Hero50007_Skill2_Data