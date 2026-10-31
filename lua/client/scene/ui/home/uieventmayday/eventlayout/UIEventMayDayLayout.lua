--- @class UIEventMayDayLayout : UIEventLayout
UIEventMayDayLayout = Class(UIEventMayDayLayout, UIEventLayout)

--- @param view UIEventMayDayView
--- @param tab MayDayTab
--- @param anchor UnityEngine_RectTransform
function UIEventMayDayLayout:Ctor(view, tab, anchor)
    --- @type UIEventMayDayView
    self.view = view
    --- @type MayDayTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventMayDayModel
    self.eventModel = nil
    --- @type EventMayDayConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_MAY_DAY)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventMayDayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventMayDayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventMayDayLayout:SetEventBanner()
end

function UIEventMayDayLayout:SetEventTitle()
end

function UIEventMayDayLayout:SetEventDesc()
end

function UIEventMayDayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventMayDayLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MAY_DAY)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end