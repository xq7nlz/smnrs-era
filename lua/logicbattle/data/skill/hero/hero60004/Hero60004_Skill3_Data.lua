--- @class Hero60004_Skill3_Data Karos
Hero60004_Skill3_Data = Class(Hero60004_Skill3_Data, BaseSkillData)

--- @return BaseSkillData
function Hero60004_Skill3_Data:CreateInstance()
    return Hero60004_Skill3_Data()
end

--- @return void
function Hero60004_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.reduce_damage_dark_mark ~= nil, "reduce_damage_dark_mark = nil")
end

--- @return void
function Hero60004_Skill3_Data:ParseCsv(parsedData)
    self.reduceDamageDarkMark = tonumber(parsedData.reduce_damage_dark_mark)
end

return Hero60004_Skill3_Data