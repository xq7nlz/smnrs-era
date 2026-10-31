--- @class Hero30006_Skill4_Data Thanatos
Hero30006_Skill4_Data = Class(Hero30006_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30006_Skill4_Data:CreateInstance()
    return Hero30006_Skill4_Data()
end

--- @return void
function Hero30006_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.hp_limit_to_kill ~= nil, "hp_limit_to_kill = nil")
end

--- @return void
function Hero30006_Skill4_Data:ParseCsv(parsedData)
    self.hpLimitToKill = tonumber(parsedData.hp_limit_to_kill)
end

return Hero30006_Skill4_Data