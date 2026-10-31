--- @class UIEventEasterDayShopLayout : UIEventEasterDayLayout
UIEventEasterDayShopLayout = Class(UIEventEasterDayShopLayout, UIEventEasterDayLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventEasterDayShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventEasterDayShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_EASTER_DAY_BUNDLE
    UIEventEasterDayLayout.Ctor(self, view, tab, anchor)
end

function UIEventEasterDayShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_day_shop", self.anchor)
    UIEventEasterDayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventEasterDayShopLayout:InitLocalization()
    UIEventEasterDayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("easter_day_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_easter_day_shop_des")
end

function UIEventEasterDayShopLayout:InitItemShow()
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

function UIEventEasterDayShopLayout:OnPurchaseSuccess()

end

function UIEventEasterDayShopLayout:InitButtonListener()

end

function UIEventEasterDayShopLayout:OnShow()
    UIEventEasterDayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventEasterDayBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventEasterDayShopLayout:SetUpLayout()
    UIEventEasterDayLayout.SetUpLayout(self)
end

function UIEventEasterDayShopLayout:OnHide()
    UIEventEasterDayLayout.OnHide(self)
    self.uiScroll:Hide()
end
