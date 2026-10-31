--- @class UIEventLunarPathBundleLayout : UIEventLunarPathLayout
UIEventLunarPathBundleLayout = Class(UIEventLunarPathBundleLayout, UIEventLunarPathLayout)

--- @param view UIEventLunarPathView
--- @param lunarPathTab LunarPathTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarPathBundleLayout:Ctor(view, lunarPathTab, anchor)
    --- @type LunarPathBundleLayoutConfig
    self.layoutConfig = nil
    --- @type EventLunarNewYearModel
    self.eventModel = nil
    --- @type EventLunarNewYearConfig
    self.eventConfig = nil
    --- @type List | UIEventBigBundleItem
    self.packList = nil
    UIEventLunarPathLayout.Ctor(self, view, lunarPathTab, anchor)
end

function UIEventLunarPathBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_path_bundle_layout", self.anchor)
    UIEventLunarPathLayout.InitLayoutConfig(self, inst)
    self:InitPacks()
    self:InitLocalization()
    self:InitButtonListener()
end

function UIEventLunarPathBundleLayout:InitLocalization()

end

function UIEventLunarPathBundleLayout:InitButtonListener()

end

function UIEventLunarPathBundleLayout:InitPacks()
    self.packList = List()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_PATH)
    for i = 1, self.layoutConfig.rectTrans.childCount do
        local packView = UIEventBigBundleItem(self.layoutConfig.rectTrans:GetChild(i - 1))
        self.packList:Add(packView)
    end
end

function UIEventLunarPathBundleLayout:GetModelConfig()
    --- @type EventLunarNewYearModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    --- @type EventLunarNewYearConfig
    self.eventConfig = self.eventModel:GetConfig()
end

function UIEventLunarPathBundleLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarPathBundleLayout:OnShow()
    UIEventLunarPathLayout.OnShow(self)
    local dataId = self.eventModel.timeData.dataId
    local bundleStore = ResourceMgr.GetPurchaseConfig():GetLunarPathStore()
    for i = 1, self.packList:Count() do
        local packId = i
        --- @type UIEventBigBundleItem
        local packItem = self.packList:Get(i)
        packItem:SetLocalizeFunction(function()
            return self:GetBundleName(packId)
        end)
        packItem:OnShow(bundleStore,
                self.eventTimeType,
                EventActionType.LUNAR_PATH_BUNDLE_PURCHASE,
                packId, dataId)
    end
end

function UIEventLunarPathBundleLayout:OnHide()
    UIEventLunarPathLayout.OnHide(self)
end

function UIEventLunarPathBundleLayout:GetBundleName(packId)
    return LanguageUtils.LocalizeCommon(string.format("lunar_path_purchase_%d", packId))
end