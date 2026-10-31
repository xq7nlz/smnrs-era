--- @class Hero20001_Skill4_Data Icarus
Hero20001_Skill4_Data = Class(Hero20001_Skill4_Data, BaseSkillData)

--- @return void
function Hero20001_Skill4_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @type StatChangerDataHelper
    self.statChangerDataHelper = StatChangerDataHelper(self)
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Hero20001_Skill4_Data:CreateInstance()
    return Hero20001_Skill4_Data()
end

--- @return void
--- @param parsedData table
function Hero20001_Skill4_Data:ValidateBeforeParseCsv(parsedData)
    self.statChangerDataHelper:ValidateBeforeParseCsv(parsedData)

    assert(parsedData.time_reborn ~= nil, "time_reborn = nil")
    assert(parsedData.round_reborn ~= nil, "round_reborn = nil")

    assert(parsedData.effect_1_type ~= nil, "effect_1_type = nil")
    assert(parsedData.effect_1_chance ~= nil, "effect_1_chance = nil")
    assert(parsedData.effect_1_duration ~= nil, "effect_1_duration = nil")
    assert(parsedData.target_number ~= nil, "target_number = nil")
    assert(parsedData.target_position ~= nil, "target_position = nil")
end

--- @return void
--- @param parsedData table
function Hero20001_Skill4_Data:ParseCsv(parsedData)
    self.statChangerDataHelper:ParseCsv(parsedData)

    self.time_reborn = tonumber(parsedData.time_reborn)
    self.round_reborn = tonumber(parsedData.round_reborn)

    self.effect_1_type = tonumber(parsedData.effect_1_type)
    self.effect_1_chance = tonumber(parsedData.effect_1_chance)
    self.effect_1_duration = tonumber(parsedData.effect_1_duration)
    self.target_number = tonumber(parsedData.target_number)
    self.target_position = tonumber(parsedData.target_position)
end

return Hero20001_Skill4_Data