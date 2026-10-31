--- @class Hero10009_Skill2_Data Lashna
Hero10009_Skill2_Data = Class(Hero10009_Skill2_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero10009_Skill2_Data:CreateInstance()
    return Hero10009_Skill2_Data()
end

--- @return void
--- @param parsedData table
function Hero10009_Skill2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.number_bouncing ~= nil, "number_bouncing = nil")
    assert(parsedData.damage_bouncing ~= nil, "damage_bouncing = nil")
end

--- @return void
--- @param parsedData table
function Hero10009_Skill2_Data:ParseCsv(parsedData)
    self.numberBouncing = tonumber(parsedData.number_bouncing)
    self.damageBouncing = tonumber(parsedData.damage_bouncing)
end

return Hero10009_Skill2_Data