require "lua.client.data.Event.EventXmas.EventXmasLoginDataConfig"
require "lua.client.data.Event.EventHalloween.EventHalloweenLapDataConfig"
require "lua.client.data.Event.BossChallengeRewardMilestoneData"

local LOGIN_PATH = "login_reward.csv"

--- @class EventXmasConfig
EventXmasConfig = Class(EventXmasConfig)

function EventXmasConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.loginRewardDict = nil

    --- @type Dictionary
    self.diceRewardInboundDict = nil
    --- @type Dictionary
    self.lapRewardInboundDict = nil
    --- @type List
    self.requireList = nil
end

--- @return Dictionary
function EventXmasConfig:GetLoginConfig()
    local path = string.format("%s/%s", self.path, LOGIN_PATH)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    if self.loginRewardDict == nil then
        local listReward = nil
        -- Dictionary(page, Dictionary(day, List<RewardInBound>)
        self.pageDict = Dictionary()
        self.loginRewardDict = Dictionary()
        local isReclaim = parsedData[1].is_reclaim
        if isReclaim ~= nil then
            self.isReclaim = MathUtils.ToBoolean(isReclaim)
        end
        local page = 1
        local loginDataConfig = nil
        for i = 1, #parsedData do
            local day = parsedData[i].day
            if day == nil then
                loginDataConfig.rewardList:Add(RewardInBound.CreateByParams(parsedData[i]))
            else
                day = tonumber(parsedData[i].day)
                listReward = List()
                listReward:Add(RewardInBound.CreateByParams(parsedData[i]))
                local rewardInBound = RewardInBound.CreateBySingleParam(ResourceType.Money, parsedData[i].money_type, parsedData[i].money_value)
                loginDataConfig = EventXmasLoginDataConfig(listReward, rewardInBound)
                self.loginRewardDict:Add(day, loginDataConfig)
                if day % 7 == 0 then
                    self.pageDict:Add(page, self.loginRewardDict)
                    page = page + 1
                    self.loginRewardDict = Dictionary()
                end
            end
        end
    end
    return self.pageDict
end

--- @return Dictionary
function EventXmasConfig:IsNewLogin()
    if self.isReclaim == nil then
        return false
    end
    return self.isReclaim
end
--- @return List
function EventXmasConfig:GetListExchangeConfig()
    if self.listExchange == nil then
        local path = string.format("%s/%s", self.path, "exchange_reward.csv")
        require "lua.client.data.Event.ExchangeEventConfig"
        self.listExchange = ExchangeEventConfig.GetListExchangeConfigPath(path)
    end
    return self.listExchange
end

--- @return List
function EventXmasConfig:GetListRewardBox()
    if self.listRewardBox == nil then
        local path = self.path .. "/christmas_box/christmas_box_rate.csv"
        self.listRewardBox = List()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get RewardBox nil %s", path))
            return
        end
        local listItem = List()
        for i = 1, #parsedData do
            ---@type RewardInBound
            local reward = RewardInBound.CreateByParams(parsedData[i])
            local key = string.format("%s_%s_%s", reward.type, reward.id, reward.number)
            if listItem:IsContainValue(key) == false then
                listItem:Add(key)
                self.listRewardBox:Add(reward)
            end
        end
    end
    return self.listRewardBox
end

--- @return List <BossChallengeRewardMilestoneData>
function EventXmasConfig:GetListIgnatiusConfig()
    if self.listIgnatiusConfig == nil then
        local path = self.path .. "/boss/reward_config.csv"
        self.listIgnatiusConfig = List()
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        ---@type BossChallengeRewardMilestoneData
        local item = nil
        for i = 1, #parsedData do
            local data = parsedData[i]
            if data.milestone_damage ~= nil then
                item = BossChallengeRewardMilestoneData()
                item:ParsedData(data)
                self.listIgnatiusConfig:Add(item)
            else
                item:AddData(data)
            end
        end
    end
    return self.listIgnatiusConfig
end

--- @return DefenderTeamData
function EventXmasConfig:GetDefenderTeamData()
    if self.defenderTeamDataIgnatius == nil then
        require "lua.client.data.DefenderTeamData"
        local path = self.path .. "/boss/defender_team.csv"
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        ---@type DefenderTeamData
        self.defenderTeamDataIgnatius = DefenderTeamData(parsedData[1])
    end
    return self.defenderTeamDataIgnatius
end