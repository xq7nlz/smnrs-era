--- @class Hero30019_Skill2_Data Elne
Hero30019_Skill2_Data = Class(Hero30019_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30019_Skill2_Data:CreateInstance()
    return Hero30019_Skill2_Data()
end

--- @return void
function Hero30019_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage ~= nil, "bonus_damage = nil")
    assert(parsedData.heal_trigger ~= nil, "heal_trigger = nil")
end

--- @return void
function Hero30019_Skill2_Data:ParseCsv(parsedData)
    self.healTrigger = tonumber(parsedData.heal_trigger)
    self.bonusDamage = tonumber(parsedData.bonus_damage)
end

return Hero30019_Skill2_Data