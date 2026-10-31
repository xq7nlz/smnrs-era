--- @class Hero50002_Skill3_Data HolyKnight
Hero50002_Skill3_Data = Class(Hero50002_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50002_Skill3_Data:CreateInstance()
    return Hero50002_Skill3_Data()
end

--- @return void
function Hero50002_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.revive_chance ~= nil, "revive_chance = nil")
    assert(parsedData.revive_hp_percent ~= nil, "revive_hp_percent = nil")
end

--- @return void
function Hero50002_Skill3_Data:ParseCsv(parsedData)
    self.reviveChance = tonumber(parsedData.revive_chance)
    self.reviveHpPercent = tonumber(parsedData.revive_hp_percent)
end

return Hero50002_Skill3_Data