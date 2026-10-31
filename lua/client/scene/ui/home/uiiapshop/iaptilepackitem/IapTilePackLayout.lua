--- @class IapTilePackLayout
IapTilePackLayout = Class(IapTilePackLayout)

--- @param iapTilePackItem IapTilePackItem
--- @param opCode OpCode
function IapTilePackLayout:Ctor(iapTilePackItem, packViewType, opCode)
    --- @type IapTilePackItem
    self.item = iapTilePackItem
    --- @type IapTilePackItemConfig
    self.config = iapTilePackItem.config
    --- @type PackViewType
    self.packViewType = packViewType
    --- @type OpCode
    self.opCode = opCode
    --- @type ProductConfig
    self.productConfig = nil
    --- @type ItemsTableView
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    --- @type function
    self.buySuccessListener = nil
end

--- @param data ProductConfig
function IapTilePackLayout:SetData(data, listener)
    self.buySuccessListener = listener
    self:InitData(data)
    self:SetPackKey()
    self:SetUpLayout()
end

function IapTilePackLayout:InitData(data)

end

function IapTilePackLayout:SetPackKey()
    self.packId = self.productConfig.id
    self.packKey = self.productConfig.productID
end

function IapTilePackLayout:SetUpLayout()
    self:SetBgTile()
    self:SetPackIcon()
    self:InitLocalization()
    self:SetReward()
    self:DisableIconMoneyType()
    self:RemoveUpdateTime()
    self:SetTextPrice()
    self:SetTextBuy()
end

function IapTilePackLayout:InitLocalization()

end

function IapTilePackLayout:DisableIconMoneyType()
    if self.config.iconMoneyType then
        self.config.iconMoneyType.gameObject:SetActive(false)
    end
end

function IapTilePackLayout:RemoveUpdateTime()
    if self.updateTime then
        zg.timeMgr:RemoveUpdateFunction(self.updateTime)
    end
end

function IapTilePackLayout:GetBgTile()
    if self.packViewType == PackViewType.DAILY_LIMITED_PACK
            or self.packViewType == PackViewType.WEEKLY_LIMITED_PACK
            or self.packViewType == PackViewType.MONTHLY_LIMITED_PACK
            or self.packViewType == PackViewType.EVENT_BUNDLE then
        return PackViewType.RAW_PACK
    end
    return self.packViewType
end

function IapTilePackLayout:SetBgTile()
    local bgType = self:GetBgTile()
    self.config.bg.sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBgIapShop, tostring(bgType), ComponentName.UnityEngine_Sprite)
    self.config.bgButton.sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBgIapShop, string.format("button_%s", bgType), ComponentName.UnityEngine_Sprite)
    self.config.buttonAds.sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.iconBgIapShop, string.format("button_%s", bgType), ComponentName.UnityEngine_Sprite)
end

function IapTilePackLayout:SetPackIcon()

end

function IapTilePackLayout:EnablePackIcon(isEnable)
    self.config.packIcon.gameObject:SetActive(isEnable)
end

function IapTilePackLayout:SetReward()
    local rewardListShow = List()
    for i, reward in ipairs(self.productConfig.rewardList:GetItems()) do
        rewardListShow:Add(reward)
    end

    if self.productConfig.eventExtraRewardList:Count() > 0 then
        for i, reward in ipairs(self.productConfig.eventExtraRewardList:GetItems()) do
            rewardListShow:Add(reward)
        end
    end

    if self.productConfig.enableVipPointTag then
        --- @type List | RewardInBound[]
        local lessRewardList = List()
        for _, v in ipairs(rewardListShow:GetItems()) do
            --- If reward is vip point then show in vip point tag else show in table reward list icon
            if (v.type == ResourceType.Money and v.id == MoneyType.VIP_POINT) then
                self.config.vip:SetActive(true)
                self.config.textVip.text = v.number
            else
                lessRewardList:Add(v)
            end
        end
        self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(lessRewardList))
        return
    else
        self.config.vip:SetActive(false)
    end
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(rewardListShow))
end

function IapTilePackLayout:SetTextPrice()
    if self.productConfig.isFree ~= true then
        self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("free")
    end
end

function IapTilePackLayout:SetTextBuy()

end

function IapTilePackLayout:OnClickBuy()
    self:RequestBuy()
end

function IapTilePackLayout:RequestBuy()
    BuyUtils.InitListener(function()
        self:OnBuySuccess()
    end, function()
        self:OnBuyFail()
    end)
    self:FireTrackingEvent()
    RxMgr.purchaseProduct:Next(self.packKey)
    print("Request google buy ", self.packKey)
end

function IapTilePackLayout:OnBuySuccess()
    self:SetTextBuy()
    self:SetTextPrice()
    if self.buySuccessListener then
        self.buySuccessListener()
    end
end

function IapTilePackLayout:OnBuyFail()

end

function IapTilePackLayout:FireTrackingEvent()

end

function IapTilePackLayout:OnHide()
    self.config.vip:SetActive(false)
    self.config.buttonAds.gameObject:SetActive(false)
    self:DisableIconMoneyType()
    self:RemoveUpdateTime()
    self:EnablePackIcon(true)
    self.item:SetActiveColor(true)
    self.itemsTableView:Hide()
end

function IapTilePackLayout:DisableCommon()

end