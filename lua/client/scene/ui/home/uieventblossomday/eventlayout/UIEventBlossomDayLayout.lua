--- @class UIEventBlossomDayLayout : UIEventLayout
UIEventBlossomDayLayout = Class(UIEventBlossomDayLayout, UIEventLayout)

--- @param view UIEventBlossomDayView
--- @param tab BlossomDayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBlossomDayLayout:Ctor(view, tab, anchor)
    --- @type UIEventBlossomDayView
    self.view = view
    --- @type BlossomDayTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventBlossomDayModel
    self.eventModel = nil
    --- @type EventBlossomDayConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_BLOSSOM)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventBlossomDayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventBlossomDayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBlossomDayLayout:SetEventBanner()
end

function UIEventBlossomDayLayout:SetEventTitle()
end

function UIEventBlossomDayLayout:SetEventDesc()
end

function UIEventBlossomDayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventBlossomDayLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLOSSOM)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end