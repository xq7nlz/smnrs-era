--- @class PurchaseLevelItem
PurchaseLevelItem = Class(PurchaseLevelItem)

--- @param anchor UnityEngine_RectTransform
function PurchaseLevelItem:Ctor(anchor)
    --- @type PurchaseLevelItemConfig
    self.config = UIBaseConfig(anchor)
    --- @type List
    self.listIconView = List()
end

function PurchaseLevelItem:AddButtonListener(func)
    self.config.buttonPurchase.onClick:RemoveAllListeners()
    self.config.buttonPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function PurchaseLevelItem:InitLocalization(bundleLocalize)
    self.config.textTittle.text = LanguageUtils.LocalizeCommon(bundleLocalize)
    self.config.textWatchAds.text = LanguageUtils.LocalizeCommon("watch")
end

--- @param productConfig ProductConfig
function PurchaseLevelItem:SetButtonText(productConfig, numberBuy, remainWatchAds)
    self:EnableTextWatchAds(productConfig.priceType == IapPackPriceType.WATCH_ADS)
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
    if productConfig.stock > 0 then
        if numberBuy then
            self.config.textLimit.gameObject:SetActive(true)
            self.config.textLimit.text = string.format("%s : %s/%s", LanguageUtils.LocalizeCommon("limit"), numberBuy, productConfig.stock)
            UIUtils.SetActiveColorByMaterial(self.config.buttonPurchase, numberBuy < productConfig.stock, "ui_gray_mat")
        else
            self.config.textLimit.gameObject:SetActive(false)
        end
    end
    if productConfig.priceType == IapPackPriceType.WATCH_ADS and remainWatchAds then
        self.config.textLimit.gameObject:SetActive(true)
        self.config.textLimit.text = string.format("%s : %s", LanguageUtils.LocalizeCommon("remaining"), remainWatchAds)
        UIUtils.SetActiveColorByMaterial(self.config.buttonPurchase, remainWatchAds > 0, "ui_gray_mat")
        if remainWatchAds <= 0 then
            self:AddButtonListener(function()
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("sold_out"))
            end)
        end
    end
end

--- @param productConfig ProductConfig
function PurchaseLevelItem:SetRewardAnchor(productConfig)
    local listIconData = RewardInBound.GetItemIconDataList(productConfig:GetRewardList())
    ---@param v ItemIconData
    for _, v in pairs(listIconData:GetItems()) do
        --- @type RootIconView
        local iconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardHolder)
        iconView:SetIconData(v)
        iconView:RegisterShowInfo()
        self.listIconView:Add(iconView)
    end
end

function PurchaseLevelItem:ReturnPoolListReward()
    --- @param v RootIconView
    for _, v in pairs(self.listIconView:GetItems()) do
        v:ReturnPool()
    end
    self.listIconView:Clear()
end

function PurchaseLevelItem:EnableTextWatchAds(isEnable)
    self.config.textPrice.gameObject:SetActive(not isEnable)
    self.config.textWatchAds.gameObject:SetActive(isEnable)
end

function PurchaseLevelItem:ReturnPool()
    self.config.buttonPurchase.onClick:RemoveAllListeners()
    self:EnableTextWatchAds(false)
    self:ReturnPoolListReward()
end