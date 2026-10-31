--- @class HeroSkillLevelData
HeroSkillLevelData = Class(HeroSkillLevelData)

--- @return void
function HeroSkillLevelData:Ctor()
    --- @type number
    self.star = -1

    --- @type List<number>
    self.skillLevels = List()
end

--- @return HeroSkillDataCollection
--- @param skillId number
function HeroSkillLevelData:GetSkillLevel(skillId)
    return self.skillLevels:Get(skillId)
end

--- @return void
--- @param data string
function HeroSkillLevelData:ParseCsv(data)
    self:ValidateBeforeParseCsv(data)

    self.star = tonumber(data.star)

    self.skillLevels:Add(tonumber(data.skill_1))
    self.skillLevels:Add(tonumber(data.skill_2))
    self.skillLevels:Add(tonumber(data.skill_3))
    self.skillLevels:Add(tonumber(data.skill_4))

    self:ValidateAfterParseCsv()
end

--- @return void
--- @param data table
function HeroSkillLevelData:ValidateBeforeParseCsv(data)
    if data.star == nil then
        assert(false)
    end

    if data.skill_1 == nil then
        assert(false)
    end

    if data.skill_2 == nil then
        assert(false)
    end

    if data.skill_3 == nil then
        assert(false)
    end

    if data.skill_4 == nil then
        assert(false)
    end
end

--- @return void
function HeroSkillLevelData:ValidateAfterParseCsv()
    assert(MathUtils.IsInteger(self.star) and self.star > 0 and self.star <= HeroConstants.MAX_STAR)

    for i = 1, self.skillLevels:Count() do
        local skillLevel = self.skillLevels:Get(i)
        if MathUtils.IsInteger(skillLevel) == false or skillLevel < 0 then
            assert(false)
        end
    end
end