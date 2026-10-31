require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.bundle.UIEventNewYearBundleItemView"

--- @class UIEventNewYearBundleLayout : UIEventNewYearLayout
UIEventNewYearBundleLayout = Class(UIEventNewYearBundleLayout, UIEventNewYearLayout)

--- @param view UIEventNewYear
--- @param anchor UnityEngine_RectTransform
function UIEventNewYearBundleLayout:Ctor(view, tab, anchor)
    --- @type UIEventNewYearBundleLayout
    self.layoutConfig = nil
    --- @type UISpecialOfferHalloweenItemView
    self.packList = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_YEAR
    --- @type PackViewType
    self.packViewType = PackViewType.EVENT_NEW_YEAR_BUNDLE
    UIEventNewYearLayout.Ctor(self, view, tab, anchor)
end

function UIEventNewYearBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_bundle", self.anchor)
    UIEventNewYearLayout.InitLayoutConfig(self, inst)
    self:InitPacks()
end

function UIEventNewYearBundleLayout:InitLocalization()
    UIEventNewYearLayout.InitLocalization(self)
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("new_year_bundle")
end

function UIEventNewYearBundleLayout:OnPurchaseSuccess()
    --self.view:UpdateNotificationByTab(BlackFridayTab.BUNDLE)
end

function UIEventNewYearBundleLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UIEventNewYearBundleItemView(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end

function UIEventNewYearBundleLayout:OnShow()
    UIEventNewYearLayout.OnShow(self)
    for i = 1, self.packList:Count() do
        --- @type UIEventNewYearBundleItemView
        local packItem = self.packList:Get(i)
        packItem:OnShow(i, self.eventModel.timeData.dataId)
    end
end


function UIEventNewYearBundleLayout:SetUpLayout()
    UIEventNewYearLayout.SetUpLayout(self)
end

function UIEventNewYearBundleLayout:OnHide()
    UIEventNewYearLayout.OnHide(self)
end
