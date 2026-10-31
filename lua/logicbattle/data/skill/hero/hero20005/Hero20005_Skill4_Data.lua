--- @class Hero20005_Skill4_Data Yin
Hero20005_Skill4_Data = Class(Hero20005_Skill4_Data, BaseSkillData)

--- @return void
function Hero20005_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)
end

--- @return BaseSkillData
function Hero20005_Skill4_Data:CreateInstance()
    return Hero20005_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero20005_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.multi_bonus_damage_per_effect ~= nil, "multi_bonus_damage_per_burn = nil")
    assert(parsedData.effect_check_type ~= nil, "effect_check_type = nil")
end

--- @return void
--- @param parsedData table
function Hero20005_Skill4_Data:ParseCsv(parsedData)
    self.multi_bonus_damage_per_effect = tonumber(parsedData.multi_bonus_damage_per_effect)
    self.effect_check_type = tonumber(parsedData.effect_check_type)
end

return Hero20005_Skill4_Data