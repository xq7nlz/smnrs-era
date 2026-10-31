--- @class UIEventEasterDayLayout : UIEventLayout
UIEventEasterDayLayout = Class(UIEventEasterDayLayout, UIEventLayout)

--- @param view UIEventEasterDayView
--- @param tab EasterDayTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterDayLayout:Ctor(view, tab, anchor)
    --- @type UIEventEasterDayView
    self.view = view
    --- @type EasterDayTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventEasterDayModel
    self.eventModel = nil
    --- @type EventEasterDayConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_EASTER_DAY)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventEasterDayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventEasterDayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventEasterDayLayout:SetEventBanner()
end

function UIEventEasterDayLayout:SetEventTitle()
end

function UIEventEasterDayLayout:SetEventDesc()
end

function UIEventEasterDayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventEasterDayLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_EASTER_DAY)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end