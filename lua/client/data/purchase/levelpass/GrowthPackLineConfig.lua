require "lua.client.data.Purchase.LevelPass.GrowthMilestoneConfig"

--- @class GrowthPackLineConfig
GrowthPackLineConfig = Class(GrowthPackLineConfig)

--- @param line number
function GrowthPackLineConfig:Ctor(line, basicPathFormat, premiumPathFormat, fixKeyNumber)
    self.line = line
    self.milestoneDict = Dictionary()
    self.listMilestone = List()
    self:_InitConfig(basicPathFormat, premiumPathFormat, fixKeyNumber)

    --- @type List
    self.listTotalPremiumReward = nil
end

function GrowthPackLineConfig:_InitConfig(basicPathFormat, premiumPathFormat, fixKeyNumber)
    local basicConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(basicPathFormat, self.line))
    self:_ReadReward(basicConfig, true, fixKeyNumber)

    if premiumPathFormat ~= nil then
        local premiumConfig = CsvReaderUtils.ReadAndParseLocalFile(string.format(premiumPathFormat, self.line))
        self:_ReadReward(premiumConfig, false, fixKeyNumber)
    end
    self:_ConvertListMilestone()
end

--- @param data {}
function GrowthPackLineConfig:_ReadReward(data, isBasic, fixKeyNumber)
    local currentNumber
    for i = 1, #data do
        local dataLine = data[i]
        local number = tonumber(dataLine[fixKeyNumber])
        if MathUtils.IsNumber(number) then
            currentNumber = number
        end
        --- @type GrowthMilestoneConfig
        local milestoneConfig = self.milestoneDict:Get(currentNumber)
        if milestoneConfig == nil then
            milestoneConfig = GrowthMilestoneConfig(currentNumber)
            self.milestoneDict:Add(currentNumber, milestoneConfig)
        end
        if isBasic then
            milestoneConfig:ParseBasicReward(dataLine)
        else
            milestoneConfig:ParsePremiumReward(dataLine)
        end
    end
end

--- @return GrowthMilestoneConfig
--- @param level number
function GrowthPackLineConfig:GetMilestoneConfigByLevel(level)
    return self.milestoneDict:Get(level)
end

--- @return GrowthMilestoneConfig
--- @param index number
function GrowthPackLineConfig:GetMilestoneConfigByIndex(index)
    return self.listMilestone:Get(index)
end

--- @return number
function GrowthPackLineConfig:GetMilestoneConfigCount()
    return self.listMilestone:Count()
end

--- @return RewardInBound
function GrowthPackLineConfig:GetAllPremiumMilestone()
    --- @type RewardInBound
    local reward
    if self.listMilestone:Count() > 0 then
        reward = RewardInBound.Clone(self.listMilestone:Get(1).listPremiumReward:Get(1))
        reward.number = 0
    end
    --- @param v GrowthMilestoneConfig
    for _, v in ipairs(self.listMilestone:GetItems()) do
        --- @type RewardInBound
        local firstPremiumReward = v.listPremiumReward:Get(1)
        reward.number = reward.number + firstPremiumReward.number
    end
    return reward
end

function GrowthPackLineConfig:_ConvertListMilestone()
    --- @param v GrowthMilestoneConfig
    for _, v in pairs(self.milestoneDict:GetItems()) do
        self.listMilestone:Add(v)
    end
    self.listMilestone:SortWithMethod(GrowthPackLineConfig.SortByNumber)
end

--- @return number
---@param x GrowthMilestoneConfig
---@param y GrowthMilestoneConfig
function GrowthPackLineConfig.SortByNumber(x, y)
    if x.number < y.number then
        return -1
    else
        return 1
    end
end

--- @return number, number
--- @param growPatchLine GrowPatchLine
function GrowthPackLineConfig:GetClaimableMilestone(currentNumber, isUnlockPremium, growPatchLine)
    for i = 1, self.listMilestone:Count() do
        --- @type GrowthMilestoneConfig
        local growthMilestoneConfig = self.listMilestone:Get(i)
        if currentNumber >= growthMilestoneConfig.number then
            local claimedBasic = 0
            local claimPremium = 0
            if growPatchLine ~= nil then
                claimedBasic, claimPremium = growPatchLine:GetMilestoneState(growthMilestoneConfig.number)
            end
            if claimedBasic == 0 or (claimPremium == 0 and isUnlockPremium) then
                return growthMilestoneConfig.number, i
            end
        end
    end
    return nil, nil
end

function GrowthPackLineConfig:GetTotalClaimedReward()
    local totalClaim = 0
    local iapDataInBound = zg.playerData:GetIAP()
    if iapDataInBound == nil then
        return totalClaim
    end
    --- @type GrowthPackCollection
    local growthPackCollection = iapDataInBound.growthPackData
    --- @type GrowPatchLine
    local growPatchLine = growthPackCollection:GetGrowPatchLine(self.line)
    if growPatchLine ~= nil then
        totalClaim = growPatchLine:GetTotalClaim()
    end
    return totalClaim
end

function GrowthPackLineConfig:IsClaimCompleted()
    local totalClaim = self:GetTotalClaimedReward()
    local sum = 0
    for i, v in pairs(self.milestoneDict:GetItems()) do
        ---@type GrowthMilestoneConfig
        local value = v
        sum = sum + value:GetRewardCount()
    end
    return totalClaim == sum
end

--- @return List
--- @param vipRewardInBound RewardInBound
function GrowthPackLineConfig:GetTotalClaimAblePremiumReward(vipRewardInBound)
    if self.listTotalPremiumReward == nil then
        --- @type List
        self.listTotalPremiumReward = List()
        --- @param rewardInBound RewardInBound
        local addMoreRewardToList = function(rewardInBound)
            for i = 1, self.listTotalPremiumReward:Count() do
                --- @type RewardInBound
                local reward = self.listTotalPremiumReward:Get(i)
                if reward.type == rewardInBound.type
                        and reward.id == rewardInBound.id then
                    reward.number = reward.number + rewardInBound.number
                    return
                end
            end
            self.listTotalPremiumReward:Add(rewardInBound)
        end
        --- @param v GrowthMilestoneConfig
        for k, v in pairs(self.milestoneDict:GetItems()) do
            local listPremiumReward = v.listPremiumReward
            for i = 1, listPremiumReward:Count() do
                --- @type RewardInBound
                local reward = listPremiumReward:Get(i)
                addMoreRewardToList(reward:Clone())
            end
        end
        self.listTotalPremiumReward:Add(vipRewardInBound)
    end
    return self.listTotalPremiumReward
end