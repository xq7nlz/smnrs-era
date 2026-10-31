--- @class UIEventLunarNewYear2024ShopLayout : UIEventLunarNewYear2024Layout
UIEventLunarNewYear2024ShopLayout = Class(UIEventLunarNewYear2024ShopLayout, UIEventLunarNewYear2024Layout)

--- @param view UIEventLunarNewYear2024View
--- @param anchor UnityEngine_RectTransform
function UIEventLunarNewYear2024ShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventLunarNewYear2024ShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_LUNAR_NEW_YEAR_2024_BUNDLE
    UIEventLunarNewYear2024Layout.Ctor(self, view, tab, anchor)
end

function UIEventLunarNewYear2024ShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_2024_shop", self.anchor)
    UIEventLunarNewYear2024Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventLunarNewYear2024ShopLayout:InitLocalization()
    UIEventLunarNewYear2024Layout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("lunar_new_year_2024_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_2024_shop_des")
end

function UIEventLunarNewYear2024ShopLayout:InitItemShow()
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

function UIEventLunarNewYear2024ShopLayout:OnPurchaseSuccess()

end

function UIEventLunarNewYear2024ShopLayout:InitButtonListener()

end

function UIEventLunarNewYear2024ShopLayout:OnShow()
    UIEventLunarNewYear2024Layout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventLunarNewYear2024BundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventLunarNewYear2024ShopLayout:SetUpLayout()
    UIEventLunarNewYear2024Layout.SetUpLayout(self)
end

function UIEventLunarNewYear2024ShopLayout:OnHide()
    UIEventLunarNewYear2024Layout.OnHide(self)
    self.uiScroll:Hide()
end
