--- @class Hero50008_Skill3_Data Fanar
Hero50008_Skill3_Data = Class(Hero50008_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50008_Skill3_Data:CreateInstance()
    return Hero50008_Skill3_Data()
end

--- @return void
function Hero50008_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.power_buff_amount ~= nil, "power_buff_amount = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")
end

--- @return void
function Hero50008_Skill3_Data:ParseCsv(parsedData)
    self.powerBuffAmount = tonumber(parsedData.power_buff_amount)

    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)
end

return Hero50008_Skill3_Data