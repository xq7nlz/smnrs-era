--- @class Hero30006_Skill2_Data Thanatos
Hero30006_Skill2_Data = Class(Hero30006_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30006_Skill2_Data:CreateInstance()
    return Hero30006_Skill2_Data()
end

--- @return void
function Hero30006_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_attack ~= nil, "bonus_attack = nil")
    assert(parsedData.hp_percent_lost_per_bonus ~= nil, "hp_percent_lost_per_bonus = nil")
end

--- @return void
function Hero30006_Skill2_Data:ParseCsv(parsedData)
    self.bonusAttack = tonumber(parsedData.bonus_attack)
    self.hpPercentLostPerBonus = tonumber(parsedData.hp_percent_lost_per_bonus)
end

return Hero30006_Skill2_Data