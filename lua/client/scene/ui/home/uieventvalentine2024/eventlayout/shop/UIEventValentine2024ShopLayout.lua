--- @class UIEventValentine2024ShopLayout : UIEventValentine2024Layout
UIEventValentine2024ShopLayout = Class(UIEventValentine2024ShopLayout, UIEventValentine2024Layout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventValentine2024ShopLayout:Ctor(view, tab, anchor)
    ---@type UIEventValentine2024ShopLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_VALENTINE_2024_BUNDLE
    UIEventValentine2024Layout.Ctor(self, view, tab, anchor)
end

function UIEventValentine2024ShopLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_2024_shop", self.anchor)
    UIEventValentine2024Layout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventValentine2024ShopLayout:InitLocalization()
    UIEventValentine2024Layout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("valentine_2024_shop")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_valentine_2024_shop_des")
end

function UIEventValentine2024ShopLayout:InitItemShow()
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

function UIEventValentine2024ShopLayout:OnPurchaseSuccess()

end

function UIEventValentine2024ShopLayout:InitButtonListener()

end

function UIEventValentine2024ShopLayout:OnShow()
    UIEventValentine2024Layout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEventValentine2024BundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIEventValentine2024ShopLayout:SetUpLayout()
    UIEventValentine2024Layout.SetUpLayout(self)
end

function UIEventValentine2024ShopLayout:OnHide()
    UIEventValentine2024Layout.OnHide(self)
    self.uiScroll:Hide()
end
