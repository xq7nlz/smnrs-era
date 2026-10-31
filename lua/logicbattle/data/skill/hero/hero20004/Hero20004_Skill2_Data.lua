--- @class Hero20004_Skill2_Data Defronowe
Hero20004_Skill2_Data = Class(Hero20004_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20004_Skill2_Data:CreateInstance()
    return Hero20004_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero20004_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.steal_stat_type ~= nil, "steal_stat_type = nil")
    assert(parsedData.steal_stat_amount ~= nil, "steal_stat_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero20004_Skill2_Data:ParseCsv(parsedData)
    self.targetNumber = tonumber(parsedData.target_number)
    self.targetPosition = tonumber(parsedData.target_position)

    self.stealStatType = tonumber(parsedData.steal_stat_type)
    self.stealStatAmount = tonumber(parsedData.steal_stat_amount)
end

return Hero20004_Skill2_Data