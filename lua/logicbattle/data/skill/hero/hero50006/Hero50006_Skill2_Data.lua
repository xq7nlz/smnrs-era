--- @class Hero50006_Skill2_Data Enule
Hero50006_Skill2_Data = Class(Hero50006_Skill2_Data, BaseSkillData)

--- @return BaseSkillData
function Hero50006_Skill2_Data:CreateInstance()
    return Hero50006_Skill2_Data()
end

--- @return void
function Hero50006_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_bouncing ~= nil, "number_bouncing = nil")
    assert(parsedData.damage_bouncing ~= nil, "damage_bouncing = nil")
end

--- @return void
function Hero50006_Skill2_Data:ParseCsv(parsedData)
    self.numberBouncing = tonumber(parsedData.number_bouncing)
    self.damageBouncing = tonumber(parsedData.damage_bouncing)
end

return Hero50006_Skill2_Data