--- @class UIEventThanksGivingLayout : UIEventLayout
UIEventThanksGivingLayout = Class(UIEventThanksGivingLayout, UIEventLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventThanksGivingLayout:Ctor(view, halloweenTab, anchor)
    --- @type UIEventHalloweenView
    self.view = view
    --- @type MidAutumnTab
    self.halloweenTab = halloweenTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventThankGivingModel
    self.eventModel = nil
    --- @type EventThanksGivingConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_THANKS_GIVING)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventThanksGivingLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventThanksGivingLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventThanksGivingLayout:SetEventBanner()
end

function UIEventThanksGivingLayout:SetEventTitle()
end

function UIEventThanksGivingLayout:SetEventDesc()
end

function UIEventThanksGivingLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventThanksGivingLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_THANKS_GIVING)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end