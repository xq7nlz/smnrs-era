--- @class UIEventNewHeroLayout : UIEventLayout
UIEventNewHeroLayout = Class(UIEventNewHeroLayout, UIEventLayout)

--- @param view UIEventNewHeroView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventNewHeroLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEventNewHeroView
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventTimeType
    self.eventTimeType = eventTimeType
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventNewHeroLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventNewHeroLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventNewHeroLayout:SetEventBanner()
end

function UIEventNewHeroLayout:SetEventTitle()
end

function UIEventNewHeroLayout:SetEventDesc()
end

function UIEventNewHeroLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventNewHeroLayout:OnHide()
    self.anchor.gameObject:SetActive(false)
end

function UIEventNewHeroLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




