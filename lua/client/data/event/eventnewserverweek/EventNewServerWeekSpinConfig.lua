--require "lua.client.data.Event.ExchangeEventConfig"
local SPIN_COOLDOWN_CONFIG_PATH = "spin_cool_down.csv"
local SPIN_REWARD_CONFIG_PATH = "spin_reward.csv"
--- @class EventNewServerWeekSpinConfig
EventNewServerWeekSpinConfig = Class(EventNewServerWeekSpinConfig)

function EventNewServerWeekSpinConfig:Ctor(path)
    ---@type string
    self.path = path
    ---@type Dictionary
    self.dictSpinCooldown = nil
    ---@type Dictionary
    self.dictRewardPosition = nil
    ---@type number
    self.numberOfSquares = nil
end

---@return Dictionary
function EventNewServerWeekSpinConfig:GetDictSpinCooldownTime()
    if (self.dictSpinCooldown == nil) then
        self.dictSpinCooldown = Dictionary()
        local path = string.format("%s/%s", self.path, SPIN_COOLDOWN_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local lineData = parsedData[i]
            local spinNumber = tonumber(lineData["spin_number"])
            if spinNumber ~= nil then
                self.dictSpinCooldown:Add(spinNumber,tonumber(lineData["cool_down_time"]))
            end
        end
    end
    return self.dictSpinCooldown

end

---@return Dictionary
function EventNewServerWeekSpinConfig:GetDictRewardPositionConfig()
    if self.dictRewardPosition == nil then
        self.dictRewardPosition = Dictionary()
        local path = string.format("%s/%s", self.path, SPIN_REWARD_CONFIG_PATH)
        local parsedData = CsvReaderUtils.ReadAndParseLocalFile(path)
        for i = 1, #parsedData do
            local lineData = parsedData[i]
            local position = tonumber(lineData["position"])
            if position ~= nil then
                ---@type RewardInBound
                local rewardInBound = RewardInBound.CreateByParams(lineData)
                self.dictRewardPosition:Add(position,rewardInBound)
            end
        end
        self.numberOfSquares = self.dictRewardPosition:Count()
    end
    return self.dictRewardPosition
end