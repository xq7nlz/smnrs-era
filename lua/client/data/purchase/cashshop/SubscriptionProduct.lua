--- @class SubscriptionProduct : ProductConfig
SubscriptionProduct = Class(SubscriptionProduct, ProductConfig)

--- @return void
function SubscriptionProduct:Ctor()
    ProductConfig.Ctor(self)
    self.opCode = OpCode.PURCHASE_SUBSCRIPTION_PACK
    self.opCodeTrial = OpCode.PURCHASE_SUBSCRIPTION_TRIAL_PACK

    self.durationInDays = 1
    self.allowSkipVideo = false
    self.trialDurationInDay = -1

    self.listBonusReward = List()
end

--- @return void
function SubscriptionProduct:ParseCsv(data)
    if data.id ~= nil then
        ProductConfig.ParseCsv(self, data)
        --- @type number
        self.durationInDays = tonumber(data['duration_in_days'])
        self.allowSkipVideo = MathUtils.ToBoolean(data['allow_skip_video'])
        self.bonusReward = RewardInBound.CreateByParams(data)
        self.trialDurationInDay = tonumber(data['trial_duration_in_days'])
    end
    if data.res_id ~= nil then
        self.listBonusReward:Add(RewardInBound.CreateByParams(data))
    end

    local instantRes = RewardInBound.CreateBySingleParam(tonumber(data['instant_res_type']), tonumber(data['instant_res_id']), tonumber(data['instant_res_number']), tonumber(data['instant_res_data']))
    self.rewardList:Add(instantRes)
end

--- @return number
function SubscriptionProduct:TotalBonusReward()
    return self.durationInDays * self.bonusReward:GetNumber()
end

--- @return List
function SubscriptionProduct:GetTotalListBonusReward()
    local list = List()
    --- @param v RewardInBound
    for _, v in pairs(self.listBonusReward:GetItems()) do
        local total = v:Clone()
        total.number = self.durationInDays * total:GetNumber()
        list:Add(total)
    end
    return list
end

function SubscriptionProduct:ClaimAndShowRewardList()
    --- @type IapDataInBound
    local iap = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    if self.allowSkipVideo == true then
        iap.allowSkipVideo = true
    end
    PopupUtils.ClaimAndShowRewardList(self:GetRewardList())
end

function SubscriptionProduct:IsAvailableToTrial()
    return self.trialDurationInDay > 0
end