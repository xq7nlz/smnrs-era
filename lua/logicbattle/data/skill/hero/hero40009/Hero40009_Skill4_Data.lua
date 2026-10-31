--- @class Hero40009_Skill4_Data Sylph
Hero40009_Skill4_Data = Class(Hero40009_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40009_Skill4_Data:CreateInstance()
    return Hero40009_Skill4_Data()
end

--- @return void
function Hero40009_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_damage_when_crit ~= nil, "bonus_damage_when_crit = nil")
end

--- @return void
function Hero40009_Skill4_Data:ParseCsv(parsedData)
    self.bonusAttackWhenCrit = tonumber(parsedData.bonus_damage_when_crit)
end

return Hero40009_Skill4_Data