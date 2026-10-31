--- @class UIEventMidAutumnLayout : UIEventLayout
UIEventMidAutumnLayout = Class(UIEventMidAutumnLayout, UIEventLayout)

--- @param view UIEventMidAutumnView
--- @param midAutumnTab MidAutumnTab
--- @param anchor UnityEngine_RectTransform
function UIEventMidAutumnLayout:Ctor(view, midAutumnTab, anchor)
    --- @type UIEventMidAutumnView
    self.view = view
    --- @type MidAutumnTab
    self.midAutumnTab = midAutumnTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventMidAutumnModel
    self.eventMidAutumnModel = nil
    --- @type EventMidAutumnConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_MID_AUTUMN)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventMidAutumnLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventMidAutumnLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventMidAutumnLayout:SetEventBanner()
end

function UIEventMidAutumnLayout:SetEventTitle()
end

function UIEventMidAutumnLayout:SetEventDesc()
end

function UIEventMidAutumnLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventMidAutumnLayout:GetModelConfig()
    self.eventMidAutumnModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_MID_AUTUMN)
    self.eventConfig = self.eventMidAutumnModel:GetConfig()
end