local SKILL_PASSIVE_CONFIG_PATH = "csv/hero/passive_skill_names.csv"

--- @class HeroSkillPassiveConfig
HeroSkillPassiveConfig = Class(HeroSkillPassiveConfig)

function HeroSkillPassiveConfig:Ctor()
    self.heroDict = nil
    self:Init()
end

function HeroSkillPassiveConfig:Init()
    self.heroDict = Dictionary()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(SKILL_PASSIVE_CONFIG_PATH)
    for i = 1, #parsedData do
        local data = parsedData[i]['hero_id']:Split('_')
        local heroId = tonumber(data[1])
        local skillId = tonumber(data[2])
        ---@type List
        local skillList = self.heroDict:Get(heroId)
        if skillList == nil then
            skillList = List()
            self.heroDict:Add(heroId, skillList)
        end
        skillList:Add(skillId)
    end
end

--- @return List --<number>
function HeroSkillPassiveConfig:Get(heroId)
    return self.heroDict:Get(heroId)
end

return HeroSkillPassiveConfig