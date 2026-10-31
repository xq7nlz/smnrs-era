--- @class UIEventEasterBundleLayout : UIEventEasterEggLayout
UIEventEasterBundleLayout = Class(UIEventEasterBundleLayout, UIEventEasterEggLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UIEventEasterBundleLayout:Ctor(view, tab, anchor)
    ---@type UIEventXmasExchangeConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
    --- @type PackViewType
    self.packViewType = PackViewType.EASTER_BUNDLE
    UIEventEasterEggLayout.Ctor(self, view, tab, anchor)
end

function UIEventEasterBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_bundle", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)
    self:InitItemShow()
    self:InitLocalization()
end

function UIEventEasterBundleLayout:InitLocalization()
    UIEventEasterEggLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("easter_bundle")
end

function UIEventEasterBundleLayout:InitItemShow()
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

function UIEventEasterBundleLayout:OnPurchaseSuccess()
    self.view:UpdateNotificationByTab(EasterEggTab.BREAK)
end

function UIEventEasterBundleLayout:InitButtonListener()

end

function UIEventEasterBundleLayout:OnShow()
    UIEventEasterEggLayout.OnShow(self)
    self.listData = ResourceMgr.GetPurchaseConfig():GetEasterDailyBundleStore():GetPack(self.eventModel.timeData.dataId).packDict
    self.uiScroll:Resize(self.listData:Count())
end


function UIEventEasterBundleLayout:SetUpLayout()
    UIEventEasterEggLayout.SetUpLayout(self)
end

function UIEventEasterBundleLayout:OnHide()
    UIEventEasterEggLayout.OnHide(self)
    self.uiScroll:Hide()
end
