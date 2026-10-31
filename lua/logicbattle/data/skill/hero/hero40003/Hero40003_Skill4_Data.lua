--- @class Hero40003_Skill4_Data Arryl
Hero40003_Skill4_Data = Class(Hero40003_Skill4_Data, BaseSkillData)

--- @return BaseSkillData
function Hero40003_Skill4_Data:CreateInstance()
    return Hero40003_Skill4_Data()
end

--- @return void
function Hero40003_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.reflect_chance ~= nil, "damage = nil")
    assert(parsedData.reflect_damage ~= nil, "damage = nil")
end

--- @return void
function Hero40003_Skill4_Data:ParseCsv(parsedData)
    self.reflectChance = tonumber(parsedData.reflect_chance)
    self.reflectDamage = tonumber(parsedData.reflect_damage)
end

return Hero40003_Skill4_Data