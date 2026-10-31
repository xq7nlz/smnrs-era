--- @class Hero30002_Skill3_Data En
Hero30002_Skill3_Data = Class(Hero30002_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30002_Skill3_Data:CreateInstance()
    return Hero30002_Skill3_Data()
end

--- @return void
function Hero30002_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_be_attacked ~= nil, "hp_be_attacked = nil")
end

--- @return void
function Hero30002_Skill3_Data:ParseCsv(parsedData)
    self.hpBeAttacked = tonumber(parsedData.hp_be_attacked)
end

return Hero30002_Skill3_Data