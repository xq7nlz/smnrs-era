--- @class UIEventHeroReleaseLayout : UIEventLayout
UIEventHeroReleaseLayout = Class(UIEventHeroReleaseLayout, UIEventLayout)

--- @param view UIEventHeroReleaseView
--- @param eventHeroReleaseTab EventHeroReleaseTab
--- @param anchor UnityEngine_RectTransform
function UIEventHeroReleaseLayout:Ctor(view, eventHeroReleaseTab, anchor)
    --- @type UIEventHeroReleaseView
    self.view = view
    --- @type EventHeroReleaseTab
    self.eventTab = eventHeroReleaseTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventHeroReleaseModel
    self.eventModel = nil
    --- @type EventHeroReleaseConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_HERO_RELEASE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end


--- @param objectView UnityEngine_GameObject
function UIEventHeroReleaseLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventHeroReleaseLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventHeroReleaseLayout:SetEventBanner()
end

function UIEventHeroReleaseLayout:SetEventTitle()
end

function UIEventHeroReleaseLayout:SetEventDesc()
end

function UIEventHeroReleaseLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventHeroReleaseLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventHeroReleaseLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end