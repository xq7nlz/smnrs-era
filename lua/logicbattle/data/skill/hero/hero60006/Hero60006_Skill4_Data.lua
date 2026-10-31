--- @class Hero60006_Skill4_Data Eitri
Hero60006_Skill4_Data = Class(Hero60006_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60006_Skill4_Data:CreateInstance()
    return Hero60006_Skill4_Data()
end

--- @return void
function Hero60006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.attack_target_position ~= nil, "attack_target_position = nil")
    assert(parsedData.attack_target_number ~= nil, "attack_target_number = nil")

    assert(parsedData.buff_ally_position ~= nil, "buff_ally_position = nil")
    assert(parsedData.buff_ally_number ~= nil, "buff_ally_number = nil")

    assert(parsedData.steal_stat_type ~= nil, "steal_stat_type = nil")
    assert(parsedData.steal_stat_value ~= nil, "steal_stat_value = nil")

    assert(parsedData.transfer_ally_position ~= nil, "transfer_ally_position = nil")
    assert(parsedData.transfer_ally_number ~= nil, "transfer_ally_number = nil")

    assert(parsedData.transfer_stat_type_1 ~= nil, "transfer_stat_type_1 = nil")
    assert(parsedData.transfer_stat_type_2 ~= nil, "transfer_stat_type_2 = nil")
    assert(parsedData.transfer_stat_percent ~= nil, "transfer_stat_percent = nil")
end

--- @return void
function Hero60006_Skill4_Data:ParseCsv(parsedData)
    self.attackTargetPosition = tonumber(parsedData.attack_target_position)
    self.attackTargetNumber = tonumber(parsedData.attack_target_number)

    self.buffAllyPosition = tonumber(parsedData.buff_ally_position)
    self.buffAllyNumber = tonumber(parsedData.buff_ally_number)

    self.stealStatType = tonumber(parsedData.steal_stat_type)
    self.stealStatValue = tonumber(parsedData.steal_stat_value)

    self.transferAllyPosition = tonumber(parsedData.transfer_ally_position)
    self.transferAllyNumber = tonumber(parsedData.transfer_ally_number)

    self.transferStatType1 = tonumber(parsedData.transfer_stat_type_1)
    self.transferStatType2 = tonumber(parsedData.transfer_stat_type_2)

    self.transferStatPercent = tonumber(parsedData.transfer_stat_percent)
end
return Hero60006_Skill4_Data
