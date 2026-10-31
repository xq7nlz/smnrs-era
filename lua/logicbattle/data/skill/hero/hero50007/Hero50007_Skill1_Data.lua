--- @class Hero50007_Skill1_Data Celestia
Hero50007_Skill1_Data = Class(Hero50007_Skill1_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50007_Skill1_Data:CreateInstance()
    return Hero50007_Skill1_Data()
end

--- @return void
function Hero50007_Skill1_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage ~= nil, "damage = nil")

    assert(parsedData.damage_target_position ~= nil, "damage_target_position = nil")
    assert(parsedData.damage_target_number ~= nil, "damage_target_number = nil")

    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")

    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_position = nil")
end

--- @return void
function Hero50007_Skill1_Data:ParseCsv(parsedData)
    self.damage = tonumber(parsedData.damage)
    self.damageTargetNumber = tonumber(parsedData.damage_target_number)
    self.damageTargetPosition = tonumber(parsedData.damage_target_position)

    self.healAmount = tonumber(parsedData.heal_amount)
    self.buffTargetNumber = tonumber(parsedData.buff_target_number)
    self.buffTargetPosition = tonumber(parsedData.buff_target_position)
end

return Hero50007_Skill1_Data