--- @class Hero40025_Skill4_Data Arason
Hero40025_Skill4_Data = Class(Hero40025_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40025_Skill4_Data:CreateInstance()
    return Hero40025_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero40025_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.heal_target_position ~= nil, "heal_target_position = nil")
    assert(parsedData.heal_target_number ~= nil, "heal_target_number = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
--- @param parsedData table
function Hero40025_Skill4_Data:ParseCsv(parsedData)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.healTargetPosition = tonumber(parsedData.heal_target_position)
    self.healTargetNumber = tonumber(parsedData.heal_target_number)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero40025_Skill4_Data
