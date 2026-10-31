--- @class UIEventSummerDayLayout : UIEventLayout
UIEventSummerDayLayout = Class(UIEventSummerDayLayout, UIEventLayout)

--- @param view UIEventSummerDayView
--- @param tab SummerDayTab
--- @param anchor UnityEngine_RectTransform
function UIEventSummerDayLayout:Ctor(view, tab, anchor)
    --- @type UIEventSummerDayView
    self.view = view
    --- @type SummerDayTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventSummerDayModel
    self.eventModel = nil
    --- @type EventSummerDayConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_SUMMER_DAY)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventSummerDayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventSummerDayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventSummerDayLayout:SetEventBanner()
end

function UIEventSummerDayLayout:SetEventTitle()
end

function UIEventSummerDayLayout:SetEventDesc()
end

function UIEventSummerDayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventSummerDayLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_SUMMER_DAY)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end