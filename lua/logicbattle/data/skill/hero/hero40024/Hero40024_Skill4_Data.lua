--- @class Hero40024_Skill4_Data Wugushi
Hero40024_Skill4_Data = Class(Hero40024_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40024_Skill4_Data:CreateInstance()
    return Hero40024_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero40024_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_type ~= nil, "buff_type = nil")
    assert(parsedData.buff_amount ~= nil, "buff_amount = nil")
    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero40024_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)

    self.buffType = tonumber(parsedData.buff_type)
    self.buffAmount = tonumber(parsedData.buff_amount)
    self.buffDuration = tonumber(parsedData.buff_duration)
end

return Hero40024_Skill4_Data
