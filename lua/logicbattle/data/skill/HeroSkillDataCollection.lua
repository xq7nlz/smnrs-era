--- @class HeroSkillDataCollection
HeroSkillDataCollection = Class(HeroSkillDataCollection)

--- @return void
--- @param heroId number
--- @param skillId number
function HeroSkillDataCollection:Ctor(heroId, skillId)
    --- key: level, value: skill data
    --- @type Dictionary<number, table>
    self.skillLevels = Dictionary()

    --- @type number
    self.heroId = heroId

    --- @type number
    self.skillId = skillId
end

--- @return void
--- @param csv string
function HeroSkillDataCollection:ParseCsv(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local skillData = self:CreateSkillData(parsedData[i], i)
        self.skillLevels:Add(i, skillData)
    end
end

--- @return BaseSkillData
--- @param data table
--- @param level number
function HeroSkillDataCollection:CreateSkillData(data, level)
    local skillDataLuaFile = require(string.format(LuaPathConstants.HERO_SKILL_DATA_PATH,
            self.heroId, self.heroId, self.skillId))

    ---@type BaseSkillData
    local skillData = skillDataLuaFile:CreateInstance()
    skillData:ValidateBeforeParseCsv(data)
    skillData:SetName(data.name)
    skillData:ParseCsv(data)

    return skillData
end