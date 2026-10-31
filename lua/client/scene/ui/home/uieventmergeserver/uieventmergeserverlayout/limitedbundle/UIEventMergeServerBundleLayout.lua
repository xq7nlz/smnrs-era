--- @class UIEventMergeServerBundleLayout : UIEventMergeServerLayout
UIEventMergeServerBundleLayout = Class(UIEventMergeServerBundleLayout, UIEventMergeServerLayout)

--- @param view UIEventMergeServerView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventMergeServerBundleLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventMergeServerBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type EventMergeServerModel
    self.eventModel = nil
    self.listPack = List()

    UIEventMergeServerLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventMergeServerBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("merge_server_bundle", self.anchor)
    UIEventMergeServerLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitItemShow()
end

function UIEventMergeServerBundleLayout:InitItemShow()
    --- @param obj LimitedBundleItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetData(self.eventModel.timeData.dataId, index + 1)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.LimitedBundleItemView, onUpdateItem, onUpdateItem)
end

function UIEventMergeServerBundleLayout:InitLocalization()
    UIEventMergeServerLayout.InitLocalization(self)

    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_merge_server_bundle_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_merge_server_bundle_desc")
end

function UIEventMergeServerBundleLayout:GetModelConfig()
    UIEventMergeServerLayout.GetModelConfig(self)

    self.questConfig = self.eventConfig:GetQuestConfig()
end

function UIEventMergeServerBundleLayout:OnShow()
    UIEventMergeServerLayout.OnShow(self)
    self.listPack = ResourceMgr.GetPurchaseConfig():GetMergeServerBundle():GetPack(self.eventModel.timeData.dataId).packList
    self.uiScroll:Resize(self.listPack:Count())
end

function UIEventMergeServerBundleLayout:OnHide()
    UIEventMergeServerLayout.OnHide(self)
    self.uiScroll:Hide()
end
