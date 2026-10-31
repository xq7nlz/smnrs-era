--- @class Summoner2_Skill4_2_Data Warrior
Summoner2_Skill4_2_Data = Class(Summoner2_Skill4_2_Data, BaseSkillData)

--- @return void
function Summoner2_Skill4_2_Data:Ctor()
    BaseSkillData.Ctor(self)

    --- @param List<number>
    self.roundTriggerList = List()
end

---------------------------------------- Initialization ----------------------------------------
--- @return BaseSkillData
function Summoner2_Skill4_2_Data:CreateInstance()
    return Summoner2_Skill4_2_Data()
end

--- @return void
--- @param parsedData table
function Summoner2_Skill4_2_Data:ValidateBeforeParseCsv(parsedData)
    assert(parsedData.tanker_target_position ~= nil, "tanker_target_position = nil")
    assert(parsedData.tanker_target_number ~= nil, "tanker_target_number = nil")

    assert(parsedData.other_target_position ~= nil, "other_target_position = nil")
    assert(parsedData.other_target_number ~= nil, "other_target_number = nil")

    assert(parsedData.bond_duration ~= nil, "bond_duration = nil")

    assert(parsedData.damage_share_percent ~= nil, "damage_share_percent = nil")
    assert(parsedData.round_trigger_list ~= nil, "round_trigger_list = nil")
end

--- @return void
--- @param parsedData table
function Summoner2_Skill4_2_Data:ParseCsv(parsedData)
    self.tankerTargetPosition = tonumber(parsedData.tanker_target_position)
    self.tankerTargetNumber = tonumber(parsedData.tanker_target_number)

    self.otherTargetPosition = tonumber(parsedData.other_target_position)
    self.otherTargetNumber = tonumber(parsedData.other_target_number)

    self.bondDuration = tonumber(parsedData.bond_duration)

    self.damageSharePercent = tonumber(parsedData.damage_share_percent)

    local content = StringUtils.Trim(parsedData.round_trigger_list)
    content = content:Split(';')

    for _, value in pairs(content) do
        self.roundTriggerList:Add(tonumber(value))
    end
end

return Summoner2_Skill4_2_Data