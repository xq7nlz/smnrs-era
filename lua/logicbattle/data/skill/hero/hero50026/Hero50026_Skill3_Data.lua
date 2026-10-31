--- @class Hero50026_Skill3_Data Fioneth
Hero50026_Skill3_Data = Class(Hero50026_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50026_Skill3_Data:CreateInstance()
    return Hero50026_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero50026_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.bonus_attack ~= nil, "bonus_attack = nil")
    assert(parsedData.affected_faction ~= nil, "affected_faction = nil")
end

--- @return void
--- @param parsedData table
function Hero50026_Skill3_Data:ParseCsv(parsedData)
    self.bonusAttack = tonumber(parsedData.bonus_attack)
    self.affectedFaction = tonumber(parsedData.affected_faction)
end

return Hero50026_Skill3_Data
