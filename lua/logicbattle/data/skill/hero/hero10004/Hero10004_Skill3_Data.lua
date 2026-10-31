--- @class Hero10004_Skill3_Data Frosthardy
Hero10004_Skill3_Data = Class(Hero10004_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10004_Skill3_Data:CreateInstance()
    return Hero10004_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero10004_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.damage_bonus_percent ~= nil, "damage_bonus_percent = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_chance ~= nil, "effect_chance = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
--- @param parsedData table
function Hero10004_Skill3_Data:ParseCsv(parsedData)
    self.damageBonusPercent = tonumber(parsedData.damage_bonus_percent)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectChance = tonumber(parsedData.effect_chance)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero10004_Skill3_Data