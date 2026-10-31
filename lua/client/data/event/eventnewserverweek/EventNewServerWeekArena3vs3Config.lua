require "lua.client.data.Arena.ArenaRewardRankingConfig"
local ARENA_REWARD_CONFIG_PATH = "arena_top_reward.csv"
--- @class EventNewServerWeekArena3vs3Config
EventNewServerWeekArena3vs3Config = Class(EventNewServerWeekArena3vs3Config)

function EventNewServerWeekArena3vs3Config:Ctor(path)
    ---@type List
    self.arenaConfigList = nil
    ---@type string
    self.path = path
end

function EventNewServerWeekArena3vs3Config:GetListRewardByRank(rank)
    self:GetArenaConfigList()
    for i = self.arenaConfigList:Count(), 1, -1 do
        ---@type ArenaRewardRankingConfig
        local arenaRewardRankingConfig = self.arenaConfigList:Get(i)
        if (rank >= arenaRewardRankingConfig.topMin) then
            return arenaRewardRankingConfig.listRewardItem
        end
    end

end

--- @return List
function EventNewServerWeekArena3vs3Config:GetArenaConfigList()
    if self.arenaConfigList == nil then
        self.arenaConfigList = List()
        local path = string.format("%s/%s", self.path, ARENA_REWARD_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        local topMin = nil
        local topMax = nil
        local listResourceItems = List()
        ---@type ArenaRewardRankingConfig
        local arenaRewardRankingConfig
        for i = 1, #parsedData do
            local lineData = parsedData[i]
            if lineData["top_min"] ~= nil then
                ---@type ArenaRewardRankingConfig
                arenaRewardRankingConfig = ArenaRewardRankingConfig()
                self.arenaConfigList:Add(arenaRewardRankingConfig)
                arenaRewardRankingConfig.topMin  = tonumber(lineData["top_min"])
                arenaRewardRankingConfig.topMax  = tonumber(lineData["top_max"])
                arenaRewardRankingConfig.listRewardItem = List()
            else

            end
            ---@type ItemIconData
            local itemIconData = ItemIconData.CreateInstance(tonumber(lineData["res_type"]), tonumber(lineData["res_id"]), tonumber(lineData["res_number"]))
            arenaRewardRankingConfig.listRewardItem:Add(itemIconData)
        end
    end
    return self.arenaConfigList
end

