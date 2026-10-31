--- @class SummonerCsvDetail
SummonerCsvDetail = Class(SummonerCsvDetail)

function SummonerCsvDetail:Ctor()
    --- @type number
    self.id = nil
    --- @type string
    self.statConfigPath = nil
    --- @type Dictionary --<number, List<string>>
    self.skillIdDict = nil
    --- @type List --<string>
    self.masteryList = nil
end

--- @return void
--- @param data table
function SummonerCsvDetail:ParseData(data)
    self.id = data.summonerId
    self.statConfigPath = data.statConfigPath
    self.skillIdDict = self:ParseSkill(data.skillPathDictionary)
    self.masteryList = self:ParseMastery(data.masteryConfigs)
end

--- @return Dictionary
--- @param data table
function SummonerCsvDetail:ParseSkill(data)
    local skillIdDict = Dictionary()
    for rawSkillId, skillData in pairs(data) do
        local skillId = tonumber(rawSkillId)
        local skillTierList = List()
        for _, pathByTier in ipairs(skillData) do
            skillTierList:Add(pathByTier)
        end
        skillIdDict:Add(skillId, skillTierList)
    end
    return skillIdDict
end

--- @return List
function SummonerCsvDetail:ParseMastery(data)
    local masteryList = List()
    for _, pathById in ipairs(data) do
        masteryList:Add(pathById)
    end
    return masteryList
end

--- @return List
--- @param id number
function SummonerCsvDetail:GetSkillId(id)
    local data = self.skillIdDict:Get(id)
    if data == nil then
        XDebug.Error(string.format("skillId is nil: %s", LogUtils.ToDetail(id)))
    end
    return data
end

--- @return string
function SummonerCsvDetail:GetMastery(id)
    local data = self.masteryList:Get(id)
    if data == nil then
        XDebug.Error(string.format("mastery is nil: %s", LogUtils.ToDetail(id)))
    end
    return data
end
