require "lua.client.data.DefenderTeamData"

--- @class LunarBossConfig
LunarBossConfig = Class(LunarBossConfig)

--- @return void
function LunarBossConfig:Ctor()
    self.chapter = nil
    self.pointRequire = nil
    ---@type DefenderTeamData
    self.defenderTeam = nil
    ---@type List --<RewardInBound>
    self.listReward = List()
end

--- @return void
function LunarBossConfig:ParsedData(data)
    self.chapter = tonumber(data.chap_id)
    self.pointRequire = tonumber(data.point_required)
    ---@type DefenderTeamData
    self.defenderTeam = DefenderTeamData(data)
    self:AddData(data)
end

--- @return void
function LunarBossConfig:AddData(data)
    if data.res_type ~= nil then
        self.listReward:Add(RewardInBound.CreateByParams(data))
    end
end

--- @return List
function LunarBossConfig.GetListLunarBossConfig(path)
    local list = List()
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    ---@type LunarBossConfig
    local item = nil
    for i = 1, #parsedData do
        local data = parsedData[i]
        if data.chap_id ~= nil then
            item = LunarBossConfig()
            item:ParsedData(data)
            list:Add(item)
        else
            item:AddData(data)
        end
    end
    return list
end