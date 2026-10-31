--- @class Hero50007_Skill3_Data Celestia
Hero50007_Skill3_Data = Class(Hero50007_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50007_Skill3_Data:CreateInstance()
    return Hero50007_Skill3_Data()
end

--- @return void
function Hero50007_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_trigger ~= nil, "health_trigger = nil")
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Hero50007_Skill3_Data:ParseCsv(parsedData)
    self.healthTrigger = tonumber(parsedData.health_trigger)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero50007_Skill3_Data