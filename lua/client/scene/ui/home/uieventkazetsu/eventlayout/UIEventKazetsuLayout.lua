--- @class UIEventKazetsuLayout : UIEventLayout
UIEventKazetsuLayout = Class(UIEventKazetsuLayout, UIEventLayout)

--- @param view UIEventKazetsuView
--- @param newYearTab EventKazetsuTab
--- @param anchor UnityEngine_RectTransform
function UIEventKazetsuLayout:Ctor(view, newYearTab, anchor)
    --- @type UIEventKazetsuView
    self.view = view
    --- @type EventKazetsuTab
    self.eventKazetsuTab = newYearTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventKazetsuModel
    self.eventModel = nil
    --- @type EventKazetsuConfig
    self.eventConfig = nil
    self.opCode = OpCode.EVENT_KAZETSU_DAILY_LOGIN_CLAIM
    self.eventTimeType = EventTimeType.EVENT_KAZETSU
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventKazetsuLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventKazetsuLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventKazetsuLayout:SetEventBanner()
end

function UIEventKazetsuLayout:SetEventTitle()
end

function UIEventKazetsuLayout:SetEventDesc()
end

function UIEventKazetsuLayout:OnShow()
    UIEventLayout.OnShow(self)
end

function UIEventKazetsuLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventKazetsuLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end