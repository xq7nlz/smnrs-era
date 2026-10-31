--- @class UIChristmasMarketLayout : UIEventChristmasLayout
UIChristmasMarketLayout = Class(UIChristmasMarketLayout, UIEventChristmasLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIChristmasMarketLayout:Ctor(view, tab, anchor)
    ---@type UIEventMidAutumnMarketConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    self.listDataMarket = List()
    self.packViewType = PackViewType.EVENT_CHRISTMAS_BUNDLE
    UIEventChristmasLayout.Ctor(self, view, tab, anchor)
end

function UIChristmasMarketLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_christmas_market_layout", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIChristmasMarketLayout:InitLocalization()
    UIEventChristmasLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_christmas_market_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_christmas_market_des")
end

function UIChristmasMarketLayout:InitItemShow()
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

function UIChristmasMarketLayout:OnPurchaseSuccess()

end

function UIChristmasMarketLayout:InitButtonListener()

end

function UIChristmasMarketLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetChristmas():GetPack(self.eventModel.timeData.dataId).packDict
    self.listDataMarket:Clear()
    --- @param v ProductConfig
    for k, v in ipairs(self.listData:GetItems()) do
        if k > 3 then
            self.listDataMarket:Add(v)
        end
    end
    self.uiScroll:Resize(self.listDataMarket:Count())
end


function UIChristmasMarketLayout:SetUpLayout()
    UIEventChristmasLayout.SetUpLayout(self)
end

function UIChristmasMarketLayout:OnHide()
    UIEventChristmasLayout.OnHide(self)
    self.uiScroll:Hide()
end
