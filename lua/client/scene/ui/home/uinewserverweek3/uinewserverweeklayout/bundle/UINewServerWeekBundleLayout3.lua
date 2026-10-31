--- @class UINewServerWeekBundle3Layout : UINewServerWeekLayout
UINewServerWeekBundle3Layout = Class(UINewServerWeekBundle3Layout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UINewServerWeekBundle3Layout:Ctor(view, tab, anchor)
    --- @type UINewServerWeekBundleLayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --[[    --- @type EventNewServerWeekModel
        self.eventModel = nil]]
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK_3
    UINewServerWeekLayout.Ctor(self, view, tab, anchor)
    --[[    ---@type EventNewServerWeekConfig
        self.eventConfig = nil]]
    self:InitLayoutConfig()

end

function UINewServerWeekBundle3Layout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_server_week_bundle3_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitItemShow()
end

function UINewServerWeekBundle3Layout:InitItemShow()
    --- @param obj ServerWeekBundleItem3View
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetData(self.newServerWeek3Model.timeData.dataId, index + 1)
    end
    -- XDebug.Log("INIT LAYOUT CONFIG")
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ServerWeekBundleItem3View, onUpdateItem, onUpdateItem)
end

function UINewServerWeekBundle3Layout:InitLocalization()
    --UINewServerWeekLayout.InitLocalization(self)
    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_3_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_3_desc")
end



function UINewServerWeekBundle3Layout:OnShow()
    --self:GetModelConfig()
    UINewServerWeekLayout.OnShow(self)
    self.listPack = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle3():GetPack(self.newServerWeek3Model.timeData.dataId).packList
    self.uiScroll:Resize(self.listPack:Count())
end

function UINewServerWeekBundle3Layout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self.uiScroll:Hide()
end
