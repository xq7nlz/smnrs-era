--- @class UIEventThanksGivingShopLayout : UIEventThanksGivingLayout
UIEventThanksGivingShopLayout = Class(UIEventThanksGivingShopLayout, UIEventThanksGivingLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventThanksGivingShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventThanksGivingShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_THANKS_GIVING_BUNDLE
    UIEventThanksGivingLayout.Ctor(self, view, tab, anchor)
end

function UIEventThanksGivingShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("thanks_giving_shop", self.anchor)
    UIEventThanksGivingLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventThanksGivingShopLayout:InitLocalization()
    UIEventThanksGivingLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_thanks_giving_shop_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_thanks_giving_shop_des")
end

function UIEventThanksGivingShopLayout:InitItemShow()
    --- @param obj IapTilePackItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listDataMarket:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackZodiacItem, onUpdateItem, onUpdateItem)
end

function UIEventThanksGivingShopLayout:OnPurchaseSuccess()

end

function UIEventThanksGivingShopLayout:InitButtonListener()

end

function UIEventThanksGivingShopLayout:OnShow()
    UIEventThanksGivingLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventThanksGivingBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventThanksGivingShopLayout:SetUpLayout()
    UIEventThanksGivingLayout.SetUpLayout(self)
end

function UIEventThanksGivingShopLayout:OnHide()
    UIEventThanksGivingLayout.OnHide(self)
    self.uiScroll:Hide()
end
