--- @class Hero50003_Skill4_Data LifeKeeper
Hero50003_Skill4_Data = Class(Hero50003_Skill4_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50003_Skill4_Data:CreateInstance()
    return Hero50003_Skill4_Data()
end

function Hero50003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.revive_hp_percent ~= nil, "revive_hp_percent = nil")
    assert(parsedData.revive_chance ~= nil, "revive_chance = nil")
end

function Hero50003_Skill4_Data:ParseCsv(parsedData)
    self.reviveHpPercent = tonumber(parsedData.revive_hp_percent)
    self.reviveChance = tonumber(parsedData.revive_chance)
end

return Hero50003_Skill4_Data