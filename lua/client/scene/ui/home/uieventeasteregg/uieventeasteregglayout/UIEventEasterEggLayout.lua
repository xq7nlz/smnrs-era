--- @class UIEventEasterEggLayout : UIEventLayout
UIEventEasterEggLayout = Class(UIEventEasterEggLayout, UIEventLayout)

--- @param view UIEventEasterEggView
--- @param easterEggTab EasterEggTab
--- @param anchor UnityEngine_RectTransform
function UIEventEasterEggLayout:Ctor(view, easterEggTab, anchor)
    --- @type UIEventEasterEggView
    self.view = view
    --- @type EasterEggTab
    self.easterEggTab = easterEggTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventEasterEggModel
    self.eventModel = nil
    --- @type EventEasterEggConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_EASTER_EGG
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventEasterEggLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventEasterEggLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventEasterEggLayout:SetEventBanner()
end

function UIEventEasterEggLayout:SetEventTitle()
end

function UIEventEasterEggLayout:SetEventDesc()
end

function UIEventEasterEggLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventEasterEggLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventEasterEggLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




