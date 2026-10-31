--- @class Summoner1_Skill3_2_Data Mage
Summoner1_Skill3_2_Data = Class(Summoner1_Skill3_2_Data, BaseSkillData)

--- @return void
--- @param id number id of skill (1: activeSkill, 2-4: passiveSkills)
--- @param hero BaseHero
function Summoner1_Skill3_2_Data:Ctor(id, hero)
    BaseSkill.Ctor(self, id, hero)

    --- @param List<number>
    self.roundTriggerList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner1_Skill3_2_Data:CreateInstance()
    return Summoner1_Skill3_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.buff_target_position ~= nil, "buff_target_position = nil")
    assert(parsedData.buff_target_number ~= nil, "buff_target_number = nil")

    assert(parsedData.buff_duration ~= nil, "buff_duration = nil")
    assert(parsedData.buff_chance ~= nil, "buff_chance = nil")

    assert(parsedData.stat_buff_1_type ~= nil, "stat_buff_1_type = nil")
    assert(parsedData.stat_buff_1_calculation ~= nil, "stat_buff_1_calculation = nil")
    assert(parsedData.stat_buff_1_amount ~= nil, "stat_buff_1_amount = nil")

    assert(parsedData.stat_buff_2_type ~= nil, "stat_buff_2_type = nil")
    assert(parsedData.stat_buff_2_calculation ~= nil, "stat_buff_2_calculation = nil")
    assert(parsedData.stat_buff_2_amount ~= nil, "stat_buff_2_amount = nil")

    assert(parsedData.round_trigger_list ~= nil, "round_trigger_list = nil")
end

--- @return void
--- @param parsedData table
function Summoner1_Skill3_2_Data:ParseCsv(parsedData)
    self.targetPosition = tonumber(parsedData.buff_target_position)
    self.targetNumber = tonumber(parsedData.buff_target_number)

    self.buffDuration = tonumber(parsedData.buff_duration)
    self.buffChance = tonumber(parsedData.buff_chance)

    self.statBuffType_1 = tonumber(parsedData.stat_buff_1_type)
    self.statBuffCalculation_1 = tonumber(parsedData.stat_buff_1_calculation)
    self.statBuffAmount_1 = tonumber(parsedData.stat_buff_1_amount)

    self.statBuffType_2 = tonumber(parsedData.stat_buff_2_type)
    self.statBuffCalculation_2 = tonumber(parsedData.stat_buff_2_calculation)
    self.statBuffAmount_2 = tonumber(parsedData.stat_buff_2_amount)

    local content = StringUtils.Trim(parsedData.round_trigger_list)
    content = content:Split(';')

    for _, value in pairs(content) do
        self.roundTriggerList:Add(tonumber(value))
    end
end

return Summoner1_Skill3_2_Data