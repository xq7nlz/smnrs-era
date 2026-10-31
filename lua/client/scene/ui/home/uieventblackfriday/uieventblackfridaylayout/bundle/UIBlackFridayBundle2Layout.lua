--- @class UIBlackFridayBundle2Layout : UIEventBlackFridayLayout
UIBlackFridayBundle2Layout = Class(UIBlackFridayBundle2Layout, UIEventBlackFridayLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIBlackFridayBundle2Layout:Ctor(view, tab, anchor)
    ---@type UIBlackFridayBundleConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY
    --- @type PackViewType
    self.packViewType = PackViewType.BLACK_FRIDAY_BUNDLE
    UIEventBlackFridayLayout.Ctor(self, view, tab, anchor)
end

function UIBlackFridayBundle2Layout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("black_friday_bundle", self.anchor)
    UIEventBlackFridayLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIBlackFridayBundle2Layout:InitLocalization()
    UIEventBlackFridayLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("black_friday_bundle")
end

function UIBlackFridayBundle2Layout:InitItemShow()
    --- @param obj IapTilePackItem
    --- @param index number
    local onUpdateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type LimitedProduct
        local limitedProduct = self.listData:Get(dataIndex)
        obj:SetViewIconData(self.packViewType, limitedProduct, function ()
            self:OnPurchaseSuccess()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.IapTilePackItem, onUpdateItem, onUpdateItem)
end

function UIBlackFridayBundle2Layout:OnPurchaseSuccess()
    self.view:UpdateNotificationByTab(BlackFridayTab.BUNDLE)
end

function UIBlackFridayBundle2Layout:InitButtonListener()

end

function UIBlackFridayBundle2Layout:OnShow()
    UIEventBlackFridayLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetBlackFridayBundleStore():GetPack(self.eventBlackFridayModel.timeData.dataId).packDict
    self.uiScroll:Resize(self.listData:Count())
end


function UIBlackFridayBundle2Layout:SetUpLayout()
    UIEventBlackFridayLayout.SetUpLayout(self)
end

function UIBlackFridayBundle2Layout:OnHide()
    UIEventBlackFridayLayout.OnHide(self)
    self.uiScroll:Hide()
end
