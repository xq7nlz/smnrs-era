--- @class UIEventHalloweenLayout : UIEventLayout
UIEventHalloweenLayout = Class(UIEventHalloweenLayout, UIEventLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventHalloweenLayout:Ctor(view, halloweenTab, anchor)
    --- @type UIEventHalloweenView
    self.view = view
    --- @type MidAutumnTab
    self.halloweenTab = halloweenTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventHalloweenModel
    self.eventHalloweenModel = nil
    --- @type EventHalloweenConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_HALLOWEEN)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventHalloweenLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventHalloweenLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventHalloweenLayout:SetEventBanner()
end

function UIEventHalloweenLayout:SetEventTitle()
end

function UIEventHalloweenLayout:SetEventDesc()
end

function UIEventHalloweenLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventHalloweenLayout:GetModelConfig()
    self.eventHalloweenModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_HALLOWEEN)
    if self.eventHalloweenModel ~= nil then
        self.eventConfig = self.eventHalloweenModel:GetConfig()
    end
end