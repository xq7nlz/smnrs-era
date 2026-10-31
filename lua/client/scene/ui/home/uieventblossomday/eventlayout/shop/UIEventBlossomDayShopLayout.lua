--- @class UIEventBlossomDayShopLayout : UIEventBlossomDayLayout
UIEventBlossomDayShopLayout = Class(UIEventBlossomDayShopLayout, UIEventBlossomDayLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventBlossomDayShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventBlossomDayShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_BLOSSOM_DAY_BUNDLE
    UIEventBlossomDayLayout.Ctor(self, view, tab, anchor)
end

function UIEventBlossomDayShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("blossom_day_shop", self.anchor)
    UIEventBlossomDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventBlossomDayShopLayout:InitLocalization()
    UIEventBlossomDayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("blossom_day_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_blossom_day_shop_des")
end

function UIEventBlossomDayShopLayout:InitItemShow()
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

function UIEventBlossomDayShopLayout:OnPurchaseSuccess()

end

function UIEventBlossomDayShopLayout:InitButtonListener()

end

function UIEventBlossomDayShopLayout:OnShow()
    UIEventBlossomDayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventBlossomDayBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventBlossomDayShopLayout:SetUpLayout()
    UIEventBlossomDayLayout.SetUpLayout(self)
end

function UIEventBlossomDayShopLayout:OnHide()
    UIEventBlossomDayLayout.OnHide(self)
    self.uiScroll:Hide()
end
