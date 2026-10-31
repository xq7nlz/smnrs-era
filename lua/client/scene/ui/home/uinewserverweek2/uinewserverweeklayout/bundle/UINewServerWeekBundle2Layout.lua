--- @class UINewServerWeekBundle2Layout : UINewServerWeek2Layout
UINewServerWeekBundle2Layout = Class(UINewServerWeekBundle2Layout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param anchor UnityEngine_RectTransform
function UINewServerWeekBundle2Layout:Ctor(view, tab, anchor)
    --- @type UINewServerWeekBundle2LayoutConfig
    self.layoutConfig = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    --[[    --- @type EventNewServerWeekModel
        self.eventModel = nil]]
    --- @type List
    self.listPack = List()
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_NEW_SERVER_WEEK_2
    UINewServerWeekLayout.Ctor(self, view, tab, anchor)
    --[[    ---@type EventNewServerWeekConfig
        self.eventConfig = nil]]
    self:InitLayoutConfig()

end

function UINewServerWeekBundle2Layout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_new_server_week_bundle2_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)

    self:InitLocalization()

    self:InitItemShow()
end

function UINewServerWeekBundle2Layout:InitItemShow()
    --- @param obj ServerWeekBundleItem2View
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetData(self.newServerWeek2Model.timeData.dataId, index + 1)
    end
   -- XDebug.Log("INIT LAYOUT CONFIG")
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.ServerWeekBundleItem2View, onUpdateItem, onUpdateItem)
end

function UINewServerWeekBundle2Layout:InitLocalization()
    XDebug.Log("INIT LOCALIZE")
    --UINewServerWeekLayout.InitLocalization(self)
    self.layoutConfig.textTittle.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_2_tittle")
    self.layoutConfig.textDesc.text = LanguageUtils.LocalizeCommon("event_server_week_bundle_2_desc")
end



function UINewServerWeekBundle2Layout:OnShow()
    --self:GetModelConfig()
    UINewServerWeekLayout.OnShow(self)
    self.listPack = ResourceMgr.GetPurchaseConfig():GetServerWeekBundle2():GetPack(self.newServerWeek2Model.timeData.dataId).packList
    self.uiScroll:Resize(self.listPack:Count())
end

function UINewServerWeekBundle2Layout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self.uiScroll:Hide()
end
