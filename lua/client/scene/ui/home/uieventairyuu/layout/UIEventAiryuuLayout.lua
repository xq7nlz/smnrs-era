--- @class UIEventAiryuuLayout : UIEventLayout
UIEventAiryuuLayout = Class(UIEventAiryuuLayout, UIEventLayout)

--- @param view UIEventAiryuuView
--- @param eventAiryuuTab EventAiryuuTab
--- @param anchor UnityEngine_RectTransform
function UIEventAiryuuLayout:Ctor(view, eventAiryuuTab, anchor)
    --- @type UIEventAiryuuView
    self.view = view
    --- @type EventAiryuuTab
    self.eventAiryuuTab = eventAiryuuTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventAiryuuModel
    self.eventModel = nil
    --- @type EventAiryuuConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_AIRYUU
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventAiryuuLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventAiryuuLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventAiryuuLayout:SetEventBanner()
end

function UIEventAiryuuLayout:SetEventTitle()
end

function UIEventAiryuuLayout:SetEventDesc()
end

function UIEventAiryuuLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventAiryuuLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventAiryuuLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil
    self.view.config.backGroundCover.gameObject:SetActive(false)
    self.anchor.gameObject:SetActive(false)
end

function UIEventAiryuuLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




