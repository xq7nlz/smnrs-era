--- @class Hero30011_Skill2_Data Skaven
Hero30011_Skill2_Data = Class(Hero30011_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30011_Skill2_Data:CreateInstance()
    return Hero30011_Skill2_Data()
end

--- @return void
function Hero30011_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_heal_percent ~= nil, "hp_heal_percent = nil")
end

--- @return void
function Hero30011_Skill2_Data:ParseCsv(parsedData)
    self.healHpPercent = tonumber(parsedData.hp_heal_percent)
end

return Hero30011_Skill2_Data