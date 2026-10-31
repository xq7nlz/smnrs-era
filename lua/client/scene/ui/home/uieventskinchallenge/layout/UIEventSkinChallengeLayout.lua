--- @class UIEventSkinChallengeLayout : UIEventLayout
UIEventSkinChallengeLayout = Class(UIEventSkinChallengeLayout, UIEventLayout)

--- @param view UIEventSkinChallengeView
--- @param eventSkinChallengeTab EventSkinChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinChallengeLayout:Ctor(view, eventSkinChallengeTab, anchor)
    --- @type UIEventSkinChallengeView
    self.view = view
    --- @type EventSkinChallengeTab
    self.eventSkinChallengeTab = eventSkinChallengeTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventSkinChallengeModel
    self.eventModel = nil
    --- @type EventSkinChallengeConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_SKIN_CHALLENGE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventSkinChallengeLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventSkinChallengeLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventSkinChallengeLayout:SetEventBanner()
end

function UIEventSkinChallengeLayout:SetEventTitle()
end

function UIEventSkinChallengeLayout:SetEventDesc()
end

function UIEventSkinChallengeLayout:OnShow()
    self.anchor.gameObject:SetActive(true)
    self:GetModelConfig()
end

function UIEventSkinChallengeLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self.view:CheckAllNotificationTab()
    self:OnHide()
end

function UIEventSkinChallengeLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.view.layout = nil;

    self.anchor.gameObject:SetActive(false)
end

function UIEventSkinChallengeLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




