--- @class Hero40002_Skill3_Data Yggra
Hero40002_Skill3_Data = Class(Hero40002_Skill3_Data, BaseSkillData)

--- @return void
function Hero40002_Skill3_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero40002_Skill3_Data:CreateInstance()
    return Hero40002_Skill3_Data()
end

--- @return void
function Hero40002_Skill3_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.block_chance ~= nil, "block_chance = nil")
    assert(parsedData.block_rate ~= nil, "block_rate = nil")
end

--- @return void
function Hero40002_Skill3_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.blockChance = tonumber(parsedData.block_chance)
    self.blockRate = tonumber(parsedData.block_rate)
end

return Hero40002_Skill3_Data