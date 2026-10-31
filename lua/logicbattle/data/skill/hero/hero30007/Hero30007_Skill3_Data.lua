--- @class Hero30007_Skill3_Data Zygor
Hero30007_Skill3_Data = Class(Hero30007_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero30007_Skill3_Data:CreateInstance()
    return Hero30007_Skill3_Data()
end

--- @return void
function Hero30007_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.passive_chance ~= nil, "passive_chance = nil")
    assert(parsedData.block_amount ~= nil, "block_amount = nil")
    assert(parsedData.effect_type ~= nil, "effect_type = nil")
    assert(parsedData.effect_duration ~= nil, "effect_duration = nil")
end

--- @return void
function Hero30007_Skill3_Data:ParseCsv(parsedData)
    self.passiveChance = tonumber(parsedData.passive_chance)
    self.blockAmount = tonumber(parsedData.block_amount)
    self.effectType = tonumber(parsedData.effect_type)
    self.effectDuration = tonumber(parsedData.effect_duration)
end

return Hero30007_Skill3_Data