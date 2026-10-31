require("lua.client.data.Event.EventNewHero.Spin.EventNewHeroSpinCost")
require("lua.client.data.Event.EventNewHero.Spin.EventNewHeroSpinReward")

local SPIN_CONFIG_PATH = "spin_config.csv"
local SPIN_COST_PATH = "spin_cost.csv"
local ROSE_COST_PATH = "rose_buy_cost.csv"

--- @class EventNewHeroSpinConfig
EventNewHeroSpinConfig = Class(EventNewHeroSpinConfig)

function EventNewHeroSpinConfig:Ctor(path)
    self.path = path
    --- @type Dictionary
    self.dictReward = nil
    --- @type Dictionary
    self.dictCost = nil
    --- @type DefenderTeamData
    self.attacker = nil
    --- @type DefenderTeamData
    self.defender = nil
end

--- @return Dictionary
function EventNewHeroSpinConfig:GetRewardConfig()
    if self.dictReward == nil then
        local path = string.format("%s/%s", self.path, SPIN_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end
        self.listReward = List()
        self.dictReward = Dictionary()
        for i = 1, #parsedData do
            local reward = EventNewHeroSpinReward(parsedData[i])
            self.dictReward:Add(reward.id, reward)
            self.listReward:Add(reward)
        end
    end
    return self.dictReward, self.listReward
end

--- @return Dictionary
function EventNewHeroSpinConfig:GetCostConfig()
    if self.dictCost == nil then
        local path = string.format("%s/%s", self.path, SPIN_COST_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end

        self.dictCost = Dictionary()
        for i = 1, #parsedData do
            local reward = EventNewHeroSpinCost(parsedData[i])
            self.dictCost:Add(reward.id, reward)
        end
    end

    return self.dictCost
end

--- @return Dictionary
function EventNewHeroSpinConfig:GetRoseCost()
    if self.roseCost == nil then
        local path = string.format("%s/%s", self.path, ROSE_COST_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        if parsedData == nil then
            XDebug.Error(string.format("Get EventConfig nil %s", path))
            return
        end

        self.roseCost = tonumber(parsedData[1].gem_price)
    end

    return self.roseCost
end

--- @return Dictionary
function EventNewHeroSpinConfig:RedCsvSkinPreview()
    local path = string.format("%s/skin_preview.csv", self.path)
    local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
    if parsedData == nil then
        XDebug.Error(string.format("Get EventConfig nil %s", path))
        return
    end
    self.attacker = DefenderTeamData(parsedData[1])
    self.defender = DefenderTeamData(parsedData[2])
end

--- @return DefenderTeamData
function EventNewHeroSpinConfig:GetAttackerTeam()
    if self.attacker == nil then
        self:RedCsvSkinPreview()
    end
    return self.attacker
end

--- @return DefenderTeamData
function EventNewHeroSpinConfig:GetDefenderTeam()
    if self.defender == nil then
        self:RedCsvSkinPreview()
    end
    return self.defender
end