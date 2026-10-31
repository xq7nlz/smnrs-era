--- @class PurchaseBundleItem : MotionIconView
PurchaseBundleItem = Class(PurchaseBundleItem, MotionIconView)

--- @return void
function PurchaseBundleItem:Ctor()
    ---@type PurchaseBundleItemConfig
    self.config = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    MotionIconView.Ctor(self)
end

function PurchaseBundleItem:SetPrefabName()
    self.prefabName = 'purchase_bundle_item'
    self.uiPoolType = UIPoolType.PurchaseBundleItem
end

--- @param transform UnityEngine_Transform
function PurchaseBundleItem:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type PurchaseBundleItemConfig
    self.config = UIBaseConfig(transform)
    self:InitUpdateTime()
end

function PurchaseBundleItem:AddListener(func)
    self:RemoveAllListeners()
    self.config.purchaseButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        if func then
            func()
        end
    end)
end

function PurchaseBundleItem:RemoveAllListeners()
    self.config.purchaseButton.onClick:RemoveAllListeners()
end

---@param productConfig ProductConfig
function PurchaseBundleItem:SetData(productConfig, endTime)
    self.itemsTableView = ItemsTableView(self.config.rewardAnchor)
    self:Localization(productConfig)
    self:SetReward(productConfig)
    self:SetPrice(productConfig)
    self:SetProfit(productConfig)
    if endTime then
        self.config.timeLeftText.gameObject:SetActive(true)
    end
    self:SetEndEventTime(endTime, function()
        if PopupUtils.IsPopupShowing(UIPopupName.UIBoostFirstPurchase) then
            PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, UIPopupName.UIBoostFirstPurchase)
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
        end
    end)
end

---@param productConfig ProductConfig
function PurchaseBundleItem:Localization(productConfig)
    self.config.bundleTitleText.text = LanguageUtils.LocalizeCommon(string.format("boost_first_purchase_title_%d", productConfig.id))
    self.config.bundleTitleDetailText.text = LanguageUtils.LocalizeCommon(string.format("boost_first_purchase_title_detail_%d", productConfig.id))
end

---@param productConfig ProductConfig
function PurchaseBundleItem:SetPrice(productConfig)
    self.config.purchaseText.text = zg.iapMgr:GetLocalPrizeString(productConfig.productID)
end

function PurchaseBundleItem:SetBuyState(isAvailable)
    if not isAvailable then
        self.config.purchaseText.text = LanguageUtils.LocalizeCommon("sold_out")
    end
end

---@param productConfig ProductConfig
function PurchaseBundleItem:SetProfit(productConfig)
    self.config.profitText.text = string.format("%s\n%s", LanguageUtils.LocalizeCommon("profit"), productConfig.profit .. "%")
end

---@param productConfig ProductConfig
function PurchaseBundleItem:SetReward(productConfig)
    local rewardListShow = List()
    for _, reward in ipairs(productConfig.rewardList:GetItems()) do
        rewardListShow:Add(reward)
    end

    if productConfig.eventExtraRewardList:Count() > 0 then
        for _, reward in ipairs(productConfig.eventExtraRewardList:GetItems()) do
            rewardListShow:Add(reward)
        end
    end
    self.itemsTableView:SetData(RewardInBound.GetItemIconDataList(rewardListShow))
end

function PurchaseBundleItem:ReturnPool()
    MotionIconView.ReturnPool(self)
    self:RemoveAllListeners()
    self:RemoveUpdateTime()
    self.config.timeLeftText.gameObject:SetActive(false)
    self.itemsTableView:Hide()
end

--- @param endTime number
--- @param onEventTimeEnded function
function PurchaseBundleItem:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

function PurchaseBundleItem:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function PurchaseBundleItem:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function PurchaseBundleItem:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function PurchaseBundleItem:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.config.timeLeftText.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

return PurchaseBundleItem