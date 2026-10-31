--- @class UIEventNewYear2023ShopLayout : UIEventNewYear2023Layout
UIEventNewYear2023ShopLayout = Class(UIEventNewYear2023ShopLayout, UIEventNewYear2023Layout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventNewYear2023ShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventNewYear2023ShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_NEW_YEAR_2023_BUNDLE
    UIEventNewYear2023Layout.Ctor(self, view, tab, anchor)
end

function UIEventNewYear2023ShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_2023_shop", self.anchor)
    UIEventNewYear2023Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventNewYear2023ShopLayout:InitLocalization()
    UIEventNewYear2023Layout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("new_year_2023_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_new_year_2023_shop_des")
end

function UIEventNewYear2023ShopLayout:InitItemShow()
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

function UIEventNewYear2023ShopLayout:OnPurchaseSuccess()

end

function UIEventNewYear2023ShopLayout:InitButtonListener()

end

function UIEventNewYear2023ShopLayout:OnShow()
    UIEventNewYear2023Layout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventNewYear2023BundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventNewYear2023ShopLayout:SetUpLayout()
    UIEventNewYear2023Layout.SetUpLayout(self)
end

function UIEventNewYear2023ShopLayout:OnHide()
    UIEventNewYear2023Layout.OnHide(self)
    self.uiScroll:Hide()
end
