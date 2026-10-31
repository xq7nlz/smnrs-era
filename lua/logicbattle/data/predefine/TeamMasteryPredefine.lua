--- @class TeamMasteryPredefine
TeamMasteryPredefine = Class(TeamMasteryPredefine)

--- @return void
--- @param id number
function TeamMasteryPredefine:Ctor(id)
    --- @type number
    self.teamMasteryId = id

    --- @type Dictionary<number, List<number>> key: heroClass, value: list of mastery levels
    self.masteryLevels = Dictionary()
end

--- @return void
--- @param data string
function TeamMasteryPredefine:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    local heroClass = tonumber(data.hero_class)
    assert(MathUtils.IsInteger(heroClass))

    for i = 1, SkillConstants.SUMMONER_NUMBER_MASTERY do
        local levels = self.masteryLevels:Get(heroClass)
        if levels == nil then
            levels = List()
            self.masteryLevels:Add(heroClass, levels)
        end

        local masteryLevel = tonumber(data[PredefineConstants.PREDEFINE_MASTERY_SLOT .. i])
        assert(MathUtils.IsInteger(masteryLevel))

        levels:Add(masteryLevel)
    end
end

--- @return void
function TeamMasteryPredefine:ValidateBeforeParseCsv(data)
    if data.hero_class == nil then
        assert(false)
    end
end