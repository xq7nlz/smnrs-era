--- @class UIEventSummerDayShopLayout : UIEventSummerDayLayout
UIEventSummerDayShopLayout = Class(UIEventSummerDayShopLayout, UIEventSummerDayLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventSummerDayShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventSummerDayShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_SUMMER_DAY_BUNDLE
    UIEventSummerDayLayout.Ctor(self, view, tab, anchor)
end

function UIEventSummerDayShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("summer_day_shop", self.anchor)
    UIEventSummerDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventSummerDayShopLayout:InitLocalization()
    UIEventSummerDayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_summer_day_shop_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_summer_day_shop_des")
end

function UIEventSummerDayShopLayout:InitItemShow()
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

function UIEventSummerDayShopLayout:OnPurchaseSuccess()

end

function UIEventSummerDayShopLayout:InitButtonListener()

end

function UIEventSummerDayShopLayout:OnShow()
    UIEventSummerDayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventSummerDayBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventSummerDayShopLayout:SetUpLayout()
    UIEventSummerDayLayout.SetUpLayout(self)
end

function UIEventSummerDayShopLayout:OnHide()
    UIEventSummerDayLayout.OnHide(self)
    self.uiScroll:Hide()
end
