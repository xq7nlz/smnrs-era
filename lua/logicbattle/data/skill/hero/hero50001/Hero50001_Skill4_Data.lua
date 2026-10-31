--- @class Hero50001_Skill4_Data AmiableAngel
Hero50001_Skill4_Data = Class(Hero50001_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50001_Skill4_Data:CreateInstance()
    return Hero50001_Skill4_Data()
end

--- @return void
function Hero50001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")

    assert(parsedData.target_position ~= nil, "target_position = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")

    assert(parsedData.max_hp_percent_to_heal ~= nil, "max_hp_to_heal = nil")
end

--- @return void
function Hero50001_Skill4_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.triggerLimit = tonumber(parsedData.trigger_limit)

    self.targetPosition = tonumber(parsedData.target_position)
    self.targetNumber = tonumber(parsedData.target_number)

    self.maxHpToHeal = tonumber(parsedData.max_hp_percent_to_heal)
end

return Hero50001_Skill4_Data