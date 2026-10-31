--- @class Hero30006_Skill3_Data Thanatos
Hero30006_Skill3_Data = Class(Hero30006_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30006_Skill3_Data:CreateInstance()
    return Hero30006_Skill3_Data()
end

--- @return void
function Hero30006_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit ~= nil, "hp_limit = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
    assert(parsedData.heal_duration ~= nil, "heal_duration = nil")

    assert(parsedData.trigger_limit ~= nil, "trigger_limit = nil")
end

--- @return void
function Hero30006_Skill3_Data:ParseCsv(parsedData)
    self.hpLimit = tonumber(parsedData.hp_limit)
    self.healAmount = tonumber(parsedData.heal_amount)
    self.healDuration = tonumber(parsedData.heal_duration)

    self.triggerLimit = tonumber(parsedData.trigger_limit)
end

return Hero30006_Skill3_Data