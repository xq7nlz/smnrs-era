--- @class SummonerSkillDataCollection
SummonerSkillDataCollection = Class(SummonerSkillDataCollection, HeroSkillDataCollection)

--- @return void
--- @param csv string
function SummonerSkillDataCollection:ParseCsv(csv)
    local parsedData = CsvReader.ReadContent(csv)
    for i = 1, #parsedData do
        local data = parsedData[i]

        local star = tonumber(data.star)
        local skillData = self:CreateSkillData(data, star)

        self.skillLevels:Add(star, skillData)
    end
end

--- @return BaseSkillData
--- @param data table
--- @param level number
function SummonerSkillDataCollection:CreateSkillData(data, level)
    local tier = SummonerUtils.GetSkillTier(level)

    local skillDataLuaFile
    if self.heroId ~= HeroConstants.SUMMONER_NOVICE_ID then
        skillDataLuaFile = require(string.format(LuaPathConstants.SUMMONER_SKILL_DATA_PATH,
                self.heroId, self.heroId, self.skillId, tier))
    else
        skillDataLuaFile = require(string.format(LuaPathConstants.SUMMONER_NOVICE_SKILL_DATA_PATH, self.skillId))
    end

    ---@type BaseSkillData
    local skillData = skillDataLuaFile:CreateInstance()
    skillData:ValidateBeforeParseCsv(data)
    skillData:SetName(data.name)
    skillData:ParseCsv(data)

    return skillData
end