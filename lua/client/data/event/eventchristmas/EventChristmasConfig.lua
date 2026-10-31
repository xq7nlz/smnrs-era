local DAILY_QUEST_PATH = "feed_hero/daily_quest.csv"
local DEFENDER_TEAM = "bet_arena/defender_team.csv"
local ATTACKER_TEAM = "bet_arena/attacker_team.csv"
local BATTLE_RESULT = "bet_arena/bet_arena_result.csv"

--- @class EventChristmasConfig
EventChristmasConfig = Class(EventChristmasConfig)

function EventChristmasConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil
    --- @type EventFeedHeroConfig
    self._feedBeastConfig = nil
    --- @type List
    self._listExchange = nil
    --- @type {listGoldenTimeReward : List, lastDuration: number}
    self._goldenTimeConfig = nil
    --- @type Dictionary
    self.dictLineUpDefenderRecommend = Dictionary()
    --- @type Dictionary
    self.dictLineUpAttackerRecommend = Dictionary()
    self:_InitMidAutumnDefenderTeamConfig()
    self:_InitMidAutumnAttackerTeamConfig()
end

--- @return Dictionary
function EventChristmasConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path, "login_reward.csv")
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
        self.loginRewardDict = Dictionary()
        for i = 1, #parsedData do
            local day = parsedData[i].day
            if day == nil then
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                day = tonumber(parsedData[i].day)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                self.loginRewardDict:Add(day, listReward)
            end
        end
    end
    return self.loginRewardDict
end

--- @retun Dictionary
function EventChristmasConfig:GetBetArenaResult()
    local path = string.format("%s/%s", self.path, BATTLE_RESULT)
    local parserData = CsvReaderUtils.ReadAndParseLocalFile(path)
    local dictResult = Dictionary()

    ---@type List
    for i = 1, #parserData do
        local data = parserData[i]
        local day = tonumber(data["day"])
        local winTeam = tonumber(data["win_team"])
        dictResult:Add(day, winTeam)
    end

    return dictResult
end

function EventChristmasConfig:_InitMidAutumnDefenderTeamConfig()
    local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    require "lua.client.data.Event.EventChristmas.EventChristmasTeamConfig"
    self.defenderTeamConfig = EventChristmasTeamConfig()
    self.defenderTeamConfig:ParseCsv(levelDesignContent)
end

function EventChristmasConfig:_InitMidAutumnAttackerTeamConfig()
    local path = string.format("%s/%s", self.path, ATTACKER_TEAM)
    local levelDesignContent = CsvReaderUtils.ReadAndParseLocalFile(path)
    require "lua.client.data.Event.EventChristmas.EventChristmasTeamConfig"
    self.attackerTeamConfig = EventChristmasTeamConfig()
    self.attackerTeamConfig:ParseCsv(levelDesignContent)
end

--- @return BattleTeamInfo
function EventChristmasConfig:GetListLineupDefenderRecommendation(id)
    if self.dictLineUpDefenderRecommend:Count() == 0 then
        local path = string.format("%s/%s", self.path, DEFENDER_TEAM)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.stage ~= nil then
                local predefineTeam = PredefineTeamData.CreateByCsv(data)
                ---@type BattleTeamInfo
                local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam)
                if lineupTeam ~= nil then
                    self.dictLineUpDefenderRecommend:Add(tonumber(data.stage), lineupTeam)
                end
            end
        end
    end
    return self.dictLineUpDefenderRecommend:Get(id)
end

--- @return BattleTeamInfo
function EventChristmasConfig:GetListLineupAttackerRecommendation(id)
    if self.dictLineUpAttackerRecommend:Count() == 0 then
        local path = string.format("%s/%s", self.path, ATTACKER_TEAM)
        local dataParse = CsvReaderUtils.ReadAndParseLocalFile(path)
        for _, data in pairs(dataParse) do
            if data.stage ~= nil then
                local predefineTeam = PredefineTeamData.CreateByCsv(data)
                ---@type BattleTeamInfo
                local lineupTeam = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfo(predefineTeam,BattleConstants.DEFENDER_TEAM_ID)
                if lineupTeam ~= nil then
                    self.dictLineUpAttackerRecommend:Add(tonumber(data.stage), lineupTeam)
                end
            end
        end
    end
    return self.dictLineUpAttackerRecommend:Get(id)
end

--- @return GoldenTimeConfig
function EventChristmasConfig:GetGoldenTimeConfig()
    if self._goldenTimeConfig == nil then
        local path = string.format("%s/golden_time/%s", self.path, "golden_time.csv")
        require "lua.client.data.Event.GoldenTimeConfig"
        self._goldenTimeConfig = GoldenTimeConfig(path)
    end
    return self._goldenTimeConfig
end

--- @return EventFeedHeroConfig
function EventChristmasConfig:GetEventFeedBeastConfig()
    if self._feedBeastConfig == nil then
        require "lua.client.data.Event.EventChristmas.EventFeedHeroConfig"
        self._feedBeastConfig = EventFeedHeroConfig(self.path)
    end
    return self._feedBeastConfig
end

--- @return List
function EventChristmasConfig:_GetListExchangeConfigPath(key, csv)
    ---@type List
    local list = self[key]
    if list == nil then
        local path = string.format("%s/%s", self.path, csv)
        require "lua.client.data.Event.ExchangeEventConfig"
        list = ExchangeEventConfig.GetListExchangeConfigPath(path)
        self[key] = list
    end
    return list
end

--- @return List
function EventChristmasConfig:GetListExchangeConfig()
    return self:_GetListExchangeConfigPath("listExchange", "exchange_reward.csv")
end

--- @return List
function EventChristmasConfig:GetListGemBoxConfig()
    return self:_GetListExchangeConfigPath("listGemBox", "gem_box.csv")
end

--- @return Dictionary
function EventChristmasConfig:GetDailyQuestConfig()
    local path = string.format("%s/%s", self.path, DAILY_QUEST_PATH)
    local dailyQuestDict = QuestElementConfig.ReadQuestConfigFromPath(path)
    return dailyQuestDict
end
