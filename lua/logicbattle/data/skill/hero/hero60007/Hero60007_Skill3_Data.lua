--- @class Hero60007_Skill3_Data Rannantos
Hero60007_Skill3_Data = Class(Hero60007_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero60007_Skill3_Data:CreateInstance()
    return Hero60007_Skill3_Data()
end

--- @return void
function Hero60007_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.heal_amount ~= nil, "heal_amount = nil")
end

--- @return void
function Hero60007_Skill3_Data:ParseCsv(parsedData)
    self.healAmount = tonumber(parsedData.heal_amount)
end

return Hero60007_Skill3_Data