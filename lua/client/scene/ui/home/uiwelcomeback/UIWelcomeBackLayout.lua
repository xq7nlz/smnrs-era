--- @class UIWelcomeBackLayout : UIEventLayout
UIWelcomeBackLayout = Class(UIWelcomeBackLayout, UIEventLayout)

--- @param view UIEventEasterEggView
--- @param welcomeBackTab WelcomeBackTab
--- @param anchor UnityEngine_RectTransform
function UIWelcomeBackLayout:Ctor(view, welcomeBackTab, anchor)
    --- @type UIWelcomeBackView
    self.view = view
    --- @type WelcomeBackTab
    self.welcomeBackTab = welcomeBackTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventEasterEggModel
    self.eventModel = nil
    --- @type EventEasterEggConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIWelcomeBackLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIWelcomeBackLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIWelcomeBackLayout:SetEventBanner()
end

function UIWelcomeBackLayout:SetEventTitle()
end

function UIWelcomeBackLayout:SetEventDesc()
end

function UIWelcomeBackLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIWelcomeBackLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIWelcomeBackLayout:GetModelConfig()

end

function UIWelcomeBackLayout:SetEventBanner()
end

function UIWelcomeBackLayout:SetEventTitle()
end

function UIWelcomeBackLayout:SetEventDesc()
end




