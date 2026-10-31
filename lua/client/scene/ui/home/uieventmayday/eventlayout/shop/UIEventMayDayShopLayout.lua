--- @class UIEventMayDayShopLayout : UIEventMayDayLayout
UIEventMayDayShopLayout = Class(UIEventMayDayShopLayout, UIEventMayDayLayout)

--- @param view UIEventMayDayView
--- @param anchor UnityEngine_RectTransform
function UIEventMayDayShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventMayDayShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_MAY_DAY_BUNDLE
    UIEventMayDayLayout.Ctor(self, view, tab, anchor)
end

function UIEventMayDayShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("may_day_shop", self.anchor)
    UIEventMayDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventMayDayShopLayout:InitLocalization()
    UIEventMayDayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("may_day_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_may_day_shop_des")
end

function UIEventMayDayShopLayout:InitItemShow()
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

function UIEventMayDayShopLayout:OnPurchaseSuccess()

end

function UIEventMayDayShopLayout:InitButtonListener()

end

function UIEventMayDayShopLayout:OnShow()
    UIEventMayDayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventMayDayBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventMayDayShopLayout:SetUpLayout()
    UIEventMayDayLayout.SetUpLayout(self)
end

function UIEventMayDayShopLayout:OnHide()
    UIEventMayDayLayout.OnHide(self)
    self.uiScroll:Hide()
end
