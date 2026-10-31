--- @class UIEventChristmasLayout : UIEventLayout
UIEventChristmasLayout = Class(UIEventChristmasLayout, UIEventLayout)

--- @param view UIEventChristmasView
--- @param tab ChristmasTab
--- @param anchor UnityEngine_RectTransform
function UIEventChristmasLayout:Ctor(view, tab, anchor)
    --- @type UIEventMidAutumnView
    self.view = view
    --- @type ChristmasTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventChristmasModel
    self.eventModel = nil
    --- @type EventChristmasConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_CHRISTMAS)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventChristmasLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventChristmasLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventChristmasLayout:SetEventBanner()
end

function UIEventChristmasLayout:SetEventTitle()
end

function UIEventChristmasLayout:SetEventDesc()
end

function UIEventChristmasLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventChristmasLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_CHRISTMAS)
    self.eventConfig = self.eventModel:GetConfig()
end