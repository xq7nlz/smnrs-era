--- @class UIEventBirthdayLayout : UIEventLayout
UIEventBirthdayLayout = Class(UIEventBirthdayLayout, UIEventLayout)

--- @param view UIEventBirthdayView
--- @param eventBirthdayTab EventBirthdayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBirthdayLayout:Ctor(view, eventBirthdayTab, anchor)
    --- @type UIEventBirthdayView
    self.view = view
    --- @type EventBirthdayTab
    self.eventBirthdayTab = eventBirthdayTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventBirthdayModel
    self.eventModel = nil
    --- @type EventBirthdayConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_BIRTHDAY
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventBirthdayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventBirthdayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBirthdayLayout:SetEventBanner()
end

function UIEventBirthdayLayout:SetEventTitle()
end

function UIEventBirthdayLayout:SetEventDesc()
end

function UIEventBirthdayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventBirthdayLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventBirthdayLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




