--- @class Hero60009_Skill3_Data Khann
Hero60009_Skill3_Data = Class(Hero60009_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60009_Skill3_Data:CreateInstance()
    return Hero60009_Skill3_Data()
end

--- @return void
function Hero60009_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.mark_duration ~= nil, "mark_duration = nil")

    assert(parsedData.damage_receive_debuff_amount ~= nil, "damage_receive_debuff_amount = nil")
    assert(parsedData.damage_receive_debuff_duration ~= nil, "damage_receive_debuff_duration = nil")
end

--- @return void
function Hero60009_Skill3_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.markDuration = tonumber(parsedData.mark_duration)

    self.damageReceiveDebuffAmount = tonumber(parsedData.damage_receive_debuff_amount)
    self.damageReceiveDebuffDuration = tonumber(parsedData.damage_receive_debuff_duration)
end

return Hero60009_Skill3_Data