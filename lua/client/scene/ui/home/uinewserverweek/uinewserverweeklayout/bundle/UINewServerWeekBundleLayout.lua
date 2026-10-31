--- @class UINewServerWeekBundleLayout : UINewServerWeekLayout
UINewServerWeekBundleLayout = Class(UINewServerWeekBundleLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UINewServerWeekBundleLayout:Ctor(view, tab, anchor)
    --- @type UINewServerWeekBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
--[[    --- @type EventNewServerWeekModel
    self.eventModel = nil]]
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK
    UINewServerWeekLayout.Ctor(self, view, tab, anchor)
--[[    ---@type EventNewServerWeekConfig
    self.eventConfig = nil]]
    self:InitLayoutConfig()

end

function UINewServerWeekBundleLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_server_week_bundle_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitItemShow()
end

function UINewServerWeekBundleLayout:InitItemShow()
    --- @param obj ServerWeekBundleItemView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetData(self.newServerWeekModel.timeData.dataId, index + 1)
    end
    XDebug.Log("INIT LAYOUT CONFIG")
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ServerWeekBundleItemView, onUpdateItem, onUpdateItem)
end

function UINewServerWeekBundleLayout:InitLocalization()
    --UINewServerWeekLayout.InitLocalization(self)
    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_desc")
end

function UINewServerWeekBundleLayout:GetModelConfig()
     UINewServerWeekLayout.GetModelConfig(self)
end

function UINewServerWeekBundleLayout:OnShow()
    --self:GetModelConfig()
    UINewServerWeekLayout.OnShow(self)
    self.listPack = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle():GetPack(self.newServerWeekModel.timeData.dataId).packList
    self.uiScroll:Resize(self.listPack:Count())
end

function UINewServerWeekBundleLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self.uiScroll:Hide()
end
