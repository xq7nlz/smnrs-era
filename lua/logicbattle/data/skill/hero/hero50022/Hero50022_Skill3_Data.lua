--- @class Hero50022_Skill3_Data Elf
Hero50022_Skill3_Data = Class(Hero50022_Skill3_Data, BaseSkillData)

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero50022_Skill3_Data:CreateInstance()
    return Hero50022_Skill3_Data()
end

--- @return void
--- @param parsedData table
function Hero50022_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.power_gain_start_battle ~= nil, "power_gain_start_battle = nil")
end

--- @return void
--- @param parsedData table
function Hero50022_Skill3_Data:ParseCsv(parsedData)
    self.powerGainStartBattle = tonumber(parsedData.power_gain_start_battle)
end

return Hero50022_Skill3_Data
