--- @class Hero50010_Skill4_Data Sephion
Hero50010_Skill4_Data = Class(Hero50010_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50010_Skill4_Data:CreateInstance()
    return Hero50010_Skill4_Data()
end

--- @return void
function Hero50010_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.health_bonus_trigger ~= nil, "health_bonus_trigger = nil")
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
end

--- @return void
function Hero50010_Skill4_Data:ParseCsv(parsedData)
    self.healthBonusTrigger = tonumber(parsedData.health_bonus_trigger)
    self.bonusDamage = tonumber(parsedData.bonus_damage)
end

return Hero50010_Skill4_Data