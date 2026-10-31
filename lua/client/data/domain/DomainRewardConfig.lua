local INSTANT_REWARD = "csv/domains/instant_reward.csv"
local CHEST_REWARD_RATE = "csv/domains/chest_reward_rate.csv"
local EXTEND_REWARD = "csv/client/domains/domain_extend_reward.csv"

--- @class DomainRewardConfig
DomainRewardConfig = Class(DomainRewardConfig)

function DomainRewardConfig:Ctor()
    --- @type Dictionary
    self.dayRewardDict = Dictionary()
    --- @type Dictionary
    self.chestRewardPoolDict = nil
    --- @type List
    self.listExtendReward = List()

    self:InitData()
end

function DomainRewardConfig:InitData()
    local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(INSTANT_REWARD)

    --- @type DomainRewardDayConfig
    local domainRewardDayConfig
    for i = 1, #parsedCsv do
        local data = parsedCsv[i]
        local day = tonumber(data.day)
        if day ~= nil then
            domainRewardDayConfig = DomainRewardDayConfig()
            self.dayRewardDict:Add(day, domainRewardDayConfig)
        end
        domainRewardDayConfig:ParsedData(data)
    end
end

--- @return List
function DomainRewardConfig:GetDomainRewardByDayStage(day, stage)
    --- @type DomainRewardDayConfig
    local domainRewardDayConfig = self:GetDomainRewardDayConfig(day)
    if domainRewardDayConfig ~= nil then
        return domainRewardDayConfig:GetRewardByStage(stage)
    end
end

--- @return DomainRewardDayConfig
function DomainRewardConfig:GetDomainRewardDayConfig(day)
    return self.dayRewardDict:Get(day)
end

--- @return List
--- @param chestId MoneyType
function DomainRewardConfig:GetChestRewardPool(chestId)
    return self:GetChestRewardPoolDict():Get(chestId)
end

--- @type Dictionary
function DomainRewardConfig:GetChestRewardPoolDict()
    if self.chestRewardPoolDict == nil then
        self.chestRewardPoolDict = Dictionary()

        local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(CHEST_REWARD_RATE)
        --- @type List
        local listRewardPool
        for i = 1, #parsedCsv do
            local chestId = tonumber(parsedCsv[i].chest_id)
            if chestId ~= nil then
                listRewardPool = List()
                self.chestRewardPoolDict:Add(chestId, listRewardPool)
            end
            local rewardInBound = RewardInBound.CreateByParams(parsedCsv[i])
            local duplicated = false
            for i = 1, listRewardPool:Count() do
                --- @type RewardInBound
                local reward = listRewardPool:Get(i)
                if reward.type == rewardInBound.type and reward.id == rewardInBound.id then
                    duplicated = true
                    break
                end
            end
            if duplicated == false then
                listRewardPool:Add(rewardInBound)
            end
        end
    end
    return self.chestRewardPoolDict
end

--- @return List
--- @param chestId MoneyType
function DomainRewardConfig:GetChestRewardPool(chestId)
    return self:GetChestRewardPoolDict():Get(chestId)
end

--- @type List
function DomainRewardConfig:GetExtendReward()
    self.listExtendReward:Clear()
    local parsedCsv = CsvReaderUtils.ReadAndParseLocalFile(EXTEND_REWARD)
    if parsedCsv == nil then
        return nil
    end
    for i = 1, #parsedCsv do
        self.listExtendReward:Add(RewardInBound.CreateByParams(parsedCsv[i]))
    end
    return self.listExtendReward
end

--- @class DomainRewardDayConfig
DomainRewardDayConfig = Class(DomainRewardDayConfig)

function DomainRewardDayConfig:Ctor()
    --- @type number
    self.currentStage = nil
    --- @type Dictionary
    self.stageRewardDict = Dictionary()
end

function DomainRewardDayConfig:ParsedData(data)
    local stage = tonumber(data.stage)
    if stage ~= nil then
        self.currentStage = stage
        local listReward = List()
        self.stageRewardDict:Add(stage, listReward)
    end

    --- @type List
    local listReward = self.stageRewardDict:Get(self.currentStage)
    listReward:Add(RewardInBound.CreateByParams(data))
end

function DomainRewardDayConfig:StageCount()
    return self.stageRewardDict:Count()
end

--- @return List
function DomainRewardDayConfig:GetRewardByStage(stage)
    return self.stageRewardDict:Get(stage)
end

--- @return List
function DomainRewardDayConfig:GetTotalRewardAllStage()
    local listTotal = List()
    --- @param v List
    for k, v in pairs(self.stageRewardDict:GetItems()) do
        listTotal:AddAll(v)
    end
    return listTotal
end