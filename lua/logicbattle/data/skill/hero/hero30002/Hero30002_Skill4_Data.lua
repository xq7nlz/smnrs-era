--- @class Hero30002_Skill4_Data En
Hero30002_Skill4_Data = Class(Hero30002_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30002_Skill4_Data:CreateInstance()
    return Hero30002_Skill4_Data()
end

--- @return void
function Hero30002_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_heal ~= nil, "hp_heal = nil")
end

--- @return void
function Hero30002_Skill4_Data:ParseCsv(parsedData)
    self.hpHeal = tonumber(parsedData.hp_heal)
end

return Hero30002_Skill4_Data