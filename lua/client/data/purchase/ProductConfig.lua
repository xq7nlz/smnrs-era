--- @class ProductConfig
ProductConfig = Class(ProductConfig)

--- @return void
function ProductConfig:Ctor()
    ---@type string
    self.premiumSuffix = ".premium"

    --- @type number
    self.id = nil
    --- @type number
    self.dataId = nil -- use when the same opCode but can config others data
    --- @type OpCode
    self.opCode = nil
    --- @type number
    self.dollarPrice = nil
    --- @type RewardInBound
    self.bonusReward = nil
    --- @type string
    self.productID = nil
    --- @type number
    self.stock = nil
    --- @type boolean
    self.isLimited = false
    --- @type List | <RewardInBound>
    self.rewardList = List()
    --- @type List | <RewardInBound>
    self.rewardResult = List()
    --- @type List | <RewardInBound>
    self.bonusRewardList = List()
    --- @type List | <RewardInBound>
    self.eventExtraRewardList = List()
    --- @type boolean
    self.isFree = false
    --- @type number
    self.numberFree = nil
    --- @type number
    self.numberWatchAds = nil
    --- @type string
    self.sungameProductId = nil
    --- @type string
    self.sungameWebProductId = nil
    --- @type PackViewType
    self.viewType = nil
    --- @type string
    self.androidPackageName = nil
    --- @type boolean
    self.enableVipPointTag = false
    --- @type number
    self.priceType = nil
    ---@type number
    self.resetType = nil
    ---@type number
    self.profit = nil
    ---@type number
    self.profitPercent = nil
end

--- @return void
--- @param data string
function ProductConfig:ParseCsv(data)
    self.id = tonumber(data["id"])

    local androidPackageNameKey = self:GetPackageNameConfigKey(DeviceOs.Android)
    local iosPackageNameKey = self:GetPackageNameConfigKey(DeviceOs.iPhone)
    self.androidPackageName = data[androidPackageNameKey]

    if (IS_PREMIUM_VERSION) then
        self.iosPackageName = data[iosPackageNameKey] .. self.premiumSuffix
    else
        self.iosPackageName = data[iosPackageNameKey]
    end

    self.dollarPrice = data["price"]
    self.stock = tonumber(data["stock"])
    --- @type number
    self.numberWatchAds = tonumber(data["number_watch_ads"])
    --- @type number
    self.numberFree = tonumber(data["number_free"])
    --- @type PackViewType
    self.viewType = tonumber(data["view_type"])
    --- @type number
    self.profitPercent = tonumber(data["profit"])
    --- @type number
    self.priceType = tonumber(data["price_type"])
    --- @type number
    self.resetType = tonumber(data["reset_type"])

    local free = data["is_free"]
    if free ~= nil then
        self.isFree = MathUtils.ToBoolean(free)
    else
        self.isFree = false
    end
end

--- @return void
function ProductConfig:SetKey()
    self.productID = ClientConfigUtils.GetPurchaseKey(self.opCode, self.id, self.dataId)
end

--- @return number, List
function ProductConfig:GetReward(_list)
    ---@type List
    local list = _list or self.rewardList
    local vipReward = nil
    local rewardList = List()
    --- @param v RewardInBound
    for _, v in ipairs(list:GetItems()) do
        if v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT then
            vipReward = v.number
        else
            rewardList:Add(v)
        end
    end
    return vipReward, rewardList
end

--- @return List -- RewardInBound
function ProductConfig:GetRewardList()
    return self.rewardList
end

function ProductConfig:ClaimAndShowRewardList()
    ---@type List <RewardInBound>
    local rewardList = List()
    for i, v in ipairs(self.rewardList:GetItems()) do
        rewardList:Add(v)
    end
    if self.bonusReward ~= nil then
        rewardList:Add(self.bonusReward)
    end
    if self.bonusRewardList:Count() ~= 0 then
        for i, v in ipairs(self.bonusRewardList:GetItems()) do
            rewardList:Add(v)
        end
    end
    if self.listSelectReward ~= nil then
        for i, v in ipairs(self.listSelectReward:GetItems()) do
            rewardList:Add(v)
        end
    end
    if self.eventExtraRewardList:Count() > 0 then
        for i, v in ipairs(self.eventExtraRewardList:GetItems()) do
            rewardList:Add(v)
        end
    end
    PopupUtils.ClaimAndShowRewardList(rewardList)
end

function ProductConfig:GetPackageNameByDeviceOs(deviceOs)
    deviceOs = deviceOs or ClientConfigUtils.GetDeviceOS()
    if deviceOs == DeviceOs.iPhone then
        return self.iosPackageName
    else
        return self.androidPackageName
    end
end

--- @return string
--- @param deviceOs DeviceOs
function ProductConfig:GetPackageNameConfigKey(deviceOs)
    if deviceOs == DeviceOs.Android then
        return "android_package_name"
    elseif deviceOs == DeviceOs.iPhone then
        return "ios_package_name"
    end
end

--- @return string
function ProductConfig:GetSungamePackId()
    return self.sungameProductId
end

--- @return string
function ProductConfig:GetSungameWebPackId()
    return self.sungameWebProductId
end